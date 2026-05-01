# =============================================================================
# 文件名:   modules/multimedia/obs.nix
# 功能描述: OBS Studio 录播软件配置
# 说明:     配置 OBS Studio 及其插件，启用 NVIDIA 硬件加速编码，
#           通过 nixpkgs.overlays 注入 OpenGL 库路径（推荐方式，替代已弃用的 packageOverrides）
# =============================================================================
{ config, pkgs, ... }:

{
  # --- 1. OBS 包覆盖：注入 OpenGL 库路径（使用 overlay 而非 packageOverrides） ---
  nixpkgs.overlays = [
    (final: prev: {
      obs-studio = prev.obs-studio.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/obs \
            --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:/run/opengl-driver-32/lib" \
            --set OBS_USE_EGL 1
        '';
      });
    })
  ];

  # --- 2. 安装 OBS 及插件 ---
  environment.systemPackages = with pkgs; [
    obs-studio                              # OBS Studio 核心
    obs-studio-plugins.obs-vaapi            # VA-API 硬件编码插件
    obs-studio-plugins.obs-pipewire-audio-capture  # PipeWire 音频捕获
  ];

  # --- 3. NVIDIA 硬件加速环境变量 ---
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";           # VA-API 使用 NVIDIA 驱动
    GBM_BACKEND = "nvidia-drm";             # GBM 后端
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";   # OpenGL 使用 NVIDIA
  };
}
