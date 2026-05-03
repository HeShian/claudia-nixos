# 文件名:   home/claudia/terminal/default.nix
# 功能描述: 终端模拟器配置聚合入口
{ ... }: {
  imports = [
    ./alacritty.nix
    ./kitty.nix
  ];
}
