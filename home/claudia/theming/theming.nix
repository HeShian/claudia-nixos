# =============================================================================
# 文件名:   home/theming.nix
# 功能描述: 用户级 GTK 和 Kvantum 主题配置
# 说明:     配置 GTK 应用使用 Dracula 暗色主题，
#           配置 Kvantum 使用 Dracula 主题（dracula-theme 包内置）
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # GTK 主题配置（GTK 2/3/4 统一使用 Dracula）
  # ===========================================================================
  gtk = {
    enable = true;

    # 主题名称（对应 /nix/store/.../share/themes/Dracula）
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    # 图标主题
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

    # 光标主题
    cursorTheme = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
    };
  };

  # ===========================================================================
  # Kvantum 主题配置（Qt 应用）
  # dracula-theme 包内置了 Kvantum 主题文件（share/Kvantum/Dracula/）
  # 通过符号链接将主题文件部署到 ~/.config/Kvantum/
  # ===========================================================================

  xdg.configFile = {
    # Kvantum 主配置文件：指定 Dracula 为当前主题
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Dracula
    '';

    # Dracula Kvantum 主题文件（从 Nix 商店链接到 ~/.config/Kvantum/Dracula/）
    "Kvantum/Dracula".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula";

    # =========================================================================
    # Qt5 外观配置（qt5ct）— 配合 QT_STYLE_OVERRIDE=kvantum 作为回退
    # =========================================================================
    "qt5ct/qt5ct.conf" = {
      force = true;
      text = ''
        [Appearance]
        custom_palette=false
        icon_theme=Dracula
        standard_dialogs=default
        style=kvantum
      '';
    };

    # =========================================================================
    # Qt6 外观配置（qt6ct）— 配合 QT_STYLE_OVERRIDE=kvantum 作为回退
    # =========================================================================
    "qt6ct/qt6ct.conf" = {
      force = true;
      text = ''
        [Appearance]
        custom_palette=false
        icon_theme=Dracula
        standard_dialogs=default
        style=kvantum
      '';
    };
  };
}
