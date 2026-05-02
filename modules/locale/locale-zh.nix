# =============================================================================
# 文件名:   modules/locale/locale-zh.nix
# 功能描述: 中文区域设置与输入法配置
# 说明:     配置系统中文语言环境、Fcitx5 输入法框架及中文相关设置
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # --- 1. 系统语言环境 ---
  i18n = {
    # 默认语言：简体中文 UTF-8
    defaultLocale = "zh_CN.UTF-8";

    # 所有区域设置均使用中文
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };

    # 支持的语言（中文为主，英文为辅）
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # --- 2. 系统时区（中国标准时间 UTC+8） ---
  # 修复 Noctalia 等桌面组件显示错误时间的问题
  time.timeZone = "Asia/Shanghai";

  # --- 3. 输入法配置（Fcitx5）---
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      # 中文输入法引擎
      qt6Packages.fcitx5-chinese-addons   # 拼音输入法
      fcitx5-pinyin-zhwiki                # 维基百科词库

      # Rime 输入法引擎（霧淞拼音 + 小鹤双拼）
      fcitx5-rime
      rime-ice                           # 霧淞拼音（含全拼和双拼方案）

      # 配置工具
      qt6Packages.fcitx5-configtool       # GUI 配置工具
      fcitx5-gtk                          # GTK 应用 IM 支持
      qt6Packages.fcitx5-qt               # Qt6 应用 IM 支持（微信/QQ 等需要）
      libsForQt5.fcitx5-qt                # Qt5 应用 IM 支持

      # Lua 扩展支持
      fcitx5-lua
    ];

    # Wayland 前端支持
    # 在 Hyprland 下有 IME 状态残留 bug，关闭后改用 GTK/QT IM 模块
    fcitx5.waylandFrontend = false;

    # 输入法配置（Profile — 默认使用 Rime 霧淞拼音）
    fcitx5.settings.inputMethod = {
      "Groups/0" = {
        Name = "默认";
        DefaultLayout = "us";
        DefaultIM = "rime";
      };
      "Groups/0/Items/0" = { Name = "keyboard-us"; Layout = ""; };
      "Groups/0/Items/1" = { Name = "rime"; Layout = ""; };
    };
  };

  # --- 4. 全局输入法环境变量 ---
  # GTK_IM_MODULE 不设置→ GTK3/4 应用使用 Wayland text-input-v3 (统一 Classic UI 主题)
  # QT_IM_MODULE=fcitx → Qt5 应用仍需 (不支持 text-input-v3)
  # GLFW_IM_MODULE=ibus → GLFW 应用兼容
  environment.variables = {
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
}
