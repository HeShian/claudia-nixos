# 文件名:   home/claudia/input/default.nix
# 功能描述: 输入法配置聚合入口
{ ... }: {
  imports = [
    ./rime.nix
    ./migration.nix
  ];
}
