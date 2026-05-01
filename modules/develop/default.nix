# =============================================================================
# 文件名:   modules/develop/default.nix
# 功能描述: 开发工具模块聚合入口
# 说明:     导入所有开发相关配置：编程语言、构建工具、编辑器
# =============================================================================
{ config, pkgs, ... }:

{
  imports = [
    ./languages.nix         # 编程语言运行时
    ./build-tools.nix       # 构建工具链
    ./version-control.nix   # 版本控制
    ./editors/vscode.nix    # VS Code 编辑器
    ./editors/nixvim.nix    # Neovim 编辑器（NixVim）
    ./ai-tools.nix          # AI 编程工具（Claude Code + CC-Switch）
  ];
}
