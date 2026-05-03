# 文件名:   home/claudia/programs/default.nix
# 功能描述: 用户程序配置聚合入口
{ ... }: {
  imports = [
    ./git.nix
    ./btop.nix
    ./fastfetch.nix
    ./cava.nix
    ./satty.nix
    ./opencode.nix
    ./clipse.nix
  ];
}
