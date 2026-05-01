# =============================================================================
# 文件名:   modules/desktop/niri.nix
# 功能描述: Niri 滚动式平铺窗口管理器配置
# 说明:     Niri 是一款基于 Wayland 的滚动式平铺窗口管理器，
#           窗口在水平方向上无限滚动排列，操作方式独特
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 启用 Niri ---
  programs.niri.enable = true;

  # --- 2. 配套软件包 ---
  environment.systemPackages = with pkgs; [
    fuzzel          # 应用程序启动器（类似 rofi/dmenu）
    alacritty       # GPU 加速的终端模拟器
    bibata-cursors  # Bibata 现代光标主题
  ];

  # --- 3. 光标主题设置 ---
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";  # 光标主题
    XCURSOR_SIZE = "24";                   # 光标大小
  };
}
