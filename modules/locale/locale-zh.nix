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

      # Rime 输入法引擎（中古音/五笔等）
      fcitx5-rime
      rime-data

      # 配置工具
      qt6Packages.fcitx5-configtool       # GUI 配置工具
      fcitx5-gtk                          # GTK 应用支持

      # 外观
      fcitx5-nord                         # Nord 主题

      # Lua 扩展支持
      fcitx5-lua
    ];

    # Wayland 前端支持
    fcitx5.waylandFrontend = true;
  };
}
