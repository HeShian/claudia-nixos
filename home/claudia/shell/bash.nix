# =============================================================================
# 文件名:   home/bash.nix
# 功能描述: Bash Shell 用户级配置
# 说明:     从 ~/dotfiles/.bashrc 迁移至 Home Manager 管理。
#           配置别名、环境变量、提示符和终端特效。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Bash 配置
  # ===========================================================================
  programs.bash = {
    # --- 启用 Bash ---
    enable = true;

    # --- 启用补全 ---
    enableCompletion = true;

    # --- Bash 初始化配置（对应 ~/.bashrc 内容） ---
    initExtra = ''
      # ============================================================
      # 基础设置与别名
      # ============================================================
      alias ls='ls --color=auto'
      alias l='lsd -l'
      alias ll='lsd -lah'
      alias lt='lsd --tree'
      alias fm='nvim .'  # 使用 Neovim 作为文件管理器

      # 如果没有 starship 时，作为后备的提示符
      PS1='[\u@\h \W]\$ '

      # ============================================================
      # PATH 设置
      # ============================================================
      [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

      # ============================================================
      # 终端启动特效（由共享脚本统一管理）
      # ============================================================
      source "$HOME/.config/shell/init-common.sh"

      # ============================================================
      # 交互式 Shell 专属配置
      # ============================================================
      if [[ $- == *i* ]]; then
          # 初始化 Starship 提示符（与 zsh/fish 共用同一配置）
          eval "$(starship init bash)"

          # 加载 ble.sh（语法高亮 + 自动建议）
          [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh
      fi
    '';

    # --- 登录 Shell 配置（~/.bash_profile） ---
    # 确保 home-manager 的 PATH 在登录时被加载
    profileExtra = ''
      # 加载 home-manager 管理的用户级 PATH
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };
}
