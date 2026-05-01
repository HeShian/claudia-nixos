# =============================================================================
# 文件名:   modules/develop/build-tools.nix
# 功能描述: 构建工具链配置
# 说明:     安装 C/C++ 编译工具链和项目构建系统
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 构建工具 ---
  environment.systemPackages = with pkgs; [
    # === C/C++ 编译工具链 ===
    gcc           # GNU C/C++ 编译器
    cmake         # CMake 构建系统
    ninja         # Ninja 构建系统（比 Make 更快）
    meson         # Meson 构建系统
    pkg-config    # 包配置工具

    # === GTK 开发库 ===
    gobject-introspection   # GObject 内省绑定
    gtk3                    # GTK3 开发库
    cairo                   # Cairo 2D 图形库

    # === 任务运行器 ===
    just          # Just 命令运行器（类似 Make 但更简洁）

    # === Python 包管理 ===
    uv            # 快速 Python 包管理器（替代 pip）

    # === JavaScript 运行时 ===
    bun           # 快速 JavaScript 运行时、打包器和包管理器
  ];
}
