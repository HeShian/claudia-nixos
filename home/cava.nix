{ config, lib, ... }:

{
  # ===========================================================================
  # Cava 音频可视化配置
  # ===========================================================================
  programs.cava = {
    enable = true;
    settings = {
      general = {
        bars = 64;
        framerate = 60;
      };
      input = {
        method = "pulse";
        source = "auto";
      };
      output = {
        method = "ncurses";
        style = "stereo";
      };
      color = {
        gradient = 1;
        gradient_count = 8;
        gradient_color_1 = "#c8e3ff";
        gradient_color_2 = "#d3dfff";
        gradient_color_3 = "#d0daff";
        gradient_color_4 = "#b7c5ff";
        gradient_color_5 = "#b0b8ff";
        gradient_color_6 = "#c7c8ff";
        gradient_color_7 = "#bfb8ff";
        gradient_color_8 = "#c9b5ed";
      };
      smoothing = {
        noise_reduction = 85;
        monstercat = 1;
        waves = 0;
        gravity = 120;
      };
      eq = {
        "1" = 0.8;
        "2" = 0.9;
        "3" = 1.0;
        "4" = 1.1;
        "5" = 1.2;
      };
    };
  };
}
