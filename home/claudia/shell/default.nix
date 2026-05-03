# 文件名:   home/claudia/shell/default.nix
# 功能描述: Shell 配置聚合入口
{ ... }: {
  imports = [
    ./zsh.nix
    ./bash.nix
    ./readline.nix
  ];
}
