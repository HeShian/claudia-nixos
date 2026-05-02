# =============================================================================
# 文件名:   home/rime.nix
# 功能描述: Rime 输入法配置（霧淞拼音 + 小鹤双拼）
# 说明:     home.activation 写入 default.yaml + 部署 rime-ice 词典
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
in
{
  # ===========================================================================
  # 全部通过 home.activation 以真实文件部署。
  # 不使用 home.file（符号链接会被 rime 部署过程删除）
  # ===========================================================================
  home.activation.deployRimeIce = lib.hm.dag.entryAfter ["writeBoundary"] ''
    RIME_DIR="$HOME/.local/share/fcitx5/rime"
    RIME_ICE_DIR="${rimeIce}/share/rime-data"

    mkdir -p "$RIME_DIR"

    # --- 1. default.yaml — 决定启用哪些输入方案 ---
    cat > "$RIME_DIR/default.yaml" << 'DEFAULT_EOF'
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
    DEFAULT_EOF

    if [ ! -d "$RIME_ICE_DIR" ]; then
      echo "[rime] WARNING: rime-ice data NOT found at $RIME_ICE_DIR"
      exit 0
    fi

    # --- 2. 复制 rime-ice 词典文件（跳过 default.yaml）---
    for f in "$RIME_ICE_DIR"/*.yaml "$RIME_ICE_DIR"/*.txt; do
      basename=$(basename "$f")
      [ "$basename" = "default.yaml" ] && continue
      target="$RIME_DIR/$basename"
      if [ ! -f "$target" ] || [ -L "$target" ]; then
        cp -f "$f" "$target" 2>/dev/null || true
      fi
    done

    # --- 3. 复制子目录（cn_dicts, en_dicts, lua, opencc）---
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
}
