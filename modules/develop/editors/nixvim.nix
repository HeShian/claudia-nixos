# =============================================================================
# 文件名:   modules/develop/editors/nixvim.nix
# 功能描述: Neovim 编辑器配置（通过 NixVim 管理）
# 说明:     NixVim 是 Neovim 的 Nix 配置框架，可用声明式方式管理
#           Neovim 的插件、主题和设置
# 依赖:     nixvim（nix-community/nixvim flake 输入）
# =============================================================================
{ config, inputs, ... }:

{
  # --- 导入 NixVim NixOS 模块 ---
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  # --- NixVim 配置 ---
  programs.nixvim = {
    enable = true;

    # 与 home/vim.nix 保持一致：使用逗号作为 Leader
    globals.mapleader = ",";

    # 系统剪贴板集成（y/d/p 操作与系统剪贴板同步）
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # =========================================================================
    # 剪贴板快捷键
    # =========================================================================
    # Ctrl+Shift+C: 在可视化模式下复制选中内容到系统剪贴板
    # 依赖 Kitty 键盘协议 (Neovim 默认启用)，非 Kitty 终端可能不生效
    # Leader+y / Leader+p (,y / ,p): 所有终端均可用的可靠替代方案
    keymaps = [
      {
        mode = "v";
        key = "<C-S-c>";
        action = "\"+y";
        options = { silent = true; desc = "Copy to system clipboard"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<Leader>y";
        action = "\"+y";
        options = { silent = true; desc = "Yank to system clipboard"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<Leader>p";
        action = "\"+p";
        options = { silent = true; desc = "Paste from system clipboard"; };
      }
      {
        mode = "i";
        key = "<C-S-v>";
        action = "<C-r>+";
        options = { silent = true; desc = "Paste from system clipboard"; };
      }
    ];
  };
}
