# =============================================================================
# 文件名:   modules/virtualization/default.nix
# 功能描述: 虚拟化模块聚合入口
# 说明:     导入所有虚拟化相关配置：Docker、libvirtd/QEMU、Incus
# =============================================================================
{ config, pkgs, ... }:

{
  imports = [
    ./docker.nix      # Docker 容器引擎
    ./libvirtd.nix    # libvirtd/QEMU/KVM 虚拟化
    ./incus.nix       # Incus 容器管理
  ];
}
