# =============================================================================
# 文件名:   modules/desktop/shells/dms.nix
# 功能描述: DankMaterialShell (DMS) - Material Design 风格桌面 Shell
# 说明:     DMS 是基于 QuickShell 框架的 Material Design 风格桌面 Shell，
#           提供系统监控、动态主题、音频波形显示等功能
# 依赖:     quickshell（QuickShell 桌面组件框架）
# =============================================================================
{ config, pkgs, inputs, lib, ... }:

{
  # --- 导入 DMS 的 NixOS 模块 ---
  imports = [
    inputs.dms.nixosModules.default
  ];

  # --- DMS Shell 配置 ---
  programs.dms-shell = {
    enable = true;

    # 指定 QuickShell 包（使用 flake 中的版本）
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

    # 不使用 systemd 管理（由桌面环境启动）
    systemd.enable = false;

    # 启用功能
    enableSystemMonitoring = true;   # 系统监控（CPU/内存/网络）
    enableDynamicTheming = true;     # 动态主题
    enableAudioWavelength = true;    # 音频波形显示
    enableVPN = true;                # VPN 状态显示
  };

  # --- 安装 DMS 包 ---
  environment.systemPackages = [
    inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
