# =============================================================================
# 文件名:   modules/virtualization/docker.nix
# 功能描述: Docker 容器引擎配置
# 说明:     启用 Docker 容器引擎，安装 Docker 客户端和管理工具
#           注意：Docker 和 Podman 不能同时启用
#           Docker 命令行客户端由 virtualisation.docker.enable 自动安装
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. Docker 引擎 ---
  virtualisation.docker = {
    enable = true;
    # Docker CLI 会自动安装，无需额外添加 docker-client
    # 如需 rootless 模式（非 root 用户运行），取消下面注释：
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # --- 2. Docker 管理工具 ---
  environment.systemPackages = with pkgs; [
    lazydocker    # Docker TUI 管理工具（终端图形界面）
  ];
}
