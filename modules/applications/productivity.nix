# =============================================================================
# 文件名:   modules/applications/productivity.nix
# 功能描述: 生产力工具配置
# 说明:     安装常用生产力工具和系统工具（系统级，所有用户可用）。
#           注意：
#           - 字体统一在 modules/locale/fonts.nix 中管理
#           - 开发工具（git/vscode 等）在 modules/develop/ 中管理
#           - 终端模拟器在 terminals.nix 中管理
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 生产力工具 ---
  environment.systemPackages = with pkgs; [
    # === 编辑器 ===
    vim       # Vim 编辑器
    helix     # Helix 现代模态编辑器

    # === 系统工具 ===
    wget      # 网络下载工具
    fastfetch # 系统信息显示工具（home-manager 中亦有其配置）
    btop      # 系统资源监控（home-manager 中亦有其配置）
    pavucontrol  # PulseAudio/PipeWire 图形化音量控制
    tree      # 目录树显示工具

    # === Shell 增强 ===
    starship  # 跨 Shell 提示符美化
    bat       # 带语法高亮的 cat 替代
    lsd       # 带图标的 ls 替代

    # === 文件管理 ===
    yazi      # 终端文件管理器

    # === 笔记与知识管理 ===
    obsidian  # Obsidian 笔记应用

    # === AI 辅助编程 ===
    opencode  # OpenCode AI 代码助手（home-manager 中亦有其配置）
  ];
}
