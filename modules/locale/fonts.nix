# =============================================================================
# 文件名:   modules/locale/fonts.nix
# 功能描述: 系统字体配置（所有字体统一在此管理）
# 说明:     配置中文字体、等宽字体、Emoji 字体及字体回退策略
#           所有模块的字体依赖均应添加到此文件，避免分散定义导致冲突
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 字体目录兼容 ---
  # 启用旧版字体路径兼容模式
  fonts.fontDir.enable = true;

  # --- 2. 安装字体包 ---
  fonts.packages = with pkgs; [
    # === 等宽字体（终端/代码） ===
    cascadia-code                    # Microsoft Cascadia Code
    nerd-fonts.jetbrains-mono        # JetBrains Mono Nerd Font（带图标，终端用）

    # === 图标字体 ===
    material-symbols                 # Material Symbols 图标字体

    # === Noto 字体系列 ===
    noto-fonts                       # Noto 基础字体
    noto-fonts-cjk-sans              # Noto 简体中文黑体（思源黑体）
    noto-fonts-cjk-serif             # Noto 简体中文宋体（思源宋体）
    noto-fonts-color-emoji           # Noto 彩色 Emoji 字体

    # === 思源字体 ===
    source-han-sans                  # 思源黑体（备选）
  ];

  # --- 3. 字体回退策略 ---
  fonts.fontconfig = {
    defaultFonts = {
      # 无衬线字体（界面字体）
      sansSerif = [ "Noto Sans CJK SC" "DejaVu Sans" ];
      # 衬线字体（文档字体）
      serif = [ "Noto Serif CJK SC" "DejaVu Serif" ];
      # 等宽字体（终端/代码字体）
      monospace = [ "Cascadia Code" "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
    };
  };
}
