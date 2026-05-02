# =============================================================================
# 文件名:   home/migration.nix
# 功能描述: 从 ~/.config/ 迁移至 Home Manager 管理的配置文件
# 说明:     所有之前未受 Nix 管理的配置文件统一在此管理，
#           确保系统配置的完整可复现性
# =============================================================================
{ config, pkgs, lib, ... }:

let
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
  # Fcitx5 Dracula 主题 — 作为真实文件部署到 ~/.local/share/fcitx5/themes/Dracula/
  # （xdg.dataFile 的符号链接在 fcitx5 搜索路径中可能不可见）
  # ===========================================================================
  home.activation.installFcitx5DraculaTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    THEME_DIR="$HOME/.local/share/fcitx5/themes/Dracula"

    # 删除旧的符号链接或文件
    rm -rf "$THEME_DIR"

    mkdir -p "$THEME_DIR"
    cat > "$THEME_DIR/theme.conf" << 'THEME_EOF'
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

    cp ${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/arrow.png "$THEME_DIR/arrow.png"
    cp ${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/radio.png "$THEME_DIR/radio.png"
    echo "[fcitx5] Dracula theme installed to $THEME_DIR"
  '';

  # ===========================================================================
  # 强制部署 fcitx5 配置文件（阻止 fcitx5 运行时覆写主题和快捷键）
  # ===========================================================================
  home.activation.forceFcitx5Config = lib.hm.dag.entryAfter ["writeBoundary"] ''
    FCITX5_CONF="$HOME/.config/fcitx5/conf"

    # classicui.conf — 强制 Dracula 主题
    rm -f "$FCITX5_CONF/classicui.conf"
    cat > "$FCITX5_CONF/classicui.conf" << 'CLASSICUI_EOF'
    Vertical Candidate List=False
    WheelForPaging=True
    Font="Sans 10"
    MenuFont="Sans 10"
    TrayFont="Sans Bold 10"
    TrayOutlineColor=#000000
    TrayTextColor=#ffffff
    PreferTextIcon=False
    ShowLayoutNameInIcon=True
    UseInputMethodLanguageToDisplayText=True
    Theme=Dracula
    DarkTheme=Dracula
    UseDarkTheme=False
    UseAccentColor=False
    PerScreenDPI=False
    ForceWaylandDPI=0
    EnableFractionalScale=True
    CLASSICUI_EOF

    # kimpanel.conf — 禁用 Kimpanel
    rm -f "$FCITX5_CONF/kimpanel.conf"
    cat > "$FCITX5_CONF/kimpanel.conf" << 'KIMPANEL_EOF'
    [Addon]
    Enabled=False
    KIMPANEL_EOF

    # 主配置 — 锁定快捷键 + 禁用 Kimpanel
    rm -f "$HOME/.config/fcitx5/config"
    cat > "$HOME/.config/fcitx5/config" << 'CONFIG_EOF'
    [Hotkey]
    EnumerateWithTriggerKeys=True
    ModifierOnlyKeyTimeout=250

    [Hotkey/TriggerKeys]
    0=Super+space
    1=Zenkaku_Hankaku
    2=Hangul

    [Hotkey/ActivateKeys]
    0=Hangul_Hanja

    [Hotkey/DeactivateKeys]
    0=Hangul_Romaja

    [Hotkey/AltTriggerKeys]
    0=Shift_L

    [Hotkey/EnumerateGroupForwardKeys]
    0=Super+space

    [Hotkey/EnumerateGroupBackwardKeys]
    0=Shift+Super+space

    [Hotkey/PrevPage]
    0=Up

    [Hotkey/NextPage]
    0=Down

    [Hotkey/PrevCandidate]
    0=Shift+Tab

    [Hotkey/NextCandidate]
    0=Tab

    [Hotkey/TogglePreedit]
    0=Control+Alt+P

    [Behavior]
    ActiveByDefault=False
    resetStateWhenFocusIn=No
    ShareInputState=No
    PreeditEnabledByDefault=True
    ShowInputMethodInformation=True
    showInputMethodInformationWhenFocusIn=False
    CompactInputMethodInformation=True
    ShowFirstInputMethodInformation=True
    DefaultPageSize=5
    OverrideXkbOption=False
    EnabledAddons=
    DisabledAddons=kimpanel
    PreloadInputMethod=True
    AllowInputMethodForPassword=False
    ShowPreeditForPassword=False
    AutoSavePeriod=30
    CONFIG_EOF

    echo "[fcitx5] Config forcefully deployed (Dracula theme locked)"
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
