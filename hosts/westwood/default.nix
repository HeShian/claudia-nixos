# =============================================================================
# 文件名:   hosts/westwood/default.nix
# 功能描述: NixOS 系统核心配置入口（westwood 主机）
# 说明:     本文件仅包含导入和全局设置，具体功能拆分到 modules/ 各子模块。
#           保持此文件精简，便于快速了解系统整体架构。
# =============================================================================
{ config, pkgs, inputs, ... }:

{
  # ===========================================================================
  # 导入
  # ===========================================================================
  imports = [
    # --- 硬件配置（自动生成，请勿手动修改） ---
    ./hardware-configuration.nix

    # --- VS Code Server 支持（远程开发） ---
    inputs.vscode-server.nixosModules.default
  ];

  # ===========================================================================
  # 全局设置
  # ===========================================================================

  # --- 允许使用 unfree（非开源）软件包 ---
  # 例如：NVIDIA 驱动、Steam、VS Code 等
  # 同时 nix-settings.nix 中设置了 NIXPKGS_ALLOW_UNFREE 环境变量作为补充
  nixpkgs.config.allowUnfree = true;

  # --- 全局环境变量 ---
  environment.sessionVariables = {
    TERMINAL = "kitty";  # Thunar 等应用的默认终端
  };

  # --- 启用 Thunar（含 gvfs/thunar-volman/tumbler 集成）---
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin  # 右键压缩/解压
      thunar-volman          # 自动挂载管理
    ];
  };

  # --- 系统状态版本 ---
  # 用于兼容性检查，升级 NixOS 版本时更新此值
  # 注意：此值仅用于兼容性判断，不控制实际系统版本
  system.stateVersion = "26.05";
}
