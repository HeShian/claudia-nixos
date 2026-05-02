# =============================================================================
# 文件名:   modules/_core/boot.nix
# 功能描述: 系统引导与内核配置
# 说明:     配置 systemd-boot 引导程序、EFI 支持和内核模块
# =============================================================================
{ ... }:

{
  # --- 1. 引导配置 ---
  # 使用 systemd-boot 作为引导管理器
  boot.loader.systemd-boot.enable = true;
  # 允许操作 EFI 变量（如设置启动顺序）
  boot.loader.efi.canTouchEfiVariables = true;

  # --- 2. 文件系统支持 ---
  # 启用 NTFS 文件系统支持（用于 Windows 分区或移动硬盘）
  boot.supportedFilesystems = [ "ntfs" ];
}
