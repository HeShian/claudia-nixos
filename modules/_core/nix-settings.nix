# =============================================================================
# 文件名:   modules/_core/nix-settings.nix
# 功能描述: Nix 包管理器自身配置
# 说明:     配置镜像源、下载缓存、超时等 Nix 设置
#           优先使用国内镜像站加速下载
# 注意:     所有 nix.settings 属性集中在此文件管理，避免与其他模块冲突
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ===========================================================================
  # Nix 包管理器全局设置
  # 注意：所有 nix.settings 属性集中在此处定义，避免多个模块分散定义导致冲突
  # ===========================================================================
  nix.settings = {
    # --- 实验特性 ---
    # 启用 Flakes 和 nix-command，这是使用 Flake 配置的前提
    experimental-features = [ "nix-command" "flakes" ];

    # --- 镜像源配置 ---
    # 优先使用国内镜像站，加速 Nix 包下载
    # 使用 mkDefault 允许其他模块覆盖（如需要切换回官方源）
    substituters = lib.mkDefault [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华大学镜像（主）
      "https://mirrors.ustc.edu.cn/nix-channels/store"           # 中国科学技术大学镜像（备）
      "https://cache.nixos.org/"                                 # 官方源（兜底）
    ];

    # --- 下载优化 ---
    # 下载缓存大小：500MB，防止大文件下载中断
    download-buffer-size = lib.mkDefault 524288000;

    # 连接超时：5 秒
    connect-timeout = lib.mkDefault 5;

    # 下载失败时自动回退到其他镜像源
    fallback = lib.mkDefault true;

    # --- Nix 商店优化 ---
    # 自动检测并合并重复的 store 路径，节省磁盘空间
    auto-optimise-store = true;
  };

  # --- GitHub 访问令牌（可选）---
  # 用于提高 GitHub API 的访问频率限制（从 60 次/小时提升到 5000 次/小时）
  # 如果文件不存在，Nix 会忽略此配置
  # 创建方式：sudo mkdir -p /etc/nix && echo "access-tokens = github=<你的Token>" | sudo tee /etc/nix/github-access-tokens
  nix.extraOptions = ''
    !include /etc/nix/github-access-tokens
  '';

  # 全局环境变量（对所有用户生效）
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE = "1";  # 允许 unfree 软件包
  };

  # 会话级环境变量（用户登录 Shell 时加载，支持动态值）
  # 注意：GOPROXY 仅在此处定义一次，避免重复设置
  environment.sessionVariables = {
    GOPROXY = "https://goproxy.cn,direct";  # Go 模块代理（国内镜像）
    GO111MODULE = "on";                     # 强制启用 Go Modules
  };

  # ===========================================================================
  # Nix 垃圾回收（自动清理旧版本，节省磁盘空间）
  # ===========================================================================
  nix.gc = {
    automatic = true;                     # 自动运行
    dates = "weekly";                     # 每周清理一次
    options = "--delete-older-than 14d";  # 删除 14 天前的旧版本
  };

}
