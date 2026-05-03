# AGENTS.md — Claudia's NixOS Configuration

面向 OpenCode 会话的速查指南。只记录 AI 容易遗漏或猜错的事项。

## 构建命令

```bash
# 重建系统（唯一入口）
sudo nixos-rebuild switch --flake /etc/nixos#westwood

# 更新 flake 依赖版本
nix flake update --flake /etc/nixos
```

**⚠️ Nix Flake 只识别 Git 追踪的文件。** 新建 `.nix` 文件后必须先 `git add`，否则构建报错 `not tracked by Git`。

## 架构

双层 NixOS 配置，机器名 `westwood`，用户 `claudia`，通道 `nixos-unstable`。

| 层级 | 入口 | 职责 |
|---|---|---|
| 系统级 | `configuration.nix` → `modules/` | 硬件驱动、服务、全局环境变量 |
| 用户级 | `flake.nix` → `home-manager` → `home/default.nix` | 桌面应用、WM 配置、dotfiles |

`modules/` 下每个目录的 `default.nix` 负责聚合该分类的所有子模块。**新增模块后必须在对应的 `default.nix` 中添加 `imports`。**

## 桌面环境

两个 Wayland 窗口管理器，通过 **Ly**（TUI 显示管理器）在登录时选择：

| WM | 默认 Shell | 配置文件 |
|---|---|---|
| Niri（滚动平铺） | Noctalia Shell | `home/niri.nix`（用户配置）+ `modules/desktop/niri.nix`（系统启用） |

Shell 通过 Flake 外部依赖安装（`modules/desktop/shells/`），**不在 `modules/` 中直接引用包名。**

## 关键设计模式

### `home.activation` 处理可写配置

某些应用（Noctalia Shell、Qt 主题工具）需要在运行时**写入**配置文件。标准的 `xdg.configFile` 创建的是指向 Nix store 的**只读符号链接**，会导致运行时写入静默失败。

**必须使用 `home.activation`** 脚本（而非 `xdg.configFile`）将默认配置以**真实文件**格式复制到目标位置，且仅在文件不存在或为符号链接时复制。参见 `home/migration.nix`。

### Fcitx5 启动时序（Niri 特有问题）

fcitx5 依赖 Niri 的 `zwp_input_method_v2` 协议为终端模拟器（kitty/alacritty）提供 `zwp_text_input_v3` 输入法服务。若 fcitx5 在 Niri 协议栈就绪前启动，Wayland 前端会静默注册失败。

**当前解决方案（三要素）：**
1. 在 `home/default.nix` 中用 `Hidden=true` 覆盖 `/etc/xdg/autostart/org.fcitx.Fcitx5.desktop`，阻止 systemd 过早启动 fcitx5
2. 在 `home/niri.nix` 中用 `spawn-at-startup "sh" "-c" "sleep 3 && fcitx5 -d"` 延迟启动
3. 在 Niri 的 `environment {}` 块中设置 `DISPLAY ":0"` 和 `XMODIFIERS "@im=fcitx"` 作为后备

**修改任一环节前需理解整个链条，否则会导致终端无法输入中文。**

### 蓝牙

只启用 BlueZ 守护进程（`hardware.bluetooth.enable = true`），配对由 Noctalia Shell 内置界面处理，**不安装** blueman 或 gnome-bluetooth。

### 输入法环境变量

系统级设置（`modules/locale/locale-zh.nix`）：
- `GTK_IM_MODULE=fcitx`、`QT_IM_MODULE=fcitx`、`SDL_IM_MODULE=fcitx` → 绕过 compositor，通过 DBus 直连 fcitx5
- `GLFW_IM_MODULE=ibus` → GLFW 应用使用 IBus 协议（fcitx5 兼容）

Niri 环境块中还额外设置了 `XMODIFIERS` 和 `DISPLAY`。

## 文件命名与风格

- 所有 `.nix` 文件使用中文文件头注释（`# 文件名: ...`、`# 功能描述: ...`）
- 模块放置：`modules/<分类>/<名称>.nix`，新增分类需建 `default.nix` 聚合导入
- 用户配置：`home/<名称>.nix`，新增文件需在 `home/default.nix` 的 `imports` 列表中添加
- 节分隔符统一使用 `# --- 标题 ---` 风格
- `flake.nix` 中特殊参数通过 `specialArgs = { inherit inputs; }` 传递给模块

## 不会查看的文件

- `hardware-configuration.nix` — 自动生成，请勿手动修改
- `flake.lock` — 锁定文件，由 `nix flake update` 管理
- `.claude/settings.json` — IDE 本地设置，无关配置逻辑
