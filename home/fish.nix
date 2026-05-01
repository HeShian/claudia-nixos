# =============================================================================
# 文件名:   home/fish.nix
# 功能描述: Fish Shell 用户级配置
# 说明:     配置 Fish Shell，使用与 bash/zsh 相同的 Starship 提示符
#           提供别名和环境变量
# =============================================================================
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # --- 交互式 Shell 初始化 ---
    interactiveShellInit = ''
      # ============================================================
      # 终端启动特效（fastfetch）
      # Kitty 使用 kitty-direct 显示图片 logo，Alacritty 使用纯文本
      # ============================================================
      if test "$TERM" = "xterm-kitty"
        fastfetch -c /run/current-system/sw/share/fastfetch/presets/examples/21.jsonc \
                  --logo ~/.config/fastfetch/openbit.png \
                  --logo-type kitty-direct \
                  --logo-width 12 \
                  --logo-height 0
      else if string match -q '*alacritty*' "$TERM"
        fastfetch
      end

      # 初始化 Starship 提示符（与 bash/zsh 共用同一配置）
      if command -sq starship
        starship init fish | source
      end
    '';

    # --- 别名 ---
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat";
      fm = "nvim .";       # 使用 Neovim 作为文件管理器
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    # --- 环境变量 ---
    shellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';
  };
}
