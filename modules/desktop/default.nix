{ config, pkgs, ... }:

{
  imports = [
    ./display-manager.nix    # 登录管理器 + XWayland
    ./portal.nix             # XDG 桌面门户（屏幕共享等）
    ./niri.nix               # Niri 滚动式窗口管理器
    ./theming.nix            # 系统主题（Dracula 暗色）
    ./shells/noctalia.nix    # Noctalia Shell（Niri 用）
    ./hyprland.nix           # Hyprland + end-4 配置
  ];
}
