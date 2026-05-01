# =============================================================================
# 文件名:   modules/develop/ai-tools.nix
# 功能描述: AI 编程工具（Claude Code + CC-Switch）
# 说明:     claude-code 是 Anthropic 的终端 AI 编码助手
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 系统级软件包 ---
  environment.systemPackages = with pkgs; [
    # === Claude Code ===
    claude-code                        # Anthropic 终端 AI 编码助手
  ];
}
