# =============================================================================
# 文件名:   modules/develop/ai-tools.nix
# 功能描述: AI 编程工具（Claude Code + CC-Switch）
# 说明:     claude-code 是 Anthropic 的终端 AI 编码助手
#           cc-switch 是多 AI CLI（Claude Code/Codex/Gemini CLI/OpenCode）的
#           可视化配置管理工具（AppImage 方式安装）
# =============================================================================
{ config, pkgs, ... }:

let
  # CC-Switch AppImage 下载
  cc-switch-appimage = pkgs.fetchurl {
    url = "https://github.com/farion1231/cc-switch/releases/download/v3.14.1/CC-Switch-v3.14.1-Linux-x86_64.AppImage";
    sha256 = "sha256-ouXEGDFWQ3yWof5y3yp7S4f/bIV83wkS5wV8NO/NUwk=";
  };
in
{
  # --- 系统级软件包 ---
  environment.systemPackages = with pkgs; [
    # === Claude Code ===
    claude-code                        # Anthropic 终端 AI 编码助手

    # === CC-Switch 依赖 ===
    appimage-run                       # AppImage 运行环境（NixOS FHS 兼容层）

    # === CC-Switch 启动脚本 ===
    (pkgs.writeScriptBin "cc-switch" ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.appimage-run}/bin/appimage-run ${cc-switch-appimage}
    '')
  ];
}
