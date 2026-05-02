# =============================================================================
# 文件名:   modules/_core/security.nix
# 功能描述: 用户账户与安全配置
# 说明:     配置系统用户、用户组、SSH 服务等安全相关设置
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 用户账户 ---
  users.users.claudia = {
    isNormalUser = true;
    description = "claudia";
    shell = pkgs.zsh;                     # 默认 Shell 使用 ZSH
    extraGroups = [
      "networkmanager"  # 网络管理权限
      "wheel"           # sudo 权限
      "libvirtd"        # libvirtd 虚拟化管理
      "qemu"            # QEMU 虚拟化
      "kvm"             # KVM 虚拟化
      "docker"          # Docker 容器管理
      "incus-admin"     # Incus 容器管理
    ];
  };

  # --- 2. ZSH 默认 Shell ---
  # 系统级启用 ZSH（配合 shell = pkgs.zsh 使用）
  programs.zsh.enable = true;

  # --- 3. Sudo 免密配置 ---
  # wheel 组成员无需密码即可使用 sudo（个人桌面环境安全可控）
  security.sudo.wheelNeedsPassword = false;

  # --- 4. SSH 服务 ---
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
    };
  };

  # 放行 SSH 端口（防火墙默认开启时需要）
  networking.firewall.allowedTCPPorts = [ 22 ];

  # --- 5. Nix 可执行文件支持 ---
  # 允许运行未打包在 Nix 商店中的可执行文件（如 AppImage）
  programs.nix-ld.enable = true;
}
