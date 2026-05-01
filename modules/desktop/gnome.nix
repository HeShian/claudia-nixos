# =============================================================================
# 文件名:   modules/desktop/gnome.nix
# 功能描述: GNOME 桌面环境配置
# 说明:     配置 GNOME 桌面、X11/Wayland 显示服务器支持
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. X11 显示服务器 ---
  services.xserver.enable = true;

  # --- 2. GNOME 桌面环境 ---
  services.displayManager.gdm.enable = true;      # GDM 登录管理器
  services.desktopManager.gnome.enable = true;     # GNOME 桌面

  # --- 3. XWayland 支持 ---
  # 允许在 Wayland 下运行 X11 应用程序
  programs.xwayland.enable = true;

  # --- 4. GNOME 视频软件 OpenGL 兼容 ---
  # 使用 OpenGL ES 而非完整 OpenGL，提高兼容性
  environment.sessionVariables.GDK_GL = "gles";

  # --- 5. Nautilus 右键终端 ---
  # 替换默认的 GNOME Terminal 为 Kitty
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };
}
