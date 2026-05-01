# =============================================================================
# 文件名:   modules/multimedia/clipman.nix
# 功能描述: 剪贴板管理工具配置
# 说明:     安装 Clipse 剪贴板管理器及相关依赖工具
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 剪贴板管理工具 ---
  environment.systemPackages = with pkgs; [
    clipse          # 剪贴板管理器（支持历史记录）
    wl-clipboard    # Wayland 剪贴板工具
    wtype           # Wayland 键盘输入模拟
    xdotool         # X11 键盘/鼠标自动化工具
    satty           # 截图标注工具
  ];
}
