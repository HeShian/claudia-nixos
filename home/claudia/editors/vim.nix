# =============================================================================
# 文件名:   home/vim.nix
# 功能描述: Vim/Neovim 编辑器配置
# 说明:     从 ~/dotfiles/.vimrc 迁移至 Home Manager 管理。
#           配置插件管理、主题切换、Airline 状态栏等。
#           注意：所有设置均通过 extraConfig 设置，避免 Home Manager
#           programs.vim.settings 选项兼容性问题。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Vim 配置
  # ===========================================================================
  programs.vim = {
    # --- 启用 Vim ---
    enable = true;

    # --- 插件管理（使用 vim-plug） ---
    plugins = with pkgs.vimPlugins; [
      vim-airline                  # 美观的状态栏
      vim-airline-themes           # Airline 主题
      gruvbox                      # Gruvbox 配色主题
      catppuccin-vim               # Catppuccin 配色主题
      vim-commentary               # 快速注释/取消注释
    ];

    # --- 额外配置（所有设置、主题、快捷键等） ---
    extraConfig = ''
      " ==================== 基础设置 ====================
      let mapleader = ","

      syntax on
      set number relativenumber
      set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
      set autoindent smartindent
      set cursorline
      set hlsearch incsearch
      set ignorecase smartcase
      set encoding=utf-8
      set fileencoding=utf-8
      set hidden
      set noswapfile
      set updatetime=300

      " 系统剪贴板集成（Ctrl+Shift+C/V 与系统共享剪贴板）
      set clipboard=unnamedplus

      " 启用真彩色支持
      if has("termguicolors")
          set termguicolors
      endif
      set background=dark

      " ==================== 透明背景函数 ====================
      function! s:apply_transparent_bg() abort
          highlight Normal guibg=NONE ctermbg=NONE
          highlight NonText guibg=NONE ctermbg=NONE
          highlight LineNr guibg=NONE ctermbg=NONE
          highlight Folded guibg=NONE ctermbg=NONE
          highlight EndOfBuffer guibg=NONE ctermbg=NONE
          highlight SignColumn guibg=NONE ctermbg=NONE
          highlight CursorLineNr guibg=NONE ctermbg=NONE
          highlight VertSplit guibg=NONE ctermbg=NONE
          highlight TabLineFill guibg=NONE ctermbg=NONE
      endfunction

      autocmd ColorScheme * call s:apply_transparent_bg()
      call s:apply_transparent_bg()

      " ==================== 主题切换功能 ====================
      " 默认启动主题，可改为 'gruvbox'
      let g:current_theme = 'catppuccin'

      function! ToggleTheme() abort
          if g:current_theme == 'catppuccin'
              " 切换到 Gruvbox（柔和暗色）
              let g:gruvbox_contrast_dark = 'soft'
              let g:gruvbox_italic = 1
              let g:gruvbox_transparent_bg = 1
              colorscheme gruvbox
              " 同时切换 Airline 状态栏主题以匹配
              let g:airline_theme = 'gruvbox'
              let g:current_theme = 'gruvbox'
              echo "Theme: Gruvbox (soft dark)"
          else
              " 切换到 Catppuccin Mocha
              colorscheme catppuccin_mocha
              " 同时切换 Airline 状态栏主题以匹配
              let g:airline_theme = 'catppuccin_mocha'
              let g:current_theme = 'catppuccin'
              echo "Theme: Catppuccin Mocha"
          endif
      endfunction

      " 快捷键：按 <Leader>t 切换主题（即 ,t）
      nnoremap <silent> <Leader>t :call ToggleTheme()<CR>

      " ==================== Airline 配置 ====================
      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#left_sep = ' '
      let g:airline#extensions#tabline#left_alt_sep = '|'
      let g:airline#extensions#tabline#formatter = 'unique_tail'

      " 初始主题（根据 g:current_theme 变量自动加载）
      if g:current_theme == 'gruvbox'
          let g:gruvbox_contrast_dark = 'soft'
          let g:gruvbox_italic = 1
          let g:gruvbox_transparent_bg = 1
          silent! colorscheme gruvbox
          let g:airline_theme = 'gruvbox'
      else
          silent! colorscheme catppuccin_mocha
      endif

      " ==================== 其他快捷键 ====================
      nnoremap <space> :nohlsearch<CR>
      nnoremap <F2> :set number! relativenumber!<CR>
      nnoremap <Leader>w :w<CR>
      nnoremap <Leader>q :q<CR>

      " ==================== 剪贴板（Wayland 兼容）====================
      " 注意：终端 Vim 无法区分 Ctrl+C 和 Ctrl+Shift+C
      "       （键盘协议限制），所以不设 Ctrl+Shift+C 映射。
      "       改用 Leader 快捷键（终端通用）
      " Ctrl+Shift+V: 插入模式从系统剪贴板粘贴
      inoremap <C-S-v> <C-r>=system('wl-paste')<CR>
      " Leader 快捷键：所有终端可用
      vnoremap <Leader>y :'<,'>w !wl-copy<CR>gv
      nnoremap <Leader>p :call setreg('"', system('wl-paste --no-newline'), 'c')<CR>"p
      vnoremap <Leader>p :<C-u>call setreg('"', system('wl-paste --no-newline'), 'c')<CR>""pgv

      if has("autocmd")
          autocmd BufWritePost $MYVIMRC source $MYVIMRC
      endif
    '';
  };
}
