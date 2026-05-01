# =============================================================================
# 文件名:   home/git.nix
# 功能描述: Git 版本控制配置
# 说明:     配置 Git 用户信息。注意：GitHub Token 等敏感信息不应硬编码在此文件。
#           Token 管理方式（选其一）：
#           1. 命令行设置：git config --global github.token "your_token"
#           2. 使用 gh CLI：gh auth login
#           3. 环境变量：export GITHUB_TOKEN="your_token"
#           4. 通过 /etc/nix/github-access-tokens 管理（用于 Nix 构建）
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Git 配置
  # ===========================================================================
  programs.git = {
    # --- 启用 Git ---
    enable = true;

    # --- Git 用户信息 ---
    extraConfig = {
      user = {
        name = "claudia";
        email = "3453289292@qq.com";
      };
    };
  };
}
