# =============================================================================
# 文件名:   home/alacritty.nix
# 功能描述: Alacritty 终端模拟器配置
# 说明:     从 ~/dotfiles/.config/alacritty/ 迁移至 Home Manager 管理。
#           配置字体、主题、窗口外观等。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Alacritty 终端配置
  # ===========================================================================
  programs.alacritty = {
    # --- 启用 Alacritty ---
    enable = true;

    # --- Alacritty 配置（TOML 格式） ---
    settings = {
      # ================================================================
      # 字体配置
      # ================================================================
      font = {
        size = 11.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Heavy";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Heavy Italic";
        };
      };

      # ================================================================
      # 窗口外观
      # ================================================================
      window = {
        decorations = "Full";
        dynamic_padding = false;
        opacity = 0.9;
        padding = {
          x = 20;
          y = 12;
        };
      };

      # ================================================================
      # 主题（使用系统全局 Dracula 主题，不再单独导入 noctalia.toml）
      # 如需自定义 Alacritty 主题，取消注释并替换为实际文件路径：
      # import = [ "~/.config/alacritty/themes/your-theme.toml" ];
      # ================================================================
    };
  };
}
