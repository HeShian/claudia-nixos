# =============================================================================
# 文件名:   modules/desktop/theming.nix
# 功能描述: 系统级暗色主题配置（Dracula）
# 说明:     安装 Dracula 主题包和 Kvantum 主题引擎，设置环境变量。
#           用户级 GTK/Kvantum 配置在 home/theming.nix 中管理。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # 安装主题和引擎
  # ===========================================================================
  environment.systemPackages = with pkgs; [
    # === Dracula 主题 ===
    dracula-theme                       # Dracula 暗色主题（GTK 2/3/4 + Kvantum + 光标）
    dracula-icon-theme                  # Dracula 图标主题

    # === Kvantum SVG 主题引擎 ===
    libsForQt5.qtstyleplugin-kvantum    # Qt5 Kvantum 引擎
    kdePackages.qtstyleplugin-kvantum   # Qt6 Kvantum 引擎

    # === Qt 配置工具 ===
    libsForQt5.qt5ct                    # Qt5 外观配置工具
    kdePackages.qt6ct                   # Qt6 外观配置工具
  ];

  # ===========================================================================
  # 环境变量
  # ===========================================================================
  environment.sessionVariables = {
    # Qt 应用使用 Kvantum 主题引擎（Dracula 暗色效果）
    QT_STYLE_OVERRIDE = "kvantum";
    # 使 Qt 应用在非 KDE 桌面下正确加载平台主题
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
