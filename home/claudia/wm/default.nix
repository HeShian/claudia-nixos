# 文件名:   home/claudia/wm/default.nix
# 功能描述: 窗口管理器配置聚合入口
{ ... }: {
  imports = [
    ./niri.nix
    ./hyprland.nix
  ];
}
