# =============================================================================
# 文件名:   modules/applications/downloaders.nix
# 功能描述: 下载工具配置
# 说明:     安装常用下载工具
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 下载工具 ---
  environment.systemPackages = with pkgs; [
    gopeed       # 高速下载工具（支持多协议）
    qbittorrent  # BitTorrent 客户端
  ];
}
