# =============================================================================
# 文件名:   home/zsh.nix
# 功能描述: ZSH Shell 用户级配置
# 说明:     配置 ZSH 的补全、语法高亮、历史记录、别名和环境变量
#           通过 Home Manager 管理，仅对当前用户生效
# =============================================================================
{ config, pkgs, ... }:

{
  programs.zsh = {
    # --- 1. 基础功能 ---
    enable = true;
    enableCompletion = true;          # 自动补全
    autosuggestion.enable = true;     # 自动建议（基于历史）
    syntaxHighlighting.enable = true; # 命令语法高亮

    # --- 2. 历史命令配置 ---
    history = {
      size = 100000;                  # 内存中保留条数
      save = 100000;                  # 保存到文件的条数
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;              # 忽略重复命令
      ignoreSpace = true;             # 忽略以空格开头的命令
      share = true;                   # 多终端共享历史
      extended = true;                # 保存时间戳
    };

    # --- 3. 插件 ---
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh/site-functions";
      }
    ];

    # --- 4. Oh-My-Zsh 框架（可选）---
    oh-my-zsh = {
      enable = false;  # 如需启用改为 true
    };

    # --- 5. 自定义初始化配置 ---
    # 注意：使用 initContent 替代已弃用的 initExtra
    initContent = ''
      # ============================================================
      # 终端启动特效（由共享脚本统一管理）
      # ============================================================
      source "$HOME/.config/shell/init-common.sh"

      # 命令高亮样式
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

      # Tab 补全行为优化
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # 大小写不敏感
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}     # 彩色补全列表

      # 模糊补全
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*:match:*' original only
      zstyle ':completion:*:approximate:*' max-errors 1 numeric

      # 缓存补全结果加速
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zsh/cache

      # 按键绑定
      bindkey '^[[Z' reverse-menu-complete  # Shift+Tab 反向选择

      # 初始化 Starship 提示符（与 bash/fish 使用相同配置）
      if command -v starship >/dev/null; then
        eval "$(starship init zsh)"
      fi

      # fzf 集成（如果安装了 fzf）
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
    '';

    # --- 6. 别名 ---
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

    # --- 7. 环境变量 ---
    # 注意：EDITOR/VISUAL 已提升至 home/default.nix 的 home.sessionVariables
    # 中统一管理，对所有 Shell（bash/zsh/fish）生效
  };
}
