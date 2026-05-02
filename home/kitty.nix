# =============================================================================
# 文件名:   home/kitty.nix
# 功能描述: Kitty 终端模拟器配置
# 说明:     从 ~/dotfiles/.config/kitty/ 迁移至 Home Manager 管理。
#           配置字体、光标、快捷键、透明度和 Gruvbox Dark Hard 主题
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
      cursor_shape = "beam";
      cursor_trail = 1;

      # ================================================================
      # 窗口设置
      # ================================================================
      window_margin_width = "20";
      confirm_os_window_close = "0";

      # ================================================================
      # 透明度
      # ================================================================
      background_opacity = "0.8";
      dynamic_background_opacity = "yes";

      # ================================================================
      # 主题颜色（Gruvbox Dark Hard）
      # ================================================================
      foreground = "#ebdbb2";
      background = "#1d2021";
      selection_foreground = "#1d2021";
      selection_background = "#ebdbb2";
      url_color = "#83a598";
      cursor = "#ebdbb2";
      cursor_text_color = "#1d2021";
      active_border_color = "#83a598";
      inactive_border_color = "#3c3836";

      # 16 色调色板
      color0 = "#282828";   color8  = "#928374";  # Black
      color1 = "#cc241d";   color9  = "#fb4934";  # Red
      color2 = "#98971a";   color10 = "#b8bb26";  # Green
      color3 = "#d79921";   color11 = "#fabd2f";  # Yellow
      color4 = "#458588";   color12 = "#83a598";  # Blue
      color5 = "#b16286";   color13 = "#d3869b";  # Magenta
      color6 = "#689d6a";   color14 = "#8ec07c";  # Cyan
      color7 = "#a89984";   color15 = "#ebdbb2";  # White

      # ================================================================
      # 快捷键
      # ================================================================
      "map ctrl+c" = "copy_or_interrupt";
      "map ctrl+shift+c" = "no_op";  # 透传 Ctrl+Shift+C 给 Neovim/Vim
      "map ctrl+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      "map page_up" = "scroll_page_up";
      "map page_down" = "scroll_page_down";
      "map ctrl+plus" = "change_font_size all +1";
      "map ctrl+equal" = "change_font_size all +1";
      "map ctrl+kp_add" = "change_font_size all +1";
      "map ctrl+minus" = "change_font_size all -1";
      "map ctrl+underscore" = "change_font_size all -1";
      "map ctrl+kp_subtract" = "change_font_size all -1";
      "map ctrl+0" = "change_font_size all 0";
      "map ctrl+kp_0" = "change_font_size all 0";
    };
  };
}
