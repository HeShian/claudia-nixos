# Claudia's NixOS Configuration 💠

> *Declarative. Reproducible. Modular.* — 声明式. 可复现. 模块化.

<div align="center">

[![NixOS](https://img.shields.io/badge/NixOS-26.05%20unstable-blue?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Home Manager](https://img.shields.io/badge/Home%20Manager-25.05-blueviolet?style=flat-square)](https://github.com/nix-community/home-manager)

</div>

---

[English](#english-overview) | [中文](#chinese-概述)

<a id="english-overview"></a>

---

<details open>
<summary><b>📑 Table of Contents / 目录</b></summary>

- [English](#english)
  - [Overview](#english-overview-1)
  - [Architecture](#architecture)
  - [Key Features](#key-features)
  - [Design Patterns](#design-patterns)
  - [Getting Started](#getting-started)
  - [Customization Guide](#customization-guide)
  - [Troubleshooting](#troubleshooting)
  - [Maintenance](#maintenance)
  - [Flake Inputs](#flake-inputs)
- [中文](#chinese)
  - [概述](#chinese-overview)
  - [架构](#architecture-1)
  - [核心特性](#core-features)
  - [设计模式](#design-patterns-1)
  - [快速开始](#quick-start)
  - [个性化指南](#customization-guide-1)
  - [故障排除](#troubleshooting-1)
  - [维护](#maintenance-1)
  - [Flake 依赖](#flake-dependencies)

</details>

---

## English

<a id="english"></a>

### Overview

This repository contains my personal NixOS system configuration, managed entirely through [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [Home Manager](https://github.com/nix-community/home-manager). Every package, service, theme, and dotfile is declaratively defined — no manual setup required.

**Machine**: `westwood` (x86_64-linux, NixOS 26.05 unstable)

**Architecture at a glance:**

| Layer | Entry | Responsibility |
|---|---|---|
| **System** | `configuration.nix` → `modules/` | Hardware drivers, system services, global environment |
| **User** | `flake.nix` → `home-manager` → `home/` | Desktop apps, WM config, dotfiles, theming |

**Key design philosophy:**
- **Single source of truth** — Every config is managed in one place, no scattered dotfiles
- **Minimal top-level config** — `configuration.nix` only does imports; logic lives in `modules/`
- **Per-category modules** — Each domain (desktop, hardware, gaming, etc.) lives in its own directory

### Architecture

```
/etc/nixos/
├── flake.nix                 # Entry point — inputs, system definition
├── flake.lock                # Locked dependency versions (reproducible!)
├── hosts/                    # Host-specific configs (machine name = westwood)
│   └── westwood/
│       ├── default.nix       # Top-level config (minimal — delegates to modules)
│       └── hardware-configuration.nix # Auto-generated — disk/CPU/hardware info
├── modules/                  # System-level modules (11 categories)
│   ├── _core/               # Boot, networking, Nix settings, security
│   │   ├── boot.nix         # systemd-boot, EFI, NTFS support
│   │   ├── network.nix      # Hostname, NetworkManager
│   │   ├── nix-settings.nix # Mirrors (Tsinghua/USTC), GC, env vars
│   │   ├── security.nix     # User accounts, sudo, SSH, nix-ld
│   │   ├── system-packages.nix # System-wide packages, VS Code Server
│   │   └── swap.nix         # 8GB swap file
│   ├── desktop/             # Niri + Hyprland + Ly DM + theming + shells
│   │   ├── display-manager.nix  # Ly (TUI login manager)
│   │   ├── portal.nix           # XDG Desktop Portal (screen sharing)
│   │   ├── niri.nix             # Niri WM enable + system config
│   │   ├── hyprland.nix         # Hyprland WM + end-4 illogical-impulse
│   │   ├── theming.nix          # System-level Dracula theming
│   │   └── shells/              # Noctalia (Niri) shell
│   ├── hardware/            # NVIDIA GPU, PipeWire audio, Bluetooth, printing
│   ├── locale/              # Chinese locale, Fcitx5 IME, fonts
│   ├── develop/             # Languages, build tools, AI tools, editors
│   │   └── editors/         # NixVim (Neovim) + VS Code
│   ├── gaming/              # Steam, Lutris, Heroic, Wine/Bottles
│   ├── virtualization/      # Docker, KVM/QEMU/libvirtd, Incus
│   ├── network/             # VPN/proxy (v2rayA + Clash), SSH client
│   ├── multimedia/          # OBS, Flatpak, clipboard, screenshots
│   ├── communication/       # Discord, Telegram
│   └── applications/        # Browsers, terminals, productivity tools
└── home/                    # User-level Home Manager configs
    └── claudia/             # User "claudia"
        ├── default.nix      # Entry — packages, env vars, MIME, autostart
        ├── assets/          # Static files (logos, images)
        ├── shell/           # ZSH, Bash, Readline
        │   ├── default.nix
        │   ├── bash.nix
        │   ├── zsh.nix
        │   └── readline.nix
        ├── programs/        # Git, btop, fastfetch, cava, clipse, etc.
        │   └── default.nix
        ├── editors/         # Vim, NixVim (Neovim)
        │   └── default.nix
        ├── terminal/        # Kitty, Alacritty
        │   └── default.nix
        ├── wm/              # Niri + Hyprland user config
        │   ├── default.nix
        │   ├── niri.nix     # Niri keybinds, layout, Noctalia colors
        │   └── hyprland.nix # Hyprland env vars, custom overrides
        ├── theming/         # GTK/Kvantum (Dracula dark)
        │   └── default.nix
        └── input/           # Rime, Fcitx5, Noctalia theme migration
            ├── default.nix
            ├── rime.nix
            └── migration.nix
```

**Module loading pattern:** Each directory in `modules/` has a `default.nix` that aggregates its submodules via `imports = [ ... ]`. When adding a new module file, you must register it in the corresponding `default.nix`.

### Key Features

| Area | What's Configured |
|---|---|
| **Desktop** | **Niri** (scrollable-tiling) + **Hyprland** (dynamic tiling) — switch at login via Ly DM |
| **Shell** | **Noctalia Shell** (Niri) or **end-4 illogical-impulse** with QuickShell (Hyprland) |
| **GPU** | NVIDIA proprietary driver with modesetting + VA-API |
| **Audio** | PipeWire with WirePlumber, Bluetooth codecs (LDAC/AAC/aptX) |
| **Bluetooth** | BlueZ, pairing handled by Noctalia Shell built-in UI |
| **Input** | Fcitx5 (Pinyin + Rime) with Nord theme, Wayland text-input-v3 |
| **Fonts** | Cascadia Code, JetBrains Mono Nerd Font, Noto CJK |
| **Theme** | Dracula dark — GTK 2/3/4 + Kvantum (Qt5/Qt6) |
| **Terminal** | Kitty (primary) + Alacritty |
| **Shell** | ZSH + Bash, both with Starship prompt |
| **Editor** | Neovim (NixVim), clipboard integrated via wl-clipboard |
| **File Manager** | Thunar (lightweight, fast) |
| **Launcher** | Fuzzel (Wayland-native, themed) |
| **Screenshots** | grim + slurp + satty — region, window, full-screen, instant edit |
| **Clipboard** | Clipse (Wayland-native clipboard manager) |
| **VM** | Docker + KVM/QEMU (libvirtd) + Incus |
| **Gaming** | Steam + Lutris + Heroic + Wine/Bottles |
| **VPN** | v2rayA + Clash Verge Rev |
| **AI Tools** | OpenCode AI coding assistant + Claude Code + CC-Switch |
| **Nix Cache** | Tsinghua + USTC mirrors, weekly auto GC |

### Design Patterns

#### `home.activation` for writable configs

Some desktop tools (Noctalia, Qt theming) need to *write* to their config files at runtime. Standard `xdg.configFile` creates read-only symlinks to the Nix store, which silently break runtime writes. The solution used here: `home.activation` scripts that copy defaults from the Nix store as **real files** — but only when the target doesn't already exist. This guarantees a working default while allowing the application to update its own config later.

See `home/migration.nix` for the implementation.


#### Niri + Fcitx5 startup timing

Fcitx5 relies on Niri's `zwp_input_method_v2` Wayland protocol to serve terminal emulators (kitty/alacritty) via `zwp_text_input_v3`. Starting fcitx5 too early (before Niri's protocol stack initializes) causes silent registration failure. The solution:

1. **Disable** systemd XDG autostart (`Hidden=true` in `home/default.nix`)
2. **Delay** in Niri: `spawn-at-startup "sh" "-c" "sleep 3 && fcitx5 -d"` (in `home/niri.nix`)
3. **Fallback** environment variables: `DISPLAY=:0` and `XMODIFIERS=@im=fcitx` for XWayland fallback

> ⚠️ **Important**: Any change to this chain can silently break Chinese input in terminals. See `AGENTS.md` for the full dependency chain.

#### end-4 illogical-impulse dotfiles (Hyprland)

The end-4 dotfiles project (14K ⭐ on GitHub) is deployed **outside Nix** because its configuration files need runtime write access (QuickShell color generation, wallpaper-based Material You theming). Nix's read-only symlinks would break these features.

Hybrid approach:
1. **Nix handles all system packages** — Hyprland, QuickShell (pinned commit `7511545e`), Qt6/KDE QML modules, and all end-4 dependencies
2. **end-4's `setup install-files` handles dotfiles** — regular files in `~/.config/hypr/`, `~/.config/quickshell/ii/`, etc.
3. **`custom/` directories preserve user overrides** — `~/.config/hypr/custom/` and `~/.config/quickshell/ii/Quickshell/Services/Polkit/` are update-safe

See `modules/desktop/hyprland.nix` and `home/claudia/wm/hyprland.nix` for implementation details.

#### Dracula theme protection

`dconf.settings` in `home/theming.nix` locks `color-scheme`, `gtk-theme`, and `icon-theme` to Dracula values.

Additionally, `fcitx5`'s `UseAccentColor` is set to `False` so the input method theme (Nord-Dark) stays consistent regardless of system accent color changes.

### Getting Started

> ⚠️ **WARNING**: This configuration is tailored to my specific hardware. Review and adjust before deploying!

#### Prerequisites

- NixOS 26.05+ (or nixos-unstable) installed from the [official ISO](https://nixos.org/download)
- Basic familiarity with Nix flakes and NixOS modules

#### Step 1: Clone the repository

```bash
sudo mkdir -p /etc/nixos
sudo chown $USER /etc/nixos
git clone https://github.com/HeShian/claudia-nixos.git /etc/nixos
```

#### Step 2: Generate hardware configuration

```bash
# Generate your own hardware config (REQUIRED)
# This writes directly to /etc/nixos/hardware-configuration.nix
nixos-generate-config --root /
```

**Things you MUST adjust:**
- Disk partitions and filesystem UUIDs in `hardware-configuration.nix`
- GPU driver: Comment out `modules/hardware/nvidia.nix` if you have AMD/Intel
- CPU microcode: Change `kvm-intel` → `kvm-amd` (or remove) if using AMD

#### Step 3: Add GitHub access token (recommended)

```bash
sudo mkdir -p /etc/nix
echo "access-tokens = github.com=YOUR_TOKEN" | sudo tee /etc/nix/github-access-tokens
sudo chmod 600 /etc/nix/github-access-tokens
```

This increases the GitHub API rate limit from 60 to 5000 requests/hour during Nix builds.

> ⏱ **First build** may take 1-3 hours depending on your network and CPU. Subsequent builds are much faster thanks to the Nix cache.

#### Step 4: Build and switch

```bash
sudo nixos-rebuild switch --flake /etc/nixos#westwood
sudo reboot
```

After reboot, log in as user `claudia` via **Ly** (TUI display manager).

> 🔑 The default password is empty (no password set for first login). Run `passwd` immediately after first login.

#### Step 5: Post-install setup

```bash
# Set password (default is empty)
passwd

# Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub  # add to GitHub

# Deploy Rime input method schemas (first time only)
# Press Super+Space to switch to Rime, then press Ctrl+` (backtick)
# In the menu, select "部署" (deploy) to compile 霧淞拼音 + 小鹤双拼
```

#### Step 6 (optional): Install end-4 illogical-impulse (Hyprland)

The Nix config installs all dependencies. To deploy dotfiles:

```bash
# Clone end-4 dotfiles
git clone https://github.com/end-4/dots-hyprland.git ~/dots-hyprland
cd ~/dots-hyprland

# Deploy dotfiles (skip system packages — Nix handles them)
bash setup install-files --firstrun --force

# Install Python venv for color generation
nix-shell sdata/uv/shell.nix --run 'uv venv "$HOME/.local/state/quickshell/.venv" && \
  source "$HOME/.local/state/quickshell/.venv/bin/activate" && \
  uv pip install -r sdata/uv/requirements.txt'
```

Select **Hyprland** (not UWSM) at the Ly login screen.
Press `Ctrl+Super+T` to choose a wallpaper and generate colors.

#### WM Switching

| At Ly login, select | Result |
|---|---|
| **Niri** | Niri WM + Noctalia Shell |
| **Hyprland** | Hyprland WM + end-4 illogical-impulse QuickShell |

#### Verification

| Component | Niri | Hyprland |
|---|---|---|
| Chinese input | `Ctrl+Space` to toggle. `Mod+F1` to restart fcitx5 | `Ctrl+Space` to toggle |
| Neovim IDE | `nvim` to start. `,e` file tree, `,ff` search | Same |
| Screenshot | `Print` region, `Ctrl+Print` full-screen | `Print` region (hyprshot) |
| Launcher | `Mod+Z` (Fuzzel) | `Super+Space` (QuickShell) or `Super+Z` (Fuzzel) |
| Bluetooth | Noctalia panel (`Mod+Comma`) | end-4 QuickShell settings |
| Wallpaper/theme | Noctalia auto-generates from wallpaper | `Ctrl+Super+T` to pick wallpaper |

### Customization Guide

#### Changing the user

1. Replace `claudia` in `modules/_core/security.nix` (user account config)
2. Replace `claudia` in `flake.nix` (Home Manager user reference)
3. Update `home/default.nix` if needed

#### Changing the hostname

Edit `networking.hostName` in `modules/_core/network.nix`.

#### Changing the machine name

Rename `westwood` in `flake.nix`:
- `nixosConfigurations.westwood = ...` → `nixosConfigurations.<your-name> = ...`
- Update references in `nixos-rebuild` commands

#### Changing the theme

1. System-level: Edit `modules/desktop/theming.nix`
2. User-level: Edit `home/theming.nix`
3. Replace `dracula-theme` and `dracula-icon-theme` packages with your preferred theme
4. Update `dconf.settings` and `GTK_THEME` environment variable accordingly

#### Adding/removing packages

- **System-wide** packages: Add to the appropriate `modules/` submodule (e.g., `modules/develop/languages.nix` for programming languages)
- **User-only** packages: Add to `home.packages` in `home/default.nix`
- Always follow the existing category structure — create a new module file if adding a new category

#### Modifying keybindings

- **Niri** keybinds: Edit `home/niri.nix` (Niri KDL config)

### Troubleshooting

#### Nix Flake error: "file is not tracked by Git"

Nix Flakes require all files to be tracked by Git. If you created a new `.nix` file:
```bash
git add <new-file>.nix
```

#### Fcitx5 not working in terminals (Niri)

1. Check if fcitx5 is running: `pgrep -a fcitx5`
2. If not: `pkill fcitx5; sleep 0.5; fcitx5 -d`
3. Or use the restart shortcut: `Mod+F1` (Niri) or restart the compositor
4. Ensure `GTK_IM_MODULE=fcitx` and `QT_IM_MODULE=fcitx` are set

#### Screen sharing not working

- For Niri: `xdg-desktop-portal-gnome` is the backend; check its status: `systemctl --user status xdg-desktop-portal-gnome`


#### NVIDIA driver issues

```bash
# Verify driver is loaded
nvidia-smi
# Verify VA-API
vainfo
# Check kernel module
lsmod | grep nvidia
```

#### Bluetooth not working

- Bluetooth pairing is handled via Noctalia Shell UI (blueman is NOT installed)
- Ensure `hardware.bluetooth.enable = true` and `hardware.bluetooth.powerOnBoot = true`
- Check service: `systemctl status bluetooth`

#### GPU acceleration issues (OBS, video playback)

The system sets these environment variables for NVIDIA VA-API:
```
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
```
If you switch to AMD/Intel GPU, remove or override these in `modules/multimedia/obs.nix`.

### Maintenance

```bash
# Update all flake inputs to latest versions
nix flake update --flake /etc/nixos

# Rebuild and switch
sudo nixos-rebuild switch --flake /etc/nixos#westwood

# Test build without switching
sudo nixos-rebuild build --flake /etc/nixos#westwood

# Clean up old generations
sudo nix-collect-garbage --delete-older-than 14d

# Show current generation
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### Flake Inputs

| Input | Purpose |
|---|---|
| `nixpkgs/nixos-unstable` | Rolling-release package collection |
| `nix-community/home-manager` | User-level package and dotfile management |
| `noctalia-dev/noctalia-shell` | Noctalia desktop shell (Niri) |
| `nix-community/nixvim` | Neovim configuration framework |
| `nix-community/nixos-vscode-server` | VS Code remote development support |
| `quickshell-mirror/quickshell` (pinned `7511545e`) | QuickShell for end-4 illogical-impulse (Hyprland) |

---

## 中文

<a id="chinese"></a>

<details>
<summary><b>📑 目录</b></summary>

- [概述](#chinese-overview)
- [架构](#architecture-1)
- [核心特性](#core-features)
- [设计模式](#design-patterns-1)
- [快速开始](#quick-start)
- [个性化指南](#customization-guide-1)
- [故障排除](#troubleshooting-1)
- [维护](#maintenance-1)
- [Flake 依赖](#flake-dependencies)

</details>

<a id="chinese-overview"></a>

### 概述

此仓库包含我的个人 NixOS 系统配置，完全通过 [Nix Flakes](https://nixos.wiki/wiki/Flakes) 和 [Home Manager](https://github.com/nix-community/home-manager) 管理。所有软件包、服务、主题和配置文件均以声明式方式定义——无需任何手动配置。

**机器名**：`westwood`（x86_64-linux，NixOS 26.05 unstable）

**架构概览：**

| 层级 | 入口 | 职责 |
|---|---|---|
| **系统级** | `configuration.nix` → `modules/` | 硬件驱动、系统服务、全局环境变量 |
| **用户级** | `flake.nix` → `home-manager` → `home/` | 桌面应用、WM 配置、dotfiles、主题 |

**核心设计理念：**
- **单一事实来源** — 所有配置集中管理，不再有零散的 dotfiles
- **顶层最小化** — `configuration.nix` 只做导入，逻辑在 `modules/` 中
- **按分类模块化** — 每个领域（桌面、硬件、游戏等）有自己的目录

<a id="architecture-1"></a>

### 架构

```
/etc/nixos/
├── flake.nix                 # 入口 — 外部依赖、系统定义
├── flake.lock                # 锁定版本（保证可复现！）
├── configuration.nix         # 顶层系统配置（刻意保持精简）
├── hardware-configuration.nix # 自动生成 — 磁盘/CPU/硬件信息
├── modules/                  # 系统级模块（11 个分类）
│   ├── _core/               # 引导、网络、Nix 设置、安全
│   │   ├── boot.nix         # systemd-boot、EFI、NTFS 支持
│   │   ├── network.nix      # 主机名、NetworkManager
│   │   ├── nix-settings.nix # 镜像源（清华/中科大）、GC、环境变量
│   │   ├── security.nix     # 用户账户、sudo、SSH、nix-ld
│   │   ├── system-packages.nix # 系统级包、VS Code Server
│   │   └── swap.nix         # 8GB 交换文件
│   ├── desktop/             # Niri + Ly DM + 主题 + Shell
│   │   ├── display-manager.nix  # Ly（TUI 登录管理器）
│   │   ├── portal.nix           # XDG 桌面门户（屏幕共享）
│   │   ├── niri.nix             # Niri WM 启用 + 系统配置
│   │   ├── theming.nix          # 系统级 Dracula 主题
│   │   └── shells/              # Noctalia（Niri 用）
│   ├── hardware/            # NVIDIA 驱动、PipeWire 音频、蓝牙、打印
│   ├── locale/              # 中文环境、Fcitx5 输入法、字体
│   ├── develop/             # 编程语言、构建工具、AI 工具、编辑器
│   │   └── editors/         # NixVim (Neovim) + VS Code
│   ├── gaming/              # Steam、Lutris、Heroic、Wine/Bottles
│   ├── virtualization/      # Docker、KVM/QEMU/libvirtd、Incus
│   ├── network/             # VPN/代理(v2rayA + Clash)、SSH 客户端
│   ├── multimedia/          # OBS、Flatpak、剪贴板、截图
│   ├── communication/       # Discord、Telegram
│   └── applications/        # 浏览器、终端、生产力工具
└── home/                    # 用户级 Home Manager 配置
    ├── default.nix          # 入口 — 软件包、环境变量、MIME、启动覆盖
    ├── bash.nix / zsh.nix   # Shell 配置(Starship 提示符)
    ├── niri.nix                       # 窗口管理器键位、布局、主题
    ├── alacritty.nix / kitty.nix      # 终端模拟器
    ├── git.nix / vim.nix              # 开发工具
    ├── cava.nix / clipse.nix / satty.nix  # 音频可视化、剪贴板、截图
    ├── btop.nix / fastfetch.nix           # 系统监控
    ├── opencode.nix                       # AI 编码助手
    ├── readline.nix                       # Readline 配置
    ├── theming.nix                     # GTK/Kvantum(Dracula 暗色主题)
    └── migration.nix                  # 遗留配置 + Noctalia 主题生成器
```

**模块加载规则：** `modules/` 下每个目录的 `default.nix` 负责聚合该分类的所有子模块。**新增模块文件后必须在对应的 `default.nix` 的 `imports` 列表中添加引用。**

<a id="core-features"></a>

### 核心特性

| 领域 | 配置内容 |
|---|---|
| **桌面** | Niri — Wayland 窗口管理器，通过 Ly DM 登录 |
| **Shell** | Noctalia Shell（Niri） |
| **显卡** | NVIDIA 闭源驱动 + modesetting + VA-API 硬件解码 |
| **音频** | PipeWire + WirePlumber，蓝牙编解码（LDAC/AAC/aptX） |
| **蓝牙** | BlueZ，Noctalia Shell 内置配对界面管理 |
| **输入法** | Fcitx5（拼音 + Rime 中古音），Nord 主题，Wayland text-input-v3 |
| **字体** | Cascadia Code、JetBrains Mono Nerd Font、Noto CJK |
| **主题** | Dracula 暗色 — GTK 2/3/4 + Kvantum（Qt5/Qt6） |
| **终端** | Kitty（主力）+ Alacritty |
| **Shell** | ZSH + Bash，统一使用 Starship 提示符 |
| **编辑器** | Neovim (NixVim)，系统剪贴板集成(wl-clipboard) |
| **文件管理** | Thunar（轻量快速） |
| **启动器** | Fuzzel（Wayland 原生，主题适配） |
| **截图** | grim + slurp + satty — 区域/窗口/全屏，即时编辑 |
| **剪贴板** | Clipse（Wayland 原生剪贴板管理器） |
| **虚拟化** | Docker + KVM/QEMU (libvirtd) + Incus |
| **游戏** | Steam + Lutris + Heroic + Wine/Bottles |
| **代理** | v2rayA + Clash Verge Rev |
| **AI 工具** | OpenCode AI 编码助手 + Claude Code + CC-Switch |
| **Nix 源** | 清华大学 + 中科大镜像，每周自动垃圾回收 |

<a id="design-patterns-1"></a>

### 设计模式

#### `home.activation` 处理可写配置

某些桌面工具（Noctalia、Qt 主题）需要在运行时*写入*其配置文件。标准的 `xdg.configFile` 会创建指向 Nix store 的只读符号链接，导致运行时写入静默失败。本仓库的解决方案：使用 `home.activation` 脚本将默认配置从 Nix store 复制为**真实文件**——但仅在目标文件不存在时执行。这既保证了开箱即用的默认配置，又允许应用程序后续更新自己的配置。

实现详见 `home/migration.nix`。


#### Niri + Fcitx5 启动时序

Fcitx5 依赖 Niri 的 `zwp_input_method_v2` Wayland 协议为终端模拟器（kitty/alacritty）提供 `zwp_text_input_v3` 输入法服务。过早启动 fcitx5（在 Niri 协议栈初始化之前）会导致静默注册失败。解决方案：

1. **禁用** systemd XDG 自动启动（`home/default.nix` 中的 `Hidden=true`）
2. **延迟启动**：`spawn-at-startup "sh" "-c" "sleep 3 && fcitx5 -d"`（`home/niri.nix`）
3. **后备环境变量**：设置 `DISPLAY=:0` 和 `XMODIFIERS=@im=fcitx` 作为 XWayland 后备

> ⚠️ **重要**：修改任一环节前需理解整个链条，否则会导致终端无法输入中文。详见 `AGENTS.md`。

#### Dracula 主题保护

`home/theming.nix` 中的 `dconf.settings` 锁定 `color-scheme`、`gtk-theme`、`icon-theme` 为 Dracula 值。

此外，fcitx5 的 `UseAccentColor` 设为 `False`，确保输入法 Nord-Dark 主题不受系统 accent 颜色影响。

<a id="quick-start"></a>

### 快速开始

> ⚠️ **警告**：此配置针对我的特定硬件定制。部署前请仔细审查和修改！

#### 前置条件

- 已从[官方 ISO](https://nixos.org/download) 安装 NixOS 26.05+（或 nixos-unstable）
- 熟悉 Nix flakes 和 NixOS 模块的基本概念

#### 第一步：克隆仓库

```bash
sudo mkdir -p /etc/nixos
sudo chown $USER /etc/nixos
git clone https://github.com/HeShian/claudia-nixos.git /etc/nixos
```

#### 第二步：生成硬件配置

```bash
# 生成你自己的硬件配置（必需）
# 该命令直接输出到 /etc/nixos/hardware-configuration.nix
nixos-generate-config --root /
```

**必须调整的内容：**
- `hardware-configuration.nix` 中的磁盘分区和文件系统 UUID
- GPU 驱动：AMD/Intel 用户需注释掉 `modules/hardware/nvidia.nix` 中的导入
- CPU 微码：AMD 用户将 `kvm-intel` 改为 `kvm-amd`

#### 第三步：添加 GitHub 访问令牌（推荐）

```bash
sudo mkdir -p /etc/nix
echo "access-tokens = github.com=你的令牌" | sudo tee /etc/nix/github-access-tokens
sudo chmod 600 /etc/nix/github-access-tokens
```

可将 GitHub API 频率限制从 60 次/小时提升到 5000 次/小时。

#### 第四步：构建并切换

```bash
sudo nixos-rebuild switch --flake /etc/nixos#westwood
sudo reboot
```

重启后通过 **Ly**（TUI 登录管理器）以用户 `claudia` 登录，Niri 自动启动。

#### 第五步：首次设置

```bash
# 设置密码（默认无密码）
passwd

# 配置 git
git config --global user.name "你的名字"
git config --global user.email "your@email.com"
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub  # 添加到 GitHub

# 部署 Rime 输入法方案（首次使用）
# Super+Space 切换到 Rime，按 Ctrl+` 打开方案菜单
# 选择"部署"以编译霧淞拼音 + 小鹤双拼
```

#### 验证

| 组件 | 测试方法 |
|---|---|
| 中文输入 | `Ctrl+Space` 切换。Rime 下 `Ctrl+\`` 切换方案（霧淞拼音/小鹤双拼） |
| Neovim IDE | `nvim` 启动。`,e` 文件树，`,ff` 搜索文件，`,y` 复制到剪贴板 |
| 蓝牙 | 打开 Noctalia 控制面板 (`Mod+Comma`) → 蓝牙 |
| 截图 | `Print` 区域截图，`Ctrl+Print` 全屏截图 |
| 启动器 | `Mod+Z`（Fuzzel）或 `Mod+D`（Niri） |

<a id="customization-guide-1"></a>

### 个性化指南

#### 修改用户名

1. 替换 `modules/_core/security.nix` 中的 `claudia`
2. 替换 `flake.nix` 中的 `claudia`（`home-manager.users.claudia`）

#### 修改主机名

编辑 `modules/_core/network.nix` 中的 `networking.hostName`。

#### 修改机器名

将 `flake.nix` 中的 `westwood` 改为 `nixosConfigurations.<你的名称>`，同时更新 `nixos-rebuild` 命令中的 flake 引用。

#### 修改主题

1. 系统级：编辑 `modules/desktop/theming.nix`
2. 用户级：编辑 `home/theming.nix`
3. 替换 `dracula-theme` 和 `dracula-icon-theme` 为你偏好的主题包
4. 同步更新 `dconf.settings` 和 `GTK_THEME` 环境变量

#### 增减软件包

- **系统级**：添加到对应分类的 `modules/` 子模块中（如编程语言添加到 `modules/develop/languages.nix`）
- **用户级**：添加到 `home/default.nix` 的 `home.packages` 中
- 始终遵循现有分类结构，如需新增分类请创建新的模块目录

#### 修改快捷键

- **Niri**：编辑 `home/niri.nix` 中的 KDL 配置

<a id="troubleshooting-1"></a>

### 故障排除

#### Nix Flake 错误："file is not tracked by Git"

Nix Flakes 要求所有文件已被 Git 追踪。新建 `.nix` 文件后需执行：
```bash
git add <新文件>.nix
```

#### Fcitx5 在终端中无法使用（Niri 环境）

1. 检查是否运行：`pgrep -a fcitx5`
2. 如未运行：`pkill fcitx5; sleep 0.5; fcitx5 -d`
3. 或使用重启快捷键：`Mod+F1`（Niri 环境），或者重启 compositor
4. 确保 `GTK_IM_MODULE=fcitx` 和 `QT_IM_MODULE=fcitx` 已设置

#### 屏幕共享不工作

- Niri：使用 `xdg-desktop-portal-gnome` 作为后端，检查状态：`systemctl --user status xdg-desktop-portal-gnome`


#### NVIDIA 驱动问题

```bash
# 确认驱动已加载
nvidia-smi
# 确认 VA-API
vainfo
# 检查内核模块
lsmod | grep nvidia
```

#### 蓝牙不工作

- 蓝牙配对通过 Noctalia Shell 界面处理（未安装 blueman）
- 确保 `hardware.bluetooth.enable = true` 和 `hardware.bluetooth.powerOnBoot = true`
- 检查服务：`systemctl status bluetooth`

#### GPU 加速问题（OBS、视频播放）

系统为 NVIDIA VA-API 设置了以下环境变量：
```
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
```
如果使用 AMD/Intel GPU，需要在 `modules/multimedia/obs.nix` 中移除或覆盖这些环境变量。

<a id="maintenance-1"></a>

### 维护

```bash
# 更新所有 flake 依赖到最新版本
nix flake update --flake /etc/nixos

# 重构并切换
sudo nixos-rebuild switch --flake /etc/nixos#westwood

# 仅构建（不切换，用于测试）
sudo nixos-rebuild build --flake /etc/nixos#westwood

# 清理旧版本
sudo nix-collect-garbage --delete-older-than 14d

# 查看当前代数
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# 回滚到上一代
sudo nixos-rebuild switch --rollback
```

<a id="flake-dependencies"></a>

### Flake 依赖

| 依赖 | 用途 |
|---|---|
| `nixpkgs/nixos-unstable` | 滚动更新的软件包集合 |
| `nix-community/home-manager` | 用户级软件包和配置文件管理 |
| `noctalia-dev/noctalia-shell` | Noctalia 桌面 Shell（Niri 用） |
| `nix-community/nixvim` | Neovim 配置框架 |
| `nix-community/nixos-vscode-server` | VS Code 远程开发支持 |
| `quickshell-mirror/quickshell` (定 commit `7511545e`) | end-4 illogical-impulse 所需的 QuickShell（Hyprland 用） |

---

## License / 许可证

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
