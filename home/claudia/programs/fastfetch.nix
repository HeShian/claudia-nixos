# =============================================================================
# 文件名:   home/claudia/programs/fastfetch.nix
# 功能描述: fastfetch 系统信息工具配置
# 说明:     配置系统信息显示格式、颜色和布局。
#           - Logo 在 config.jsonc 中设为 "none"，实际 logo 由 bash.nix 启动时通过
#             --logo 参数传入 ~/.config/fastfetch/openbit.png（Kitty 终端专属）
#           - 非 Kitty 终端（如 Alacritty/GNOME Terminal）使用纯文本模式
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # fastfetch 配置
  # ===========================================================================
  programs.fastfetch = {
    # --- 启用 fastfetch ---
    enable = true;

    # --- fastfetch JSON 配置 ---
    settings = {
      # ================================================================
      # Logo 设置
      # 注：此处 logo 设为 "none"，Kitty 终端中通过 bash.nix 的 fastfetch
      #     启动命令单独指定 ~/.config/fastfetch/openbit.png 作为 logo
      # ================================================================
      logo = {
        type = "none";
      };

      # ================================================================
      # 显示设置
      # ================================================================
      display = {
        separator = "->   ";
        color = {
          separator = "1";  # 粗体
        };
        constants = [ "───────────────────────────" ];
        key = {
          type = "both";
          paddingLeft = 4;
        };
      };

      # ================================================================
      # 显示模块
      # ================================================================
      modules = [
        # 标题行
        {
          type = "title";
          format = "                             {user-name-colored}{at-symbol-colored}{host-name-colored}";
        }
        "break"
        # 系统信息头部
        {
          type = "custom";
          format = "┌{\$1} {#1}System Information{#} {\$1}┐";
        }
        "break"
        # 操作系统
        { key = "OS           "; keyColor = "red";    type = "os"; }
        # 主机信息
        { key = "Machine      "; keyColor = "green";  type = "host"; }
        # 内核版本
        { key = "Kernel       "; keyColor = "magenta"; type = "kernel"; }
        # 运行时间
        { key = "Uptime       "; keyColor = "red";    type = "uptime"; }
        # 显示器分辨率
        { key = "Resolution   "; keyColor = "yellow"; type = "display"; compactType = "original-with-refresh-rate"; }
        # 窗口管理器
        { key = "WM           "; keyColor = "blue";   type = "wm"; }
        # 桌面环境
        { key = "DE           "; keyColor = "green";  type = "de"; }
        # Shell
        { key = "Shell        "; keyColor = "cyan";   type = "shell"; }
        # 终端模拟器
        { key = "Terminal     "; keyColor = "red";    type = "terminal"; }
        # CPU
        { key = "CPU          "; keyColor = "yellow"; type = "cpu"; }
        # GPU
        { key = "GPU          "; keyColor = "blue";   type = "gpu"; }
        # 内存
        { key = "Memory       "; keyColor = "magenta"; type = "memory"; }
        # 本地 IP
        { key = "Local IP     "; keyColor = "red";    type = "localip"; compact = true; }
        "break"
        # 底部装饰
        {
          type = "custom";
          format = "└{\$1}────────────────────{\$1}┘";
        }
        "break"
        # 颜色块
        {
          type = "colors";
          paddingLeft = 34;
          symbol = "circle";
        }
      ];
    };
  };

  # ===========================================================================
  # Logo 图片文件
  # 从备份中恢复的 openbit.png，用于 Kitty 终端中 fastfetch 显示
  # ===========================================================================
  home.file.".config/fastfetch/openbit.png".source = ../assets/openbit.png;
}
