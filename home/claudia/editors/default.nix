# 文件名:   home/claudia/editors/default.nix
# 功能描述: 编辑器配置聚合入口
{ ... }: {
  imports = [
    ./vim.nix
    ./nixvim.nix
  ];
}
