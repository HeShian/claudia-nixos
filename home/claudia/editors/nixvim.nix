# =============================================================================
# 文件名:   home/nixvim.nix
# 功能描述: Neovim 编辑器配置（通过 NixVim + home-manager 管理）
# 说明:     完整的编辑器功能：文件树、语法高亮、自动补全、LSP、格式化
#
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                      Neovim 操作指南                                    ║
# ║                                                                          ║
# ║  打开/关闭文件树:  ,e      保存文件:  ,w                                ║
# ║  查找文件:          ,ff     关闭窗口:  ,q                                ║
# ║  文本搜索:          ,fg                                                    ║
# ║                                                                          ║
# ║  【复制粘贴（系统剪贴板）】                                               ║
# ║  选中文本后按 ,y  复制到系统剪贴板                                        ║
# ║  按 ,p            从系统剪贴板粘贴                                        ║
# ║  如果终端支持（如 Kitty），也可用:                                        ║
# ║  Ctrl+Shift+C     复制选中文本到系统剪贴板（需 Kitty 透传）               ║
# ║  Ctrl+Shift+V     从系统剪贴板粘贴（需 Kitty 透传）                       ║
# ║                                                                          ║
# ║  【代码操作】                                                             ║
# ║  格式化代码:       ,f      保存时自动格式化（已配置）                      ║
# ║  查看文档:         K（光标放在函数/变量上按 shift+k）                     ║
# ║  跳转到定义:       gd      跳转到实现:  gi                                ║
# ║  查看引用:         gr      重命名符号:  ,rn                               ║
# ║  代码操作:         ,ca     查看错误:  ,e                                  ║
# ║  上一个/下一个诊断:  [d  /  ]d                                            ║
# ║                                                                          ║
# ║  【其他常用】                                                             ║
# ║  取消搜索高亮:     空格键  切换行号:  F2                                 ║
# ║  快速注释:         gcc（选中后 gc 注释/取消注释）                         ║
# ╚══════════════════════════════════════════════════════════════════════════╝
# =============================================================================
{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # 逗号是 Leader 键。所有以 , 开头的快捷键（如 ,e ,ff ,y）都依赖此设置
    globals.mapleader = ",";

    # --- 系统剪贴板集成 ---
    # 让 neovim 的 y/d/p 默认操作系统剪贴板
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # --- 基础编辑器设置 ---
    opts = {
      # Tab = 2 空格，用空格代替 Tab 字符
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;

      # 显示行号（相对行号方便跳转）
      number = true;
      relativenumber = true;
      cursorline = true;

      # 搜索
      hlsearch = true;     # 高亮搜索结果
      incsearch = true;    # 实时搜索
      ignorecase = true;   # 搜索忽略大小写
      smartcase = true;    # 但如果有大写字母则区分大小写

      # 编码与文件
      encoding = "utf-8";
      fileencoding = "utf-8";
      hidden = true;       # 未保存也可切换 buffer
      swapfile = false;    # 不创建 .swp 交换文件
      updatetime = 300;

      # 真彩色支持
      termguicolors = true;
      background = "dark";
    };

    # ===================================================================
    # 主题：Dracula（暗色）
    # ===================================================================
    colorschemes.dracula-nvim = {
      enable = true;
      settings = {
        italic_comment = true;
        transparent_bg = true;
      };
    };

    # ===================================================================
    # 语法高亮（Treesitter）：自动识别代码结构，做精确高亮
    # ===================================================================
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      # 安装以下编程语言的语法解析器
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix lua python rust bash c json yaml toml markdown
        html css javascript typescript tsx regex diff sql
      ];
    };

    # ===================================================================
    # 文件树（NvimTree）：浏览项目文件
    # 快捷键: ,e 打开/关闭
    # 在文件树中按 ? 查看所有操作说明
    # ===================================================================
    plugins.web-devicons.enable = true;
    plugins.nvim-tree = {
      enable = true;
      openOnSetup = false;      # 不自动打开
      autoClose = true;         # 退出 neovim 时自动关闭
      settings = {
        sort_by = "name";
        view.width = 30;
        update_focused_file.enable = true;
        actions.open_file.quit_on_open = false;
      };
    };

    # ===================================================================
    # 模糊搜索（Telescope）：快速找文件、搜文本
    # ,ff = 找文件   ,fg = 搜索文本   ,fb = 已打开的文件   ,fh = 搜索帮助
    # ===================================================================
    plugins.telescope = {
      enable = true;
      extensions.file-browser.enable = true;
      settings.defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^node_modules/"
          "^.direnv/"
          "^result"
        ];
      };
    };

    # ===================================================================
    # 代码补全（nvim-cmp）：写代码时自动弹出候选列表
    # Tab = 选择下一项   Shift+Tab = 选择上一项
    # Enter = 确认选择   Ctrl+Space = 手动触发补全
    # ===================================================================
    plugins.cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
      __raw = ''
        cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        })
      '';
        };
        sources = [
          { name = "nvim_lsp"; }  # LSP 提供的补全（类型感知）
          { name = "luasnip"; }   # 代码片段补全
          { name = "path"; }      # 文件路径补全
          { name = "buffer"; }    # 当前 buffer 文本补全
        ];
      };
    };
    plugins.luasnip.enable = true;

    # ===================================================================
    # LSP（语言服务器）：提供代码分析、补全、跳转、错误提示
    # 已配置的语言：
    #   Nix、Lua、Python、Rust、Bash
    #   JSON、YAML、Markdown、HTML、CSS、TypeScript/JavaScript
    # ===================================================================
    plugins.lsp = {
      enable = true;
      servers = {
        # Nix
        nil_ls.enable = true;
        nixd.enable = true;

        # Lua
        lua_ls = {
          enable = true;
          settings.Lua.telemetry.enable = false;
        };

        # Python
        pyright.enable = true;

        # JSON / YAML
        jsonls.enable = true;
        yamlls = {
          enable = true;
          settings.yaml.schemaStore.enable = true;
        };

        # Markdown
        marksman.enable = true;

        # Rust（只连接已安装的 rust-analyzer，不自带安装）
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };

        # Bash
        bashls.enable = true;

        # 前端
        html.enable = true;
        cssls.enable = true;
        ts_ls.enable = true;
      };
    };

    # ===================================================================
    # 自动格式化（conform-nvim）：保存文件时自动修正格式
    # 也可手动按 ,f 触发格式化
    # 不同语言使用不同的格式化工具
    # ===================================================================
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          lua = [ "stylua" ];
          python = [ "black" ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          html = [ "prettier" ];
          css = [ "prettier" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          "*" = [ "trim_whitespace" ];
          "_" = [ "trim_whitespace" ];
        };
        # 保存文件时自动格式化（1 秒超时）
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 1000;
        };
      };
    };

    # ===================================================================
    # 状态栏（Airline）：显示当前模式、文件名、行号、Git 分支等
    # ===================================================================
    plugins.airline = {
      enable = true;
      settings = {
        powerline_fonts = 1;
      };
    };

    # ===================================================================
    # 快速注释（Comment）：选中文本后按 gc 注释/取消注释
    # gcc = 注释当前行
    # gc + 方向键 = 注释选中区域
    # ===================================================================
    plugins.comment.enable = true;

    # ===================================================================
    # 按键映射
    # ===================================================================
    keymaps = [
      # ---------- 系统剪贴板 ----------
      # 用法：在 Visual 模式下选中文本，按 ,y 复制到系统剪贴板
      # 按 ,p 从系统剪贴板粘贴（Normal 和 Visual 模式均可）
      {
        mode = [ "n" "v" ];
        key = "<Leader>y";
        action = "\"+y";
        options = { desc = "复制到系统剪贴板"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<Leader>p";
        action = "\"+p";
        options = { desc = "从系统剪贴板粘贴"; };
      }

      # Ctrl+Shift+C/V（仅 Kitty 终端有效）
      # Kitty 需要配置 ctrl+shift+c → no_op 才能透传给 neovim
      # 详见 home/claudia/terminal/kitty.nix
      {
        mode = "v";
        key = "<C-S-c>";
        action = "\"+y";
        options = { desc = "复制到系统剪贴板（Ctrl+Shift+C）"; };
      }
      {
        mode = "i";
        key = "<C-S-v>";
        action = "<C-r>+";
        options = { desc = "从系统剪贴板粘贴（Ctrl+Shift+V）"; };
      }

      # ---------- 文件树 ----------
      {
        mode = "n";
        key = "<Leader>e";
        action = ":NvimTreeToggle<CR>";
        options = { desc = "打开/关闭文件树"; };
      }

      # ---------- 格式化 ----------
      {
        mode = [ "n" "v" ];
        key = "<Leader>f";
        action = ":lua vim.lsp.buf.format()<CR>";
        options = { desc = "格式化代码"; };
      }

      # ---------- LSP 操作 ----------
      {
        mode = "n";
        key = "K";
        action = ":lua vim.lsp.buf.hover()<CR>";
        options = { desc = "查看文档（光标放函数名上按大 K）"; };
      }
      {
        mode = "n";
        key = "gd";
        action = ":lua vim.lsp.buf.definition()<CR>";
        options = { desc = "跳转到定义"; };
      }
      {
        mode = "n";
        key = "gi";
        action = ":lua vim.lsp.buf.implementation()<CR>";
        options = { desc = "跳转到实现"; };
      }
      {
        mode = "n";
        key = "gr";
        action = ":lua vim.lsp.buf.references()<CR>";
        options = { desc = "查看引用"; };
      }
      {
        mode = "n";
        key = "<Leader>rn";
        action = ":lua vim.lsp.buf.rename()<CR>";
        options = { desc = "重命名符号（变量/函数改名）"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<Leader>ca";
        action = ":lua vim.lsp.buf.code_action()<CR>";
        options = { desc = "代码操作（快速修复等）"; };
      }
      {
        mode = "n";
        key = "[d";
        action = ":lua vim.diagnostic.goto_prev()<CR>";
        options = { desc = "上一个错误"; };
      }
      {
        mode = "n";
        key = "]d";
        action = ":lua vim.diagnostic.goto_next()<CR>";
        options = { desc = "下一个错误"; };
      }
      {
        mode = "n";
        key = "<Leader>vd";
        action = ":lua vim.diagnostic.open_float()<CR>";
        options = { desc = "查看错误详情"; };
      }

      # ---------- Telescope 搜索 ----------
      {
        mode = "n";
        key = "<Leader>ff";
        action = ":Telescope find_files<CR>";
        options = { desc = "查找项目中的文件"; };
      }
      {
        mode = "n";
        key = "<Leader>fg";
        action = ":Telescope live_grep<CR>";
        options = { desc = "在项目文本中搜索"; };
      }
      {
        mode = "n";
        key = "<Leader>fb";
        action = ":Telescope buffers<CR>";
        options = { desc = "已打开的文件列表"; };
      }
      {
        mode = "n";
        key = "<Leader>fh";
        action = ":Telescope help_tags<CR>";
        options = { desc = "搜索帮助文档"; };
      }

      # ---------- 常用快捷操作 ----------
      {
        mode = "n";
        key = "<Space>";
        action = ":nohlsearch<CR>";
        options = { desc = "取消搜索结果高亮"; };
      }
      {
        mode = "n";
        key = "<F2>";
        action = ":set number! relativenumber!<CR>";
        options = { desc = "切换行号显示"; };
      }
      {
        mode = "n";
        key = "<Leader>w";
        action = ":w<CR>";
        options = { desc = "保存文件"; };
      }
      {
        mode = "n";
        key = "<Leader>q";
        action = ":q<CR>";
        options = { desc = "关闭当前窗口"; };
      }
    ];

    # ===================================================================
    # Lua 额外配置：透明背景
    # ===================================================================
    extraConfigLuaPre = ''
      -- 透明背景（与终端背景融合）
      local function set_transparent()
        local hl_groups = {
          "Normal", "NonText", "LineNr", "Folded", "EndOfBuffer",
          "SignColumn", "CursorLineNr", "VertSplit", "TabLineFill",
        }
        for _, group in ipairs(hl_groups) do
          vim.api.nvim_set_hl(0, group, { bg = nil })
        end
      end
      set_transparent()
      vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_transparent })
    '';
  };
}
