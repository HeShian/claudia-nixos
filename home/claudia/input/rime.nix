# =============================================================================
# 文件名:   home/rime.nix
# 功能描述: Rime 输入法配置（霧淞拼音 + 小鹤双拼）
# 说明:     home.activation + systemd path 守护 default.yaml，防止被 rime 覆盖
#
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  Rime 使用指南                                                          ║
# ║                                                                          ║
# ║  Super+Space 切换到 Rime 输入法后：                                     ║
# ║  Ctrl+` 打开方案菜单 → 选择 霧淞拼音 或 小鹤双拼                       ║
# ║                                                                          ║
# ║  如果方案不见了：Ctrl+` → 选"部署"                                      ║
# ║  如果 Rime 没反应：pkill fcitx5 && sleep 1 && fcitx5 -d                 ║
# ╚══════════════════════════════════════════════════════════════════════════╝
# =============================================================================
{ config, pkgs, lib, ... }:

let
  rimeIce = pkgs.rime-ice;

  # default.yaml 的内容（写入 nix store，供 systemd path 恢复使用）
  rimeDefaultYaml = pkgs.writeText "rime-default.yaml" ''
    schema_list:
      - schema: rime_ice
      - schema: double_pinyin_flypy

    switcher:
      caption: 方案选择
      hotkeys:
        - Control+grave
      save_options:
        - full_shape
        - ascii_punct
        - simplification
      fold_options: true
      abbreviate_options: true

    menu:
      page_size: 6

    punctuator:
      full_shape:
        '\\' : [ 、, ＼ ]
        ',' : { commit: ， }
        '.' : { commit: 。 }
      half_shape:
        '\\' : [ 、, ＼ ]
        ',' : { commit: ， }
        '.' : { commit: 。 }

    key_binder:
      bindings:
        - { when: composing, accept: Tab, send: Page_Down }
        - { when: composing, accept: Shift+Tab, send: Page_Up }

    recognizer:
      patterns:
        email: "^[A-Za-z][-_.0-9A-Za-z]*@.*$"
        uppercase: "[A-Z][-_+.'0-9A-Za-z]*$"
        url: "^(www[.]|https?:|ftp[.:]|mailto:|file:).*$|^[a-z]+[.].+$"

    ascii_composer:
      good_old_caps_lock: true
      switch_key:
        Shift_L: inline_ascii
        Shift_R: commit_text
  '';

  # 恢复脚本 + 重新编译
  rimeDeployer = "${pkgs.librime}/bin/rime_deployer";
  restoreScript = pkgs.writeShellScript "restore-rime-default-yaml" ''
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    DEFAULT_YAML="$RIME_DIR/default.yaml"

    if [ ! -f "$DEFAULT_YAML" ] || ! grep -q "rime_ice" "$DEFAULT_YAML" 2>/dev/null; then
      rm -f "$DEFAULT_YAML" 2>/dev/null
      cp "${rimeDefaultYaml}" "$DEFAULT_YAML"
      chmod u+w "$DEFAULT_YAML"
      "${rimeDeployer}" --build "$RIME_DIR" 2>/dev/null || true
      echo "[rime] default.yaml restored + schemas recompiled"
    fi
  '';

  # 定时检查：每 30 秒确保 default.yaml 和编译缓存正确
  periodicCheckScript = pkgs.writeShellScript "periodic-rime-check" ''
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    BUILD_DEFAULT="$RIME_DIR/build/default.yaml"

    if [ -f "$BUILD_DEFAULT" ] && ! grep -q "rime_ice" "$BUILD_DEFAULT" 2>/dev/null; then
      rm -f "$RIME_DIR/default.yaml" 2>/dev/null
      cp "${rimeDefaultYaml}" "$RIME_DIR/default.yaml"
      chmod u+w "$RIME_DIR/default.yaml"
      rm -f "$RIME_DIR"/build/*.prism.bin "$RIME_DIR"/build/*.table.bin \
            "$RIME_DIR"/build/*.reverse.bin "$RIME_DIR"/build/*.schema.yaml \
            "$RIME_DIR"/build/default.yaml 2>/dev/null
      "${rimeDeployer}" --build "$RIME_DIR" 2>/dev/null || true
      echo "[rime] build cache corrected"
    fi
  '';
in
{
  # ===========================================================================
  # 1. home.activation：构建时部署 rime-ice 数据 + default.yaml
  # ===========================================================================
  home.activation.deployRimeIce = lib.hm.dag.entryAfter ["writeBoundary"] ''
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    RIME_ICE_DIR="${rimeIce}/share/rime-data"

    mkdir -p "$RIME_DIR"

    # 写入 default.yaml（先删除只读旧文件）
    rm -f "$RIME_DIR/default.yaml" 2>/dev/null
    cp "${rimeDefaultYaml}" "$RIME_DIR/default.yaml"
    chmod u+w "$RIME_DIR/default.yaml"

    if [ ! -d "$RIME_ICE_DIR" ]; then
      echo "[rime] WARNING: rime-ice data NOT found at $RIME_ICE_DIR"
      exit 0
    fi

    # 复制 rime-ice 词典文件
    for f in "$RIME_ICE_DIR"/*.yaml "$RIME_ICE_DIR"/*.txt; do
      basename=$(basename "$f")
      [ "$basename" = "default.yaml" ] && continue
      target="$RIME_DIR/$basename"
      if [ ! -f "$target" ] || [ -L "$target" ]; then
        cp -f "$f" "$target" 2>/dev/null || true
      fi
    done

    # 复制子目录
    for SUB in cn_dicts en_dicts lua opencc; do
      if [ -d "$RIME_ICE_DIR/$SUB" ]; then
        mkdir -p "$RIME_DIR/$SUB"
        for f in "$RIME_ICE_DIR/$SUB"/*; do
          basename=$(basename "$f")
          target="$RIME_DIR/$SUB/$basename"
          if [ ! -f "$target" ] || [ -L "$target" ]; then
            cp -f "$f" "$target" 2>/dev/null || true
          fi
        done
      fi
    done

    echo "[rime] default.yaml + rime-ice data deployed"
  '';

  # ===========================================================================
  # 2. systemd path unit：监控 rime 目录，default.yaml 丢失或错误时恢复
  # ===========================================================================
  systemd.user.services.rime-restore-default-yaml = {
    Unit = {
      Description = "Restore rime default.yaml if deleted by fcitx5";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${restoreScript}";
    };
  };

  systemd.user.paths.rime-restore-default-yaml = {
    Path = {
      PathChanged = "%h/.local/share/fcitx5/rime";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # ===========================================================================
  # 3. systemd timer：每 30 秒检查编译缓存是否正确
  # ===========================================================================
  systemd.user.services.rime-periodic-check = {
    Unit = {
      Description = "Periodic check rime build cache";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${periodicCheckScript}";
    };
  };

  systemd.user.timers.rime-periodic-check = {
    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
