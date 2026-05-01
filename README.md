# Claudia's NixOS Configuration 💠

> *Declarative. Reproducible. Modular.*

[English](#english) | [中文](#chinese)

---

<a id="english"></a>
## English

### Overview

This repository contains my personal NixOS system configuration, managed entirely through [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager). Every package, service, theme, and dotfile is declaratively defined—no manual setup required.

**Machine**: `westwood` (x86_64-linux, NixOS 26.05 unstable)

### Architecture

```
/etc/nixos/
├── flake.nix                 # Entry point — inputs, system definition
├── flake.lock                # Locked dependency versions (reproducible!)
├── configuration.nix         # Top-level system config (minimal by design)
├── hardware-configuration.nix # Auto-generated — disk/CPU/hardware info
├── modules/                  # System-level modules (11 categories)
│   ├── _core/               # Boot, networking, Nix settings, security
│   ├── desktop/             # GNOME + Hyprland + Niri + GDM + theming
│   ├── hardware/            # NVIDIA GPU, PipeWire audio, printing
│   ├── locale/              # Chinese locale, Fcitx5 IME, fonts
│   ├── develop/             # Languages, build tools, editors (VS Code / NixVim)
│   ├── gaming/              # Steam, Lutris, Heroic, Wine/Bottles
│   ├── virtualization/      # Docker, KVM/QEMU/libvirtd, Incus
│   ├── network/             # VPN/proxy (v2rayA + Clash), SSH
│   ├── multimedia/          # OBS, Flatpak, clipboard tools
│   ├── communication/       # Discord, Telegram
│   └── applications/        # Browsers, terminals, productivity tools
└── home/                    # User-level Home Manager configs
    ├── default.nix          # Entry — packages, env vars, Nautilus
    ├── bash.nix / zsh.nix / fish.nix  # Shell configs (Starship prompt)
    ├── hyprland.nix / niri.nix        # WM keybinds, layout, theming
    ├── alacritty.nix / kitty.nix      # Terminal emulators
    ├── git.nix / vim.nix              # Development tools
    ├── theming.nix                     # GTK/Kvantum (Dracula dark)
    └── migration.nix                  # Legacy configs + Noctalia theme generator
```

### Key Features

| Area | What's Configured |
|---|---|
| **Desktop** | GNOME 49 + Hyprland 0.54 + Niri — triple WM, switch at login |
| **Shell** | Noctalia Shell (QuickShell-based desktop widgets) |
| **GPU** | NVIDIA proprietary driver with modesetting + VA-API |
| **Audio** | PipeWire with WirePlumber, ALSA/PulseAudio compat |
| **Input** | Fcitx5 (Pinyin + Rime) with Nord theme |
| **Fonts** | Cascadia Code, JetBrains Mono Nerd Font, Noto CJK |
| **Theme** | Dracula dark — GTK 2/3/4 + Kvantum (Qt5/Qt6) |
| **Terminal** | Kitty (primary) + Alacritty, both with fastfetch on launch |
| **Shell** | ZSH + Bash + Fish, all with Starship prompt |
| **Editor** | Vim + Neovim (NixVim), clipboard integrated via wl-clipboard |
| **VM** | Docker + KVM/QEMU (libvirtd) + Incus |
| **Gaming** | Steam + Lutris + Heroic + Wine/Bottles |
| **VPN** | v2rayA + Clash Verge Rev |
| **Nix Cache** | Tsinghua + USTC mirrors, weekly auto GC |

### Design Patterns

**`home.activation` for writable configs** — Some desktop tools (Noctalia, Qt theming) need to *write* to their config files at runtime. Standard `xdg.configFile` creates read-only symlinks to the Nix store, which silently break runtime writes. The solution used here: `home.activation` scripts that copy defaults from the Nix store as **real files** — but only when the target doesn't already exist. This guarantees a working default while allowing the application to update its own config later.

**Hyprland + Noctalia color pipeline** — Noctalia-shell generates `noctalia-colors.conf` at `~/.config/hypr/noctalia/` containing Hyprland color variables (`$primary`, `$surface`, etc.) via its template pipeline. The file doesn't exist until Noctalia runs. To prevent Hyprland startup failures, `home.activation.copyNoctaliaHyprColors` pre-seeds a default file using the same color palette defined in `colors.json`. Once Noctalia-shell starts, it replaces the file with its own dynamic palette (e.g., generated from wallpaper).

### How to Reproduce

> ⚠️ **WARNING**: This configuration is tailored to my specific hardware. Review and adjust before deploying!

#### 1. Install NixOS

Install NixOS 25.05+ from the [official ISO](https://nixos.org/download). Choose the **unstable channel** or switch after installation.

#### 2. Clone This Repository

```bash
sudo mkdir -p /etc/nixos
sudo chown $USER /etc/nixos
git clone https://github.com/HeShian/claudia-nixos.git /etc/nixos
```

#### 3. Customize Hardware Configuration

The included `hardware-configuration.nix` is **my machine's hardware config**. You MUST replace it:

```bash
# Generate your own hardware config
sudo nixos-generate-config --root /
# Copy and review the generated file
sudo cp /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/
# Or merge needed parts from:
# sudo nixos-generate-config --show-hardware-config
```

**Things you MUST adjust:**
- Disk partitions and filesystem UUIDs in `hardware-configuration.nix`
- GPU driver: If you have AMD/Intel, comment out NVIDIA config in `modules/hardware/nvidia.nix`
- CPU microcode: `kvm-intel` → `kvm-amd` if using AMD
- Display outputs: Monitor names in `home/hyprland.nix` and `home/niri.nix`

#### 4. Add GitHub Access Token (Optional)

For higher GitHub API rate limits during Nix builds:

```bash
sudo mkdir -p /etc/nix
echo "access-tokens = github.com=YOUR_TOKEN" | sudo tee /etc/nix/github-access-tokens
sudo chmod 600 /etc/nix/github-access-tokens
```

#### 5. Build and Switch

```bash
sudo nixos-rebuild switch --flake /etc/nixos#westwood
```

#### 6. Reboot

```bash
sudo reboot
```

After reboot, log in as user `claudia` (or change the username in `modules/_core/security.nix` before building). The default password should be set via `passwd` after first login.

### Making It Your Own

1. **Username**: Replace `claudia` in `modules/_core/security.nix` and `flake.nix`
2. **Hostname**: Change `networking.hostName` in `modules/_core/network.nix`
3. **Machine name**: Rename `westwood` in `flake.nix` → `nixosConfigurations.<your-name>`
4. **Theme**: Modify `home/theming.nix` and `modules/desktop/theming.nix`
5. **Packages**: Add/remove from respective module files

### Flake Inputs

| Input | Purpose |
|---|---|
| `nixpkgs/nixos-unstable` | Rolling-release package collection |
| `nix-community/home-manager` | User-level package and dotfile management |
| `outfoxxed/quickshell` | Desktop widget framework (foundation for DMS/Noctalia) |
| `AvengeMedia/DankMaterialShell` | Material Design desktop shell |
| `noctalia-dev/noctalia-shell` | Noctalia desktop shell |
| `nix-community/nixvim` | Neovim configuration framework |
| `nix-community/nixos-vscode-server` | VS Code remote development support |

### Updates

```bash
# Update all flake inputs to latest versions
nix flake update --flake /etc/nixos

# Rebuild
sudo nixos-rebuild switch --flake /etc/nixos#westwood
```

---

<a id="chinese"></a>
## 中文

### 概述

此仓库包含我的个人 NixOS 系统配置，完全通过 [Nix Flakes](https://nixos.wiki/wiki/Flakes) 和 [Home Manager](https://github.com/nix-community/home-manager) 管理。所有软件包、服务、主题和配置文件均以声明式方式定义——无需任何手动配置。

**机器名**：`westwood`（x86_64-linux，NixOS 26.05 unstable）

### 架构

```
/etc/nixos/
├── flake.nix                 # 入口 — 外部依赖、系统定义
├── flake.lock                # 锁定版本（保证可复现！）
├── configuration.nix         # 顶层系统配置（刻意保持精简）
├── hardware-configuration.nix # 自动生成 — 磁盘/CPU/硬件信息
├── modules/                  # 系统级模块（11 个分类）
│   ├── _core/               # 引导、网络、Nix 设置、安全
│   ├── desktop/             # GNOME + Hyprland + Niri + GDM + 主题
│   ├── hardware/            # NVIDIA 驱动、PipeWire 音频、打印
│   ├── locale/              # 中文环境、Fcitx5 输入法、字体
│   ├── develop/             # 编程语言、构建工具、编辑器(NixVim/VS Code)
│   ├── gaming/              # Steam、Lutris、Heroic、Wine/Bottles
│   ├── virtualization/      # Docker、KVM/QEMU/libvirtd、Incus
│   ├── network/             # VPN/代理(v2rayA + Clash)、SSH
│   ├── multimedia/          # OBS、Flatpak、剪贴板工具
│   ├── communication/       # Discord、Telegram
│   └── applications/        # 浏览器、终端、生产力工具
└── home/                    # 用户级 Home Manager 配置
    ├── default.nix          # 入口 — 软件包、环境变量、Nautilus
    ├── bash.nix / zsh.nix / fish.nix  # Shell 配置(Starship 提示符)
    ├── hyprland.nix / niri.nix        # 窗口管理器键位、布局、主题
    ├── alacritty.nix / kitty.nix      # 终端模拟器
    ├── git.nix / vim.nix              # 开发工具
    ├── theming.nix                     # GTK/Kvantum(Dracula 暗色主题)
    └── migration.nix                  # 遗留配置 + Noctalia 主题生成器
```

### 核心特性

| 领域 | 配置内容 |
|---|---|
| **桌面** | GNOME 49 + Hyprland 0.54 + Niri — 三种 WM，登录时切换 |
| **Shell** | Noctalia Shell（基于 QuickShell 的桌面组件） |
| **显卡** | NVIDIA 闭源驱动 + modesetting + VA-API 硬件解码 |
| **音频** | PipeWire + WirePlumber，兼容 ALSA/PulseAudio |
| **输入法** | Fcitx5（拼音 + Rime 中古音），Nord 主题 |
| **字体** | Cascadia Code、JetBrains Mono Nerd Font、Noto CJK |
| **主题** | Dracula 暗色 — GTK 2/3/4 + Kvantum（Qt5/Qt6） |
| **终端** | Kitty（主力）+ Alacritty，启动时自动显示 fastfetch |
| **Shell** | ZSH + Bash + Fish，统一使用 Starship 提示符 |
| **编辑器** | Vim + Neovim (NixVim)，系统剪贴板集成(wl-clipboard) |
| **虚拟化** | Docker + KVM/QEMU (libvirtd) + Incus |
| **游戏** | Steam + Lutris + Heroic + Wine/Bottles |
| **代理** | v2rayA + Clash Verge Rev |
| **Nix 源** | 清华大学 + 中科大镜像，每周自动垃圾回收 |

### 设计模式

**`home.activation` 处理可写配置** — 某些桌面工具（Noctalia、Qt 主题）需要在运行时*写入*其配置文件。标准的 `xdg.configFile` 会创建指向 Nix store 的只读符号链接，导致运行时写入静默失败。本仓库的解决方案：使用 `home.activation` 脚本将默认配置从 Nix store 复制为**真实文件**——但仅在目标文件不存在时执行。这既保证了开箱即用的默认配置，又允许应用程序后续更新自己的配置。

**Hyprland + Noctalia 颜色管道** — Noctalia-shell 通过其模板管道在 `~/.config/hypr/noctalia/` 生成 `noctalia-colors.conf`，包含 Hyprland 颜色变量（`$primary`、`$surface` 等）。该文件在 Noctalia 运行前不存在。为防止 Hyprland 启动失败，`home.activation.copyNoctaliaHyprColors` 使用 `colors.json` 中相同的调色板预置默认文件。Noctalia-shell 启动后会用其动态调色板（例如从壁纸生成）替换该文件。

### 复现方法

> ⚠️ **警告**：此配置针对我的特定硬件定制。部署前请仔细审查和修改！

#### 1. 安装 NixOS

从[官方 ISO](https://nixos.org/download) 安装 NixOS 25.05+。选择 **unstable 通道**或安装后切换。

#### 2. 克隆本仓库

```bash
sudo mkdir -p /etc/nixos
sudo chown $USER /etc/nixos
git clone https://github.com/HeShian/claudia-nixos.git /etc/nixos
```

#### 3. 自定义硬件配置

仓库中包含的 `hardware-configuration.nix` 是**我的硬件配置**。你必须替换它：

```bash
# 生成你自己的硬件配置
sudo nixos-generate-config --root /
# 复制并检查生成的文件
sudo cp /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/
# 或合并所需部分：
# sudo nixos-generate-config --show-hardware-config
```

**必须调整的内容：**
- `hardware-configuration.nix` 中的磁盘分区和文件系统 UUID
- GPU 驱动：AMD/Intel 用户需注释掉 `modules/hardware/nvidia.nix`
- CPU 微码：AMD 用户将 `kvm-intel` 改为 `kvm-amd`
- 显示器输出：修改 `home/hyprland.nix` 和 `home/niri.nix` 中的显示器名称

#### 4. 添加 GitHub 访问令牌（可选）

用于提升 Nix 构建时的 GitHub API 频率限制：

```bash
sudo mkdir -p /etc/nix
echo "access-tokens = github.com=你的令牌" | sudo tee /etc/nix/github-access-tokens
sudo chmod 600 /etc/nix/github-access-tokens
```

#### 5. 构建并切换

```bash
sudo nixos-rebuild switch --flake /etc/nixos#westwood
```

#### 6. 重启

```bash
sudo reboot
```

重启后以用户 `claudia` 登录（如需修改用户名，请在构建前编辑 `modules/_core/security.nix`）。首次登录后通过 `passwd` 设置密码。

### 个性化定制

1. **用户名**：替换 `modules/_core/security.nix` 和 `flake.nix` 中的 `claudia`
2. **主机名**：修改 `modules/_core/network.nix` 中的 `networking.hostName`
3. **机器名**：将 `flake.nix` 中 `westwood` 改为 `nixosConfigurations.<你的名称>`
4. **主题**：修改 `home/theming.nix` 和 `modules/desktop/theming.nix`
5. **软件包**：在各模块文件中增减

### Flake 依赖

| 依赖 | 用途 |
|---|---|
| `nixpkgs/nixos-unstable` | 滚动更新的软件包集合 |
| `nix-community/home-manager` | 用户级软件包和配置文件管理 |
| `outfoxxed/quickshell` | 桌面组件框架（DMS/Noctalia 的基础） |
| `AvengeMedia/DankMaterialShell` | Material Design 风格桌面 Shell |
| `noctalia-dev/noctalia-shell` | Noctalia 桌面 Shell |
| `nix-community/nixvim` | Neovim 配置框架 |
| `nix-community/nixos-vscode-server` | VS Code 远程开发支持 |

### 更新

```bash
# 更新所有 flake 依赖到最新版本
nix flake update --flake /etc/nixos

# 重新构建
sudo nixos-rebuild switch --flake /etc/nixos#westwood
```
