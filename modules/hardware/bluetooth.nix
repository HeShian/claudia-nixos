# =============================================================================
# 文件名:   modules/hardware/bluetooth.nix
# 功能描述: 蓝牙支持配置（BlueZ）
# 说明:     启用系统蓝牙服务、自动开机上电，并安装蓝牙管理工具
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 启用蓝牙支持 ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;   # 启动时自动打开蓝牙控制器
  };

  # --- 蓝牙管理工具 ---
  services.blueman.enable = true;  # Blueman GUI 蓝牙管理器（托盘图标）

  # GNOME 蓝牙未安装 — 使用 Caelestia Shell 的蓝牙配对功能
}
