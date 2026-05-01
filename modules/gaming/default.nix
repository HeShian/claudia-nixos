# =============================================================================
# 文件名:   modules/gaming/default.nix
# 功能描述: 游戏模块聚合入口
# 说明:     导入所有游戏相关配置：Steam 平台、游戏启动器、Wine 兼容层
# =============================================================================
{ config, pkgs, ... }:

{
  imports = [
    ./steam.nix           # Steam 游戏平台
    ./lutris-heroic.nix   # Lutris + Heroic 游戏启动器
    ./wine.nix            # Wine 兼容层 + Bottles
  ];
}
