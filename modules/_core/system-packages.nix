# =============================================================================
# 文件名:   modules/_core/system-packages.nix
# 功能描述: 系统级软件包配置
# 说明:     安装系统全局可用的软件包，所有用户均可使用。
#           各模块特定的软件包（如开发工具、游戏、虚拟化）请在其对应模块中安装。
#           此处仅放置与多个模块交叉依赖或系统必备的包。
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 系统级软件包 ---
  environment.systemPackages = with pkgs; [
    # === Wayland 工具 ===
    xwayland-satellite          # XWayland 增强工具
  ];

  # 注意：GStreamer 插件集（gst-plugins-*）已从此处移除，
  # 因为它们作为多媒体应用的依赖会自动被引入，无需显式安装。

  # --- 允许的不安全软件包 ---
  # incus 依赖 minio 作为存储后端，但 minio 已停止维护（有 CVE）。
  # 安全说明：此 minio 仅作为 incus 的内部依赖使用，不对外暴露服务端口，
  # 风险可控。如需彻底消除此风险，考虑迁移 incus 存储后端或替换容器方案。
  nixpkgs.config.permittedInsecurePackages = [
    "minio-2025-10-15T17-29-55Z"
  ];

  # --- VS Code Server ---
  # 允许通过 SSH 远程连接时使用 VS Code
  services.vscode-server.enable = true;
}
