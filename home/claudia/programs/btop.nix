# =============================================================================
# 文件名:   home/claudia/programs/btop.nix
# 功能描述: btop 系统监控工具配置
# 说明:     从 ~/dotfiles/.config/btop/ 迁移至 Home Manager 管理。
#           配置主题、布局、颜色方案等。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # btop 配置
  # ===========================================================================
  programs.btop = {
    # --- 启用 btop ---
    enable = true;

    # --- btop 配置 ---
    settings = {
      # ================================================================
      # 主题设置
      # ================================================================
      # 使用 btop 内置 Catppuccin Mocha 主题
      color_theme = "catppuccin_mocha";
      theme_background = false;          # 使用终端背景色（实现透明效果）
      truecolor = true;                  # 启用 24 位真彩色

      # ================================================================
      # 布局预设
      # ================================================================
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      shown_boxes = "cpu mem net proc";  # 显示的模块
      vim_keys = false;                  # 禁用 Vim 方向键

      # ================================================================
      # 图形设置
      # ================================================================
      rounded_corners = true;            # 圆角边框
      graph_symbol = "braille";          # 使用盲文符号（最高分辨率）
      graph_symbol_cpu = "default";
      graph_symbol_gpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";

      # ================================================================
      # 更新频率
      # ================================================================
      update_ms = 2000;                  # 每 2 秒更新一次

      # ================================================================
      # 进程列表设置
      # ================================================================
      proc_sorting = "cpu lazy";         # 按 CPU 使用率排序（平滑模式）
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_left = false;

      # ================================================================
      # CPU 设置
      # ================================================================
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_cpu_freq = true;
      show_uptime = true;
      check_temp = true;
      show_coretemp = true;
      temp_scale = "celsius";

      # ================================================================
      # 内存和磁盘设置
      # ================================================================
      mem_graphs = true;
      mem_below_net = false;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;

      # ================================================================
      # 网络设置
      # ================================================================
      net_auto = true;
      net_sync = true;

      # ================================================================
      # 其他设置
      # ================================================================
      show_battery = true;
      show_battery_watts = true;
      clock_format = "%X";
      background_update = true;
      base_10_sizes = false;
      log_level = "WARNING";
    };
  };
}
