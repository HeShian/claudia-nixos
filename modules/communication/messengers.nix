# =============================================================================
# 文件名:   modules/communication/messengers.nix
# 功能描述: 即时通讯软件配置
# 说明:     安装 Discord 和 Telegram 桌面版
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 即时通讯软件 ---
  environment.systemPackages = with pkgs; [
    discord           # Discord 语音/文字聊天
    telegram-desktop  # Telegram 桌面客户端
    wechat            # 微信（原生 Linux 版，替代 Flatpak）
    qq                # QQ（原生 Linux 版，替代 Flatpak）
  ];
}
