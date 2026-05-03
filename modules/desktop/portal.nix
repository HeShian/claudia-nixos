{ config, pkgs, ... }:

{
  # ===========================================================================
  # XDG Desktop Portal — Wayland 屏幕共享/文件选择等跨桌面协议
  #
  # 说明：
  #   Niri 需要 xdg-desktop-portal-gnome 作为后端进行屏幕共享。
  #
  # 注意：即使没有安装完整的 GNOME 桌面，xdg-desktop-portal-gnome
  # 仍可作为独立的 portal 后端正常工作。
  # ===========================================================================
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome      # Niri 屏幕共享需要
      xdg-desktop-portal-gtk        # 通用后备
      xdg-desktop-portal-hyprland   # Hyprland 屏幕共享需要
    ];

    config = {
      common = {
        default = "gnome";
        "org.freedesktop.impl.portal.Secret" = "gtk";
      };
      hyprland = {
        default = "hyprland";
        "org.freedesktop.impl.portal.Secret" = "gtk";
      };
    };
  };
}
