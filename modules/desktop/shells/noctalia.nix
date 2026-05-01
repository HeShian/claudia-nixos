# =============================================================================
# 文件名:   modules/desktop/shells/noctalia.nix
# 功能描述: Noctalia Shell - 另一款 QuickShell 风格桌面 Shell
# 说明:     Noctalia 是基于 QuickShell 框架的桌面 Shell，
#           提供现代化的桌面组件和视觉效果
# 依赖:     noctalia（Noctalia Shell flake 输入）
# =============================================================================
{ pkgs, inputs, ... }:

{
  # --- 安装 Noctalia Shell ---
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
