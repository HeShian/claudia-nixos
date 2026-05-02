# =============================================================================
# 文件名:   modules/multimedia/clipman.nix
# 功能描述: 剪贴板管理工具配置
# 说明:     安装 Clipse 剪贴板管理器及相关依赖工具
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 剪贴板管理工具 ---
  environment.systemPackages = with pkgs; [
    # clipse 和 satty 已由 home-manager 的 services.clipse / programs.satty 管理
    wl-clipboard    # Wayland 剪贴板工具
    wtype           # Wayland 键盘输入模拟
    grim            # Wayland 截图工具
    slurp           # Wayland 区域选择工具
    jq              # JSON 处理（窗口截图坐标解析）
  ];
}
