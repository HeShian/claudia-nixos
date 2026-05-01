# =============================================================================
# 文件名:   home/default.nix
# 功能描述: Home Manager 用户级配置入口
# 说明:     管理用户 claudia 的个人软件包、Shell 配置和桌面应用配置。
#           所有配置均从 stow 管理的 dotfiles 迁移至 Home Manager 统一管理。
#           注意：系统级软件包在 modules/ 各子模块中管理，
#           此处仅管理用户级独有配置。
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 状态版本 ---
  home.stateVersion = "26.05";

  # --- 导入子模块 ---
  imports = [
    ./zsh.nix           # ZSH Shell 配置
    ./bash.nix          # Bash Shell 配置
    ./vim.nix           # Vim/Neovim 配置
    ./git.nix           # Git 配置
    ./readline.nix      # Readline（命令行输入）配置
    ./alacritty.nix     # Alacritty 终端配置
    ./kitty.nix         # Kitty 终端配置
    ./btop.nix          # btop 系统监控配置
    ./fastfetch.nix     # fastfetch 系统信息配置
    ./hyprland.nix      # Hyprland 窗口管理器配置
    ./niri.nix          # Niri 窗口管理器配置
    ./opencode.nix      # OpenCode AI 编码助手配置
    ./theming.nix       # GTK / Kvantum 主题配置（Dracula）
    ./fish.nix          # Fish Shell 配置（Starship 提示符）
    ./migration.nix     # 从 ~/.config/ 迁移的遗留配置（fuzzel/noctalia/qt/remmina）
  ];

  # --- 用户级软件包 ---
  # 仅放置用户个人工具，系统级工具（如 git）在 modules/develop 中管理
  home.packages = with pkgs; [
    # 以下工具仅在用户级安装，系统级已在 modules/applications/productivity.nix 中统一管理：
    # starship, bat, lsd, btop, fastfetch 等均为系统级包（useGlobalPkgs=true 共享）
    # neovim 已由 modules/develop/editors/nixvim.nix 通过 NixVim 包装提供（含剪贴板集成）
    eza        # 现代 ls 替代（带图标和颜色）
    fzf        # 模糊搜索工具
    blesh      # Bash 语法高亮和自动建议（ble.sh）
  ];

  # --- 用户级全局环境变量 ---
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # ===========================================================================
  # Nautilus 文件管理器配置
  # ===========================================================================

  # 修正 XDG Templates 目录（原 user-dirs.dirs 错误地指向 $HOME/）
  # Nautilus 通过此目录提供右键"新建文档"菜单
  home.file.".config/user-dirs.dirs" = {
    force = true;  # 覆盖已有文件
    text = ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_TEMPLATES_DIR="$HOME/Templates"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_VIDEOS_DIR="$HOME/Videos"
    '';
  };

  # 右键"新建文档"模板（Nautilus 检测到 ~/Templates/ 目录后显示此菜单）
  home.file."Templates/新建文本文件.txt".text = "";
  home.file."Templates/新建 Markdown 文件.md".text = "";

  # 右键"在终端中打开"替换为 Kitty（XDG MIME 方式）
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/terminal" = "kitty.desktop";
  };

  # --- 启用 Home Manager ---
  programs.home-manager.enable = true;
}
