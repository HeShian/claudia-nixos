# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 架构概览

双层 NixOS Flake 配置，机器名 `westwood`，用户 `claudia`，通道 `nixos-unstable`。

| 层级 | 入口 | 职责 |
|---|---|---|
| **系统级** | `hosts/westwood/` → `modules/` | 硬件驱动、系统服务、全局环境变量 |
| **用户级** | `flake.nix` → `home-manager` → `home/claudia/` | 桌面应用、WM 配置、dotfiles、主题 |

`modules/` 下 11 个分类目录，每个目录的 `default.nix` 负责聚合该分类的所有子模块。**新增模块文件后必须在对应的 `default.nix` 的 `imports` 中添加引用。**

`home/claudia/` 下按功能分类的子目录，每个目录的 `default.nix` 负责聚合该分类的所有子模块。**新增模块文件后必须在对应的 `default.nix` / 分类 `default.nix` 的 `imports` 中添加引用。**

## 常用命令

```bash
# 构建并切换系统（唯一入口）
sudo nixos-rebuild switch --flake /etc/nixos#westwood

# 仅构建测试（不切换）
sudo nixos-rebuild build --flake /etc/nixos#westwood

# 更新 flake 锁定版本
nix flake update --flake /etc/nixos

# 清理 14 天前的旧版本
sudo nix-collect-garbage --delete-older-than 14d

# 回滚到上一代
sudo nixos-rebuild switch --rollback
```

**⚠️ 新建 `.nix` 文件后必须先 `git add` 再构建**，否则 Nix Flakes 报错 `not tracked by Git`。

## 桌面环境

一个 Wayland 窗口管理器，通过 **Ly** (TUI 登录管理器) 登录：

| WM | 默认 Shell | 系统配置 | 用户配置 |
|---|---|---|---|
| **Niri** (滚动平铺) | Noctalia Shell | `modules/desktop/niri.nix` | `home/claudia/wm/niri.nix` |

Shell 通过 Flake 外部依赖安装（`modules/desktop/shells/`），不在模块中直接引用包名。

## 关键设计模式

### `home.activation` 处理可写配置

某些桌面应用（Noctalia Shell、Qt 主题）需要在运行时写入配置文件。标准的 `xdg.configFile` 创建 Nix store 的只读符号链接，会导致写入静默失败。

**必须使用 `home.activation` 脚本**（而非 `xdg.configFile`）将默认配置以真实文件格式复制到目标位置，且仅在文件不存在或为符号链接时复制。参考 `home/claudia/input/migration.nix`。

### Niri + Fcitx5 启动时序

Fcitx5 依赖 Niri 的 `zwp_input_method_v2` 协议。过早启动会导致静默注册失败，终端无法输入中文。当前方案三要素：
1. `home/claudia/default.nix` 中用 `Hidden=true` 覆盖 XDG 自动启动
2. `home/claudia/wm/niri.nix` 中用 `spawn-at-startup "sh" "-c" "sleep 3 && fcitx5 -d"` 延迟启动
3. Niri `environment {}` 块中设置后备环境变量

### Dracula 主题保护

`home/claudia/theming/theming.nix` 中 `dconf.settings` 锁定 Dracula 值

## 文件规范

- 所有 `.nix` 文件使用中文文件头注释（`# 文件名:`、`# 功能描述:`、`# 说明:`）
- 节分隔符使用 `# --- 标题 ---` 风格
- 系统模块：`modules/<分类>/<名称>.nix`
- 用户配置：`home/claudia/<分类>/<名称>.nix`
- `nix.settings` 集中定义在 `modules/_core/nix-settings.nix`，不分散在多个模块

## 不会修改的文件

- `hosts/westwood/hardware-configuration.nix` — 由 `nixos-generate-config` 自动生成
- `flake.lock` — 由 `nix flake update` 管理
- `LICENSE` — 项目许可证
- `.claude/settings.json` — IDE 本地设置
