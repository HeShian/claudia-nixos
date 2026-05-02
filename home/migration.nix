# =============================================================================
# 文件名:   home/migration.nix
# 功能描述: 从 ~/.config/ 迁移至 Home Manager 管理的配置文件
# 说明:     所有之前未受 Nix 管理的配置文件统一在此管理，
#           确保系统配置的完整可复现性
# =============================================================================
{ config, pkgs, lib, ... }:

let
  # =========================================================================
  # Fcitx5 Dracula 自定义主题
  # =========================================================================
  fcitx5-dracula-theme = pkgs.stdenv.mkDerivation {
    name = "fcitx5-dracula-theme";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/fcitx5/themes/Dracula
      cat > $out/share/fcitx5/themes/Dracula/theme.conf << 'THEME_EOF'
      [Metadata]
      Name=Dracula
      Version=1.0
      Author=Claudia
      Description=Dracula Dark Theme for Fcitx5
      ScaleWithDPI=True

      [InputPanel]
      Font=Sans 13
      NormalColor=#f8f8f2
      HighlightCandidateColor=#bd93f9
      HighlightColor=#f8f8f2
      HighlightBackgroundColor=#44475a
      Spacing=3

      [InputPanel/TextMargin]
      Left=10
      Right=10
      Top=6
      Bottom=6

      [InputPanel/Background]
      Color=#282a36

      [InputPanel/Background/Margin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [InputPanel/Highlight]
      Color=#44475a

      [InputPanel/Highlight/Margin]
      Left=10
      Right=10
      Top=7
      Bottom=7

      [Menu]
      Font=Sans 10
      NormalColor=#f8f8f2
      Spacing=3

      [Menu/Background]
      Color=#282a36

      [Menu/Background/Margin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [Menu/ContentMargin]
      Left=2
      Right=2
      Top=2
      Bottom=2

      [Menu/Highlight]
      Color=#44475a

      [Menu/Highlight/Margin]
      Left=10
      Right=10
      Top=5
      Bottom=5

      [Menu/Separator]
      Color=#44475a

      [Menu/CheckBox]
      Image=radio.png

      [Menu/SubMenu]
      Image=arrow.png

      [Menu/TextMargin]
      Left=5
      Right=5
      Top=5
      Bottom=5
      THEME_EOF

      cp ${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/arrow.png $out/share/fcitx5/themes/Dracula/arrow.png
      cp ${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/radio.png $out/share/fcitx5/themes/Dracula/radio.png
    '';
  };

  # =========================================================================
  # Noctalia 默认配置（作为初始值，首次部署后由 Noctalia 自行管理）
  # 使用 home.activation 而非 xdg.configFile，因为 xdg.configFile 创建的是
  # nix store 的只读符号链接，Noctalia 无法写入 → UI 修改全部静默失败
  # =========================================================================
  noctaliaDefaults = pkgs.runCommand "noctalia-defaults" {} ''
    mkdir -p $out/noctalia

    cat > $out/noctalia/colors.json << 'COLORS_EOF'
    ${builtins.toJSON {
      mPrimary = "#5ed4fd";
      mOnPrimary = "#003544";
      mSecondary = "#b3cad5";
      mOnSecondary = "#1e333c";
      mTertiary = "#c4c3eb";
      mOnTertiary = "#2d2d4d";
      mError = "#ffb4ab";
      mOnError = "#690005";
      mSurface = "#111415";
      mOnSurface = "#e1e3e4";
      mSurfaceVariant = "#1d2022";
      mOnSurfaceVariant = "#c0c8cc";
      mOutline = "#40484c";
    }}
    COLORS_EOF

    cat > $out/noctalia/settings.json << 'SETTINGS_EOF'
    ${builtins.toJSON {
      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
      };
    }}
    SETTINGS_EOF

    cat > $out/noctalia/plugins.json << 'PLUGINS_EOF'
    ${builtins.toJSON {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = { };
      version = 2;
    }}
    PLUGINS_EOF
  '';

  # =========================================================================
  # Hyprland Noctalia 颜色配置（noctalia-shell 模板管线在运行时生成的
  # noctalia-colors.conf 的默认版本）。颜色值与 colors.json 保持一致。
  # noctalia-shell 首次运行时会用自己的调色板覆盖此文件。
  # =========================================================================
  noctaliaHyprColorsDefaults = pkgs.runCommand "noctalia-hypr-colors" {} ''
    mkdir -p $out
    cat > $out/noctalia-colors.conf << 'EOF'
    $primary = rgb(5ed4fd)
    $surface = rgb(111415)
    $secondary = rgb(b3cad5)
    $error = rgb(ffb4ab)
    $tertiary = rgb(c4c3eb)
    $surface_lowest = rgb(0a0d0f)

    general {
        col.active_border = $primary
        col.inactive_border = $surface
    }

    group {
        col.border_active = $secondary
        col.border_inactive = $surface
        col.border_locked_active = $error
        col.border_locked_inactive = $surface

        groupbar {
            col.active = $secondary
            col.inactive = $surface
            col.locked_active = $error
            col.locked_inactive = $surface
        }
    }
    EOF
  '';
in
{
  # ===========================================================================
  # 安装 Fcitx5 Dracula 自定义主题
  # ===========================================================================
  home.packages = [ fcitx5-dracula-theme ];

  # ===========================================================================
  # Fuzzel 应用启动器配置
  # ===========================================================================
  xdg.configFile = {
    # --- Fuzzel 主配置（引用 Noctalia 主题） ---
    "fuzzel/fuzzel.ini" = {
      force = true;
      text = ''
        include=~/.config/fuzzel/themes/noctalia
      '';
    };

    # --- Fuzzel Noctalia 主题（Niri Mod+D 快捷键依赖） ---
    "fuzzel/themes/noctalia" = {
      force = true;
      text = ''
        # Fuzzel Colors
        # Generated by Noctalia's Template Processor

        [colors]
        background=111415CC
        text=e1e3e4ff
        prompt=b3cad5ff
        placeholder=c4c3ebff
        input=5ed4fdff
        match=c4c3ebff
        selection=5ed4fd80
        selection-text=e1e3e4ff
        selection-match=003544ff
        counter=b3cad5ff
        border=5ed4fdff
      '';
    };

    # =========================================================================
    # Noctalia Shell 配置 — 由 home.activation 管理（见文件末尾）
    # 使用可写真实文件替代 xdg.configFile 的只读符号链接，
    # 确保 Noctalia UI 的修改能真正写入磁盘
    # =========================================================================

    # =========================================================================
    # Alacritty Noctalia 主题（未启用，仅备份保留）
    # 当前 Alacritty 使用系统 Dracula 主题（见 home/alacritty.nix）
    # =========================================================================
    "alacritty/themes/noctalia.toml" = {
      force = true;
      text = ''
        [colors.primary]
        background = '#111415'
        foreground = '#e1e3e4'

        [colors.cursor]
        text = '#e1e3e4'
        cursor = '#c0c8cc'

        [colors.vi_mode_cursor]
        text = '#111415'
        cursor = '#5ed4fd'

        [colors.search.matches]
        foreground = '#40484c'
        background = '#c4c3eb'

        [colors.search.focused_match]
        foreground = '#40484c'
        background = '#5ed4fd'

        [colors.footer_bar]
        foreground = '#40484c'
        background = '#e1e3e4'

        [colors.hints.start]
        foreground = '#40484c'
        background = '#b3cad5'

        [colors.hints.end]
        foreground = '#40484c'
        background = '#b3cad5'

        [colors.selection]
        text = '#111415'
        background = '#5ed4fd'

        [colors.normal]
        black = '#181818'
        red = '#ffb4ab'
        green = '#5ed4fd'
        yellow = '#006781'
        blue = '#5ed4fd'
        magenta = '#c4c3eb'
        cyan = '#b3cad5'
        white = '#BAC2DE'

        [colors.bright]
        black = '#585B70'
        red = '#F38BA8'
        green = '#A6E3A1'
        yellow = '#F9E2AF'
        blue = '#89B4FA'
        magenta = '#F5C2E7'
        cyan = '#94E2D5'
        white = '#A6ADC8'

        [colors.dim]
        black = '#45475A'
        red = '#F38BA8'
        green = '#A6E3A1'
        yellow = '#F9E2AF'
        blue = '#89B4FA'
        magenta = '#F5C2E7'
        cyan = '#94E2D5'
        white = '#BAC2DE'
      '';
    };

    # =========================================================================
    # Qt 主题 Noctalia 配色
    # =========================================================================

    "qt5ct/colors/noctalia.conf" = {
      force = true;
      text = ''
        [ColorScheme]
        active_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
        disabled_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
        inactive_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
      '';
    };

    "qt6ct/colors/noctalia.conf" = {
      force = true;
      text = ''
        [ColorScheme]
        active_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
        disabled_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
        inactive_colors=#e1e3e4, #111415, #40484c, #cacaca, #9f9f9f, #1d2022, #e1e3e4, #ffffff, #e1e3e4, #111415, #111415, #000000, #004d62, #b9eaff, #b3cad5, #5ed4fd, #40484c, #111415, #40484c, #e1e3e4, #e1e3e4, #5ed4fd
      '';
    };

    # =========================================================================
    # Fcitx5 主题 — Dracula 风格暗色（Nord-Dark）
    # =========================================================================
    "fcitx5/conf/classicui.conf" = {
      force = true;
      text = ''
        # 垂直候选列表
        Vertical Candidate List=False
        # 使用鼠标滚轮翻页
        WheelForPaging=True
        # 字体
        Font="Sans 10"
        # 菜单字体
        MenuFont="Sans 10"
        # 托盘字体
        TrayFont="Sans Bold 10"
        # 托盘标签轮廓颜色
        TrayOutlineColor=#000000
        # 托盘标签文本颜色
        TrayTextColor=#ffffff
        # 优先使用文字图标
        PreferTextIcon=False
        # 在图标中显示布局名称
        ShowLayoutNameInIcon=True
        # 使用输入法的语言来显示文字
        UseInputMethodLanguageToDisplayText=True
        # 主题 — Dracula 暗色
        Theme=Dracula
        # 深色主题
        DarkTheme=Dracula
        # 跟随系统浅色/深色设置
        UseDarkTheme=False
        # 禁用系统重点色（避免不同 app 主题不一致）
        UseAccentColor=False
        # 在 X11 上针对不同屏幕使用单独的 DPI
        PerScreenDPI=False
        # 固定 Wayland 的字体 DPI
        ForceWaylandDPI=0
        # 在 Wayland 下启用分数缩放
        EnableFractionalScale=True
      '';
    };

    # 禁用 Kimpanel（避免 DBus 前端应用使用不同的 UI 主题）
    "fcitx5/conf/kimpanel.conf" = {
      force = true;
      text = ''
        # 禁用 Kimpanel 面板集成，统一使用 Classic UI (Nord-Dark)
        Enabled=False
      '';
    };

    # =========================================================================
    # Niri 辅助脚本目录（已管理 edit-screenshot.sh，此处为占位）
    # =========================================================================

    # =========================================================================
    # Remmina 自启动
    # =========================================================================
    "autostart/remmina-applet.desktop" = {
      force = true;
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Remmina Applet
        Comment=Remmina system tray applet
        Exec=remmina -i
        Icon=remmina
        StartupNotify=false
        X-GNOME-Autostart-enabled=true
        NoDisplay=false
        Hidden=false
      '';
    };

    # =========================================================================
    # XSettings 守护进程配置（XWayland 应用主题）
    # =========================================================================
    "xsettingsd/xsettingsd.conf" = {
      force = true;
      text = ''
        Net/ThemeName "Dracula"
        Net/IconThemeName "Dracula"
        Gtk/CursorThemeName "Dracula-cursors"
        Gtk/FontName "Adwaita Sans 11"
        Net/EnableEventSounds 1
        EnableInputFeedbackSounds 0
        Xft/Antialias 1
        Xft/Hinting 1
        Xft/HintStyle "hintslight"
        Xft/RGBA "rgb"
      '';
    };
  };

  # ===========================================================================
  # Noctalia 可写配置激活脚本
  # 将默认配置文件从 nix store 复制到 ~/.config/noctalia/ 作为真实文件
  # （而非只读符号链接），确保 Noctalia UI 的修改能真正写入磁盘并持久化。
  # 仅在文件不存在或为符号链接时复制；用户已有的真实文件不受影响。
  # ===========================================================================
  home.activation.copyNoctaliaDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    NOCTALIA_DIR="$HOME/.config/noctalia"
    mkdir -p "$NOCTALIA_DIR"

    for f in colors.json settings.json plugins.json; do
      target="$NOCTALIA_DIR/$f"
      # 删除旧的只读符号链接（指向 nix store，cp 无法覆写）
      if [ -L "$target" ]; then
        rm -f "$target"
      fi
      # 如果目标不存在 → 复制默认值
      if [ ! -f "$target" ]; then
        cp ${noctaliaDefaults}/noctalia/$f "$target"
        chmod 644 "$target"
      fi
    done
  '';

  # ===========================================================================
  # Hyprland Noctalia 颜色配置激活脚本
  # 将默认的 noctalia-colors.conf 从 nix store 复制到
  # ~/.config/hypr/noctalia/ 作为真实文件（遵循与 copyNoctaliaDefaults
  # 相同的模式：仅在目标不存在时复制，允许 noctalia-shell 后续修改）
  # ===========================================================================
  home.activation.copyNoctaliaHyprColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    HYPR_NOCTALIA_DIR="$HOME/.config/hypr/noctalia"
    mkdir -p "$HYPR_NOCTALIA_DIR"

    target="$HYPR_NOCTALIA_DIR/noctalia-colors.conf"
    # 删除旧的只读符号链接（指向 nix store，cp 无法覆写）
    if [ -L "$target" ]; then
      rm -f "$target"
    fi
    # 如果目标不存在 → 复制默认值（noctalia-shell 之后可以覆写）
    if [ ! -f "$target" ]; then
      cp ${noctaliaHyprColorsDefaults}/noctalia-colors.conf "$target"
      chmod 644 "$target"
    fi
  '';

  # ===========================================================================
  # 清理：移除 ~/.config/nix/nix.conf（GitHub Token 已移至 /etc/nix/）
  # 使用 home.activation 删除残留的 nix.conf 文件
  # ===========================================================================
  home.activation.cleanupOldNixConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    OLD_NIX_CONF="$HOME/.config/nix/nix.conf"
    if [ -f "$OLD_NIX_CONF" ] && [ ! -L "$OLD_NIX_CONF" ]; then
      rm -f "$OLD_NIX_CONF"
      echo "[cleanup] 已移除旧版 $OLD_NIX_CONF"
    fi
  '';
}
