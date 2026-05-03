# =============================================================================
# 文件名:   modules/desktop/hyprland.nix
# 功能描述: Hyprland 窗口管理器系统级配置（与 end-4 dotfiles 配合使用）
# 说明:     提供 Hyprland 窗口管理器及 end-4 illogical-impulse Quickshell
#           风格所需的所有依赖包。
#           注意：end-4 的 dotfiles 配置文件需单独运行其 setup 脚本部署
#           （详见 README 中 post-setup 步骤），因为 Nix 的只读 symlink
#           会阻止 dotfiles 的运行时修改。
# 选择:     在 Ly 登录管理器中选择 "Hyprland" 进入
# =============================================================================
{ pkgs, lib, inputs, ... }:

let
  # tesseract 支持英语 OCR（end-4 屏幕翻译需要）
  tesseract-with-eng = pkgs.tesseract.override {
    enableLanguages = [ "eng" ];
  };

  # end-4 illogical-impulse 需要比 nixpkgs 中更新的 QuickShell（含 Polkit 等模块）
  # 使用 end-4 官方 pin 的 commit
  quickshell-end4-wrapped = pkgs.stdenv.mkDerivation {
    name = "quickshell-end4-wrapped";
    meta = with pkgs.lib; {
      description = "QuickShell bundled Qt deps for end-4 illogical-impulse";
      license = licenses.gpl3Only;
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = with pkgs; [
      makeWrapper
      qt6.wrapQtAppsHook  # Qt6 wrapper hook（自动设置 QML 导入路径）
    ];

    buildInputs = with pkgs; [
      inputs.quickshell-end4.packages.${pkgs.stdenv.hostPlatform.system}.default
      # Qt6 依赖（wrapQtAppsHook 会自动将 QML 路径加入 NIXPKGS_QT6_QML_IMPORT_PATH）
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qt5compat          # Qt5Compat.GraphicalEffects（ReloadPopup 需要）
      qt6.qtwayland
      qt6.qtmultimedia
      qt6.qtpositioning
      qt6.qtquicktimeline
      qt6.qtsensors
      qt6.qtsvg
      qt6.qtvirtualkeyboard
      kdePackages.kirigami
      kdePackages.kquickcharts
      kdePackages.syntax-highlighting  # org.kde.syntaxhighlighting（AiChat 需要）
      gsettings-desktop-schemas
    ];

    installPhase = ''
      mkdir -p $out/bin
      # 复制 QuickShell 二进制
      cp -r ${inputs.quickshell-end4.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/* $out/bin/
      chmod +x $out/bin/*
      # wrapQtAppsHook 运行后 qs 会被自动包装
    '';
  };
in
{
  # ===========================================================================
  # 1. 启用 Hyprland 窗口管理器
  # ===========================================================================
  programs.hyprland = {
    enable = true;
    # 使用 UWSM 以获得更好的 systemd 集成
    withUWSM = true;
    xwayland.enable = true;
  };

  # ===========================================================================
  # 2. Hyprland 生态工具
  # ===========================================================================
  programs.hyprlock.enable = true;    # GPU 加速屏幕锁定
  services.hypridle.enable = true;    # 空闲管理守护进程

  # ===========================================================================
  # 3. end-4 illogical-impulse 所需依赖包
  # ===========================================================================
  environment.systemPackages = with pkgs; [
    # --- Hyprland 实用工具 ---
    hyprpaper           # 壁纸设置工具
    hyprsunset          # 蓝光过滤
    hyprpicker          # 屏幕取色器
    hyprshot            # 截图工具

    # --- QuickShell（end-4 使用的 QtQuick widget 系统）---
    quickshell-end4-wrapped    # end-4 需要的 QuickShell（含 Polkit、IdleInhibitor 等）

    # --- QuickShell 所需的 Qt6 依赖 ---
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtquicktimeline
    qt6.qtsensors
    qt6.qtsvg
    qt6.qttools
    qt6.qttranslations
    qt6.qtvirtualkeyboard
    qt6.qtwayland
    kdePackages.qtshadertools

    # --- KDE 集成组件 ---
    libsForQt5.breeze-icons          # Breeze 图标（end-4 的 kde 配置需要）
    kdePackages.breeze-icons
    kdePackages.kirigami             # KDE Kirigami UI 框架
    kdePackages.kquickcharts         # KDE 图表组件

    # --- 音频与控制 ---
    cava                # 音频可视化
    pavucontrol         # 音量控制 GUI
    playerctl           # 媒体播放控制

    # --- 背光与硬件控制 ---
    brightnessctl       # 屏幕亮度控制
    ddcutil             # 显示器 DDC/CI 控制
    geoclue2            # 地理位置服务（end-4 亮度和位置功能）

    # --- 基础工具（end-4 脚本依赖）---
    bc                  # 数学计算
    cliphist            # Wayland 剪贴板管理器
    curl                # HTTP 请求
    wget                # 文件下载
    ripgrep             # 文本搜索
    jq                  # JSON 处理
    yq                  # YAML 处理
    xdg-user-dirs       # 用户目录管理
    rsync               # 文件同步

    # --- 截图与 OCR ---
    slurp               # 区域选择
    swappy              # 截图编辑
    tesseract-with-eng  # OCR 文字识别（屏幕翻译）
    wf-recorder         # 屏幕录制

    # --- 自动化工具 ---
    wtype               # Wayland 键盘输入模拟
    ydotool             # 通用 Linux 自动化

    # --- 颜色生成（end-4 Material You 主题需要）---
    matugen             # Material You 颜色生成工具

    # --- Shell（end-4 脚本和配置依赖 fish）---
    fish                # Fish shell（end-4 默认 shell，脚本广泛使用）

    # --- 应用启动器与 UI ---
    fuzzel              # 应用启动器
    wlogout             # 注销菜单

    # --- 媒体与工具 ---
    imagemagick         # 图片处理
    songrec             # Shazam 客户端（歌曲识别）
    translate-shell     # 命令行翻译
    libqalculate        # 计算器库（QuickShell 搜索栏数学计算）
    playerctl           # MPRIS 媒体控制
    libdbusmenu-gtk3    # 全局菜单支持

    # --- Python 与构建工具 ---
    uv                  # Python 包管理器
    cmake               # 构建工具（某些组件需要）

    # --- 文件管理 ---
    kdePackages.dolphin # KDE 文件管理器

    # --- GTK/libadwaita（end-4 主题需要）---
    adw-gtk3            # libadwaita GTK3 移植
    gtk4
    libadwaita

    # --- Wayland 实用工具 ---
    glib                # gsettings 命令行工具

    # --- 字体（end-4 Material Design 3 主题需要）---
    material-symbols    # Material Symbols 图标字体
    rubik               # Rubik 字体
    jetbrains-mono      # JetBrains Mono 等宽字体（已安装但显示列出）
  ];

  # ===========================================================================
  # 4. 额外 Qt6 环境变量
  # ===========================================================================
  environment.sessionVariables = {
    # QuickShell 需要正确的 Qt platform 插件
    QT_QPA_PLATFORM = "wayland;xcb";  # 优先 Wayland，回退 XCB

    # Hyprland 环境变量
    HYPRLAND_LOG_WLR = "1";           # 启动时记录 wlr 日志

    # 注意：Qt6 QML 模块路径由 quickshell-end4-wrapped 的 wrapQtAppsHook 自动处理
  };

  # ===========================================================================
  # 5. systemd 用户服务（end-4 需要 gnome-keyring）
  # ===========================================================================
  services.gnome.gnome-keyring.enable = true;

  # ===========================================================================
  # 6. 启用自动启动的 XDG 桌面门户（Hyprland）
  #    注意：portal.nix 中已配置 xdg-desktop-portal-hyprland
  # ===========================================================================
}

