# =============================================================================
# 文件名:   modules/gaming/wine.nix
# 功能描述: Wine 兼容层配置
# 说明:     安装 Wine（Windows 应用兼容层）、Winetricks 和 Bottles，
#           用于在 Linux 上运行 Windows 游戏和应用
# =============================================================================
{ config, pkgs, ... }:

{
  # --- Wine 生态工具 ---
  environment.systemPackages = with pkgs; [
    # === Wine 兼容层 ===
    # 推荐：wineWowPackages 同时支持 32/64 位，兼容性最好
    wineWow64Packages.stable    # Wine 稳定版（不再使用已弃用的 wineWowPackages）

    # 辅助工具：用于安装字体、运行库等
    winetricks

    # === Bottles ===
    # 图形化的 Wine 前缀管理器
    bottles
  ];
}
