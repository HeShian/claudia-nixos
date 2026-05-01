# =============================================================================
# 文件名:   modules/multimedia/flatpak.nix
# 功能描述: Flatpak 应用支持配置
# 说明:     启用 Flatpak 服务，配置国内镜像源加速下载，
#           自动安装微信和 QQ 的 Flatpak 版本（替代原生 Linux 版）
#           注意：字体配置统一在 modules/locale/fonts.nix 中管理
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. 启用 Flatpak 服务 ---
  services.flatpak.enable = true;

  # --- 2. 国内 Flatpak 镜像源配置 + 微信/QQ 安装 ---
  # 启动时配置 flathub 镜像源，并安装指定的 Flatpak 应用
  # 上海交通大学镜像源（主），如需切换其他镜像：
  #   中科大：https://mirrors.ustc.edu.cn/flathub
  #   清华大学：https://mirrors.tuna.tsinghua.edu.cn/flathub
  systemd.services.configure-flatpak-repo = {
    description = "配置 Flatpak 国内镜像源并安装指定应用";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "flatpak-system-helper.service" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      # 1. 添加 flathub 远程源（如果不存在）
      flatpak remote-add --if-not-exists flathub \
        https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo

      # 2. 确保 URL 指向上海交通大学镜像
      flatpak remote-modify flathub \
        --url=https://mirror.sjtu.edu.cn/flathub/

      # 3. 安装微信（如果未安装）
      if ! flatpak info com.tencent.WeChat &>/dev/null; then
        echo "[flatpak] 安装微信..."
        flatpak install -y --noninteractive flathub com.tencent.WeChat
      else
        echo "[flatpak] 微信已安装"
      fi

      # 4. 安装 QQ（如果未安装）
      if ! flatpak info com.qq.QQ &>/dev/null; then
        echo "[flatpak] 安装 QQ..."
        flatpak install -y --noninteractive flathub com.qq.QQ
      else
        echo "[flatpak] QQ 已安装"
      fi

      # 5. 刷新元数据
      flatpak update --appstream
    '';
  };
}
