# =============================================================================
# 文件名:   modules/desktop/shells/caelestia.nix
# 功能描述: Caelestia Shell - 基于 QuickShell 的现代化桌面 Shell
# 说明:     Caelestia 是 QuickShell 框架上的桌面 Shell，
#           提供控制中心、启动器、锁屏、仪表盘等功能组件。
#           通过 caelestia shell IPC 接口与快捷键交互。
# 依赖:     caelestia-shell（Caelestia Shell flake 输入）
# =============================================================================
{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # --- 安装 Caelestia Shell（含 CLI） ---
  # caelestia-shell: QuickShell 包装器，用于启动 Shell
  # caelestia-cli: 命令行工具，提供 caelestia shell controlCenter open 等 IPC 命令
  environment.systemPackages = [
    inputs.caelestia-shell.packages.${system}.with-cli
    inputs.caelestia-shell.inputs.caelestia-cli.packages.${system}.default
  ];
}
