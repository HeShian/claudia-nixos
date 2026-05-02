# =============================================================================
# 文件名:   modules/hardware/audio.nix
# 功能描述: 音频系统配置（PipeWire）
# 说明:     使用 PipeWire 作为音频服务器，替代传统的 PulseAudio，
#           提供低延迟音频和视频路由功能
# =============================================================================
{ ... }:

{
  # --- 1. PipeWire 音频服务 ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;           # ALSA 音频接口支持
    alsa.support32Bit = true;     # 32位 ALSA 支持（Steam 游戏需要）
    pulse.enable = true;          # PulseAudio 兼容层
    wireplumber.enable = true;    # WirePlumber 会话管理器
  };

  # --- 2. RTKit 实时权限 ---
  # 允许 PipeWire 获得实时调度优先级，降低音频延迟
  security.rtkit.enable = true;
}
