# =============================================================================
# 文件名:   modules/virtualization/incus.nix
# 功能描述: Incus 容器管理系统配置
# 说明:     Incus 是 LXD 的社区分支，提供系统容器管理能力，
#           配置了 Web UI、桥接网络、存储池和默认配置
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # --- 1. 启用 Incus 服务 ---
  virtualisation.incus.enable = true;

  # --- 2. 启用 Web UI ---
  virtualisation.incus.ui.enable = true;

  # --- 3. nftables（Incus 现代架构要求）---
  networking.nftables.enable = true;

  # --- 4. 防火墙放行 Incus 网桥 ---
  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # --- 5. Incus 初始配置 ---
  virtualisation.incus.preseed = {
    # Web UI 监听地址
    config = {
      "core.https_address" = "127.0.0.1:17171";
    };

    # 桥接网络配置
    networks = [
      {
        name = "incusbr0";
        type = "bridge";
        config = {
          "ipv4.address" = "10.0.100.1/24";
          "ipv4.nat" = "true";
        };
      }
    ];

    # 存储池配置
    storage_pools = [
      {
        name = "default";
        driver = "dir";
        config = { source = "/var/lib/incus/storage-pools/default"; };
      }
    ];

    # 默认配置文件
    profiles = [
      {
        name = "default";
        devices = {
          eth0 = { name = "eth0"; network = "incusbr0"; type = "nic"; };
          root = { path = "/"; pool = "default"; type = "disk"; };
        };
      }
    ];
  };

  # --- 6. 安装 Incus 软件包 ---
  environment.systemPackages = with pkgs; [
    incus
  ];
}
