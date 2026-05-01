# =============================================================================
# 文件名:   modules/gaming/lutris-heroic.nix
# 功能描述: Lutris 和 Heroic 游戏启动器配置
# 说明:     Lutris 是开源游戏管理平台，支持多平台游戏整合；
#           Heroic 是 Epic Games Store 和 GOG 的开源启动器。
#           两者从 steam.nix 迁移至此文件统一管理。
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 游戏启动器 ---
  environment.systemPackages = with pkgs; [
    lutris   # Lutris 游戏管理平台（整合 Steam/Epic/GOG/Wine 等）
    heroic   # Heroic Games Launcher（Epic Games Store / GOG 游戏）
  ];
}
