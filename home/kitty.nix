# =============================================================================
# 文件名:   home/kitty.nix
# 功能描述: Kitty 终端模拟器配置
# 说明:     从 ~/dotfiles/.config/kitty/ 迁移至 Home Manager 管理。
#           配置字体、光标、快捷键、透明度和搜索功能。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Kitty 终端配置
  # ===========================================================================
  programs.kitty = {
    # --- 启用 Kitty ---
    enable = true;

    # --- Kitty 配置 ---
    settings = {
      # ================================================================
      # 字体设置
      # ================================================================
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # ================================================================
      # 光标设置
      # ================================================================
      cursor_shape = "beam";       # 竖线光标（类似 GUI 编辑器）
      cursor_trail = 1;            # 光标拖尾效果

      # ================================================================
      # 窗口内边距
      # ================================================================
      window_margin_width = "20";

      # ================================================================
      # 退出时不确认
      # ================================================================
      confirm_os_window_close = "0";

      # ================================================================
      # 透明度设置
      # ================================================================
      background_opacity = "0.8";
      dynamic_background_opacity = "yes";

      # ================================================================
      # 快捷键映射
      # ================================================================
      # 复制
      "map ctrl+c" = "copy_or_interrupt";

      # 搜索（水平分屏打开搜索）
      "map ctrl+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";

      # 滚动
      "map page_up" = "scroll_page_up";
      "map page_down" = "scroll_page_down";

      # 字体缩放
      "map ctrl+plus" = "change_font_size all +1";
      "map ctrl+equal" = "change_font_size all +1";
      "map ctrl+kp_add" = "change_font_size all +1";
      "map ctrl+minus" = "change_font_size all -1";
      "map ctrl+underscore" = "change_font_size all -1";
      "map ctrl+kp_subtract" = "change_font_size all -1";
      "map ctrl+0" = "change_font_size all 0";
      "map ctrl+kp_0" = "change_font_size all 0";
    };

    # --- 主题文件 ---
    # Kitty 主题通过 include 指令加载
    # 主题文件路径：~/.config/kitty/current-theme.conf
    # 当前主题：Gruvbox Dark Hard
    # 注意：不使用 themeFile 选项，因为 kitty-themes 包中可能不包含所需主题文件
    # 改为通过 extraConfig 的 include 指令加载
    # themeFile = "gruvbox_dark_hard";
  };
}
