# =============================================================================
# 文件名:   modules/desktop/default.nix
# 功能描述: 桌面环境模块聚合入口
# 说明:     导入所有桌面环境相关子模块
#           系统同时启用了 GNOME、Hyprland、Niri 三种桌面/窗口管理器，
#           可在登录管理器（GDM）中选择启动
# =============================================================================
{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix              # GNOME 桌面环境
    ./hyprland.nix           # Hyprland 窗口管理器
    ./niri.nix               # Niri 滚动式窗口管理器
    ./display-manager.nix    # 登录管理器（GDM 自动登录）
    ./theming.nix            # 系统主题（Dracula 暗色）
    ./shells/dms.nix         # DankMaterialShell
    ./shells/noctalia.nix    # Noctalia Shell
  ];
}
