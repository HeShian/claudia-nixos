# =============================================================================
# 文件名:   home/claudia/wm/hyprland.nix
# 功能描述: Hyprland 用户级基础配置（bootstrapping 用）
# 说明:     此配置提供最基础的 hyprland.conf 和 monocrle 配置文件，
#           仅用于确保 Hyprland 能正常启动。
#           end-4 的 dotfiles 安装脚本会自动覆盖这些配置。
#
#           部署后请运行以下命令安装 end-4 配置：
#           git clone https://github.com/end-4/dots-hyprland.git ~/dots-hyprland
#           cd ~/dots-hyprland && ./setup install
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # 注意：end-4 的 setup install 管理 hyprland.conf 及其模块化配置，
  # 所以不在此处通过 xdg.configFile 部署 hyprland.conf。
  # end-4 已通过 source=custom/* 机制支持用户自定覆盖，
  # 无需 home-manager 参与，避免 symlink 覆盖 end-4 的动态配置。
  # ===========================================================================

  # ===========================================================================
  # Hyprland 环境变量
  # ===========================================================================
  home.sessionVariables = {
    # Wayland 基础
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland";

    # 输入法（与 Niri 配置一致）
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    XMODIFIERS = "@im=fcitx";
    DISPLAY = ":0";

    # 终端
    TERMINAL = "kitty";
  };
}
