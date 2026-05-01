# =============================================================================
# 文件名:   modules/gaming/steam.nix
# 功能描述: Steam 游戏平台配置
# 说明:     配置 Steam 游戏平台，启用远程畅玩和游戏服务器功能
#           注意：hardware.graphics 已在 hardware/nvidia.nix 中统一配置
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. Steam 配置 ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;       # Steam 远程畅玩（流式传输）
    dedicatedServer.openFirewall = true;  # 游戏专用服务器
  };

  # 注：Lutris 和 Heroic 游戏启动器已移至 lutris-heroic.nix 统一管理
}
