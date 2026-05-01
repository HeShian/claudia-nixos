# =============================================================================
# 文件名:   modules/desktop/display-manager.nix
# 功能描述: 登录管理器配置
# 说明:     配置 GDM 登录管理器
#           注意：GDM 本身的启用已在 gnome.nix 中完成，此处仅做扩展配置
# =============================================================================
{ config, pkgs, ... }:

{
  # --- GDM 登录管理器扩展配置 ---
  # GDM 已在 gnome.nix 中通过 services.displayManager.gdm.enable 启用

  # 自动登录已禁用（auto-login 在 GNOME + Niri 双桌面下会导致先进入 GNOME）
  # 如需启用：取消下面注释并设置 defaultSession 为对应的桌面会话

  # 默认桌面会话：Niri（GDM 登录界面默认选中 Niri 而非 GNOME）
  # services.displayManager.defaultSession = "niri";
}
