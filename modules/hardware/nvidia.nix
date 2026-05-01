# =============================================================================
# 文件名:   modules/hardware/nvidia.nix
# 功能描述: NVIDIA 显卡驱动配置
# 说明:     配置 NVIDIA 闭源驱动，支持 Wayland 和 X11，
#           启用 modesetting 和电源管理功能
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 图形加速基础支持 ---
  # 启用 OpenGL 支持（64位和32位）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # 32位支持（Steam 游戏需要）
    extraPackages = with pkgs; [
      nvidia-vaapi-driver  # NVIDIA VA-API 硬件解码
    ];
  };

  # --- 2. NVIDIA 驱动配置 ---
  hardware.nvidia = {
    # Modesetting：必须启用，Wayland 和 PRIME 同步需要
    modesetting.enable = true;

    # 电源管理：休眠后唤醒不会花屏
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # 使用闭源驱动（不使用 open 内核模块）
    open = false;

    # 启用 NVIDIA 设置面板
    nvidiaSettings = true;

    # 使用稳定版驱动
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # --- 3. X11 视频驱动 ---
  # 同时为 Xorg 和 Wayland 加载 NVIDIA 驱动
  services.xserver.videoDrivers = [ "nvidia" ];
}
