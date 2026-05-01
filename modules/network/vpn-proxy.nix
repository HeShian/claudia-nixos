# =============================================================================
# 文件名:   modules/network/vpn-proxy.nix
# 功能描述: VPN/代理服务配置
# 说明:     配置 v2rayA 代理服务和 Clash Verge Rev 客户端，
#           开启 IP 转发以支持 TUN 模式。
#           注意：v2rayA 和 Clash Verge Rev 同时开启可能导致端口冲突或
#           路由表覆盖，建议日常只使用其中一个。如仅需 Clash Verge Rev，
#           可注释 services.v2raya.enable。
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. v2rayA 代理服务 ---
  # v2rayA 会自动处理 v2ray 内核
  services.v2raya.enable = true;

  # --- 2. Clash Verge Rev（GUI 代理客户端） ---
  environment.systemPackages = with pkgs; [
    clash-verge-rev
  ];
  programs.clash-verge = {
    enable = true;
    tunMode = true;  # 启用 TUN 模式（全局代理，会修改系统路由表）
  };

  # --- 3. IP 转发 ---
  # TUN 模式需要开启 IP 转发
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;              # 开启 IPv4 转发
    "net.ipv6.conf.all.forwarding" = 1;     # 开启 IPv6 转发
  };

  # --- 4. 防火墙配置 ---
  networking = {
    firewall = {
      # v2rayA Web UI 端口
      allowedTCPPorts = [ 2017 ];
      allowedUDPPorts = [ 2017 ];
    };
  };
}
