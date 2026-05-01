# =============================================================================
# 文件名:   modules/virtualization/libvirtd.nix
# 功能描述: libvirtd/QEMU/KVM 虚拟化平台配置
# 说明:     配置完整的虚拟化平台，支持 QEMU/KVM 虚拟机，
#           含 TPM 模拟、SPICE 协议、UEFI 启动等高级功能
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. libvirtd 服务配置 ---
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";     # 开机启动
    onShutdown = "shutdown";  # 关机时优雅关闭

    qemu = {
      # 以非 root 用户运行 QEMU（更安全）
      runAsRoot = false;

      # TPM 模拟支持（Windows 11 需要）
      swtpm.enable = true;

      # virtiofsd：共享目录的高性能方案
      vhostUserPackages = with pkgs; [ virtiofsd ];

      # QEMU 配置
      verbatimConfig = ''
        user = "qemu-libvirtd"
        group = "kvm"
        dynamic_ownership = 1
        remember_owner = 0
      '';
    };

    # 允许的网桥接口
    allowedBridges = [
      "virbr0"  # 默认 NAT 网桥
      "br0"     # 自定义网桥（如需）
    ];
  };

  # --- 2. USB 重定向支持 ---
  virtualisation.spiceUSBRedirection.enable = true;

  # --- 3. 管理工具 ---
  programs = {
    virt-manager.enable = true;   # 图形化虚拟机管理器
    dconf.enable = true;          # virt-manager 设置需要
  };

  # --- 4. 虚拟化工具包 ---
  environment.systemPackages = with pkgs; [
    virt-viewer       # 虚拟机查看器（SPICE/VNC）
    qemu_kvm          # QEMU KVM 支持
    OVMF              # UEFI 固件
    swtpm             # TPM 模拟
    libguestfs        # 虚拟机磁盘工具
    virt-top          # 虚拟机性能监控
    spice             # SPICE 协议支持
    spice-gtk         # SPICE 客户端 GTK
    spice-protocol    # SPICE 协议头
    virglrenderer     # 虚拟 GPU 支持
    mesa              # OpenGL 支持（虚拟机 3D 加速）
  ];

  # --- 5. 内核模块 ---
  # 当前系统为 Intel CPU，只加载 kvm-intel（避免 kvm-amd 加载失败的内核日志告警）
  # 如果换用 AMD CPU，将 "kvm-intel" 改为 "kvm-amd"
  boot.kernelModules = [
    "kvm-intel"   # Intel CPU 虚拟化
    "vfio-pci"    # PCI 直通
  ];

  # --- 6. 内核参数 ---
  boot.kernelParams = [
    "intel_iommu=on"  # 启用 Intel IOMMU（PCI 直通需要）
    "iommu=pt"        # IOMMU 直通模式
  ];

  # --- 7. 默认目录 ---
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"    # ISO 镜像目录
    "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"  # 虚拟机磁盘目录
  ];
}
