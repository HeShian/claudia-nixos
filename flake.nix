# =============================================================================
# 文件名:   flake.nix
# 功能描述: NixOS Flake 入口文件 - 定义外部依赖和系统构建配置
# 说明:     本文件是 NixOS 配置的入口点，管理所有外部依赖（inputs）
#           并定义系统如何构建。使用 Flakes 特性实现可复现的配置。
# 作者:     claudia
# =============================================================================
{
  description = "NixOS 系统配置 - 采用模块化结构管理";

  # ===========================================================================
  # 外部依赖（inputs）
  # 定义所有需要从外部获取的 Nix 包仓库、框架和工具
  # 命名规范：使用小写短横线命名法（kebab-case）
  # ===========================================================================
  inputs = {
    # --- Nixpkgs 包仓库（滚动更新通道） ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- Home Manager：用户级包管理 ---
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- QuickShell：桌面组件框架（DMS/Noctalia 的基础框架） ---
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- DankMaterialShell：Material Design 风格桌面 Shell ---
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";  # 跟随根的 quickshell，避免拉取两个版本
    };

    # --- Noctalia Shell：另一款 QuickShell 风格桌面 Shell ---
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- NixVim：Neovim 的 Nix 配置框架 ---
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- VS Code Server：远程开发支持 ---
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Caelestia Shell：基于 QuickShell 的桌面 Shell ---
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };

  # ===========================================================================
  # 输出（outputs）
  # 定义系统配置的输出，包括 NixOS 配置和 Home Manager 配置
  # ===========================================================================
  outputs = { self, nixpkgs, ... }@inputs:
  let
    # 系统架构：x86_64-linux（64 位 Intel/AMD）
    system = "x86_64-linux";
  in
  {
    # --- NixOS 系统配置：westwood ---
    nixosConfigurations.westwood = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };

      # ======================================================================
      # 模块列表：按功能分类导入
      # 每个目录下的 default.nix 负责聚合该分类的所有子模块
      # ======================================================================
      modules = [
        # === 第一层：核心系统配置 ===
        ./configuration.nix

        # === 第二层：Home Manager 集成（用户级配置） ===
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";  # 覆盖旧文件前自动备份
          home-manager.users.claudia = {
            imports = [ ./home/default.nix ];
          };
        }

        # === 第三层：功能模块（按分类目录导入） ===
        ./modules/_core          # 核心系统（引导、网络、Nix 设置、安全）
        ./modules/desktop        # 桌面环境（GNOME/Hyprland/Niri + Shell）
        ./modules/locale         # 本地化（中文环境 + 字体）
        ./modules/hardware       # 硬件驱动（NVIDIA、音频、打印）
        ./modules/develop        # 开发工具（语言、构建工具、编辑器）
        ./modules/gaming         # 游戏（Steam、Lutris、Wine）
        ./modules/virtualization # 虚拟化（Docker、libvirtd、Incus）
        ./modules/network        # 网络（镜像源、代理、远程连接）
        ./modules/multimedia     # 多媒体（OBS、Flatpak、剪贴板）
        ./modules/communication  # 通讯（Discord、Telegram）
        ./modules/applications   # 通用应用（浏览器、终端、生产力工具）

        # === 第四层：全局 Overlay（包覆盖/补丁） ===
        # 用于修复上游包的问题，避免直接修改 nixpkgs
        ({ config, pkgs, lib, ... }: {
          nixpkgs.overlays = [
            # 禁用 openldap 的测试阶段（避免构建时运行测试失败）
            (final: prev: {
              openldap = prev.openldap.overrideAttrs (old: {
                doCheck = false;
              });
            })
          ];
        })
      ];
    };
  };
}
