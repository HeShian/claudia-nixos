# =============================================================================
# 文件名:   modules/multimedia/flatpak.nix
# 功能描述: Flatpak 应用支持配置
# 说明:     启用 Flatpak 服务，配置国内镜像源加速下载
#           注意：字体配置统一在 modules/locale/fonts.nix 中管理
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 启用 Flatpak 服务 ---
  services.flatpak.enable = true;

  # --- 2. 国内 Flatpak 镜像源配置 ---
  # 启动后自动将 flathub 远程源切换为国内镜像，加速下载
  # 上海交通大学镜像源（主），如需切换其他镜像：
  #   中科大：https://mirrors.ustc.edu.cn/flathub
  #   清华大学：https://mirrors.tuna.tsinghua.edu.cn/flathub
  systemd.services.configure-flatpak-repo = {
    description = "配置 Flatpak 国内镜像源";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      # 添加 flathub 远程源（如果不存在）
      flatpak remote-add --if-not-exists flathub https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo
      # 确保 URL 指向上海交通大学镜像（之前的 remote-modify 可能会覆盖其他远程源，现仅设置一次）
      flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub/
      # 刷新元数据
      flatpak update --appstream
    '';
  };
}
