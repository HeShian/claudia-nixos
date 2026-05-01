# =============================================================================
# 文件名:   modules/develop/editors/vscode.nix
# 功能描述: VS Code 编辑器配置
# 说明:     安装微软 VS Code 编辑器和 OpenCode AI 编码助手
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 安装 VS Code ---
  environment.systemPackages = with pkgs; [
    vscode  # 微软 Visual Studio Code
  ];
}
