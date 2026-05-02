{ config, lib, ... }:

{
  # ===========================================================================
  # Clipse 剪贴板管理器配置
  #
  # 注意：home-manager 的 services.clipse 会通过 systemd 自动管理 clipse
  # 生命周期，无需在 WM 配置中手动 spawn-at-startup。
  # ===========================================================================
  services.clipse = {
    enable = true;
    allowDuplicates = false;
    historySize = 100;
    imageDisplay = {
      type = "basic";
      scaleX = 9;
      scaleY = 9;
      heightCut = 2;
    };
    keyBindings = {
      choose = "enter";
      clearSelected = "S";
      down = "down";
      end = "end";
      filter = "/";
      home = "home";
      more = "?";
      nextPage = "right";
      prevPage = "left";
      preview = " ";
      quit = "q";
      remove = "x";
      selectDown = "ctrl+down";
      selectSingle = "s";
      selectUp = "ctrl+up";
      togglePin = "p";
      togglePinned = "tab";
      up = "up";
      yankFilter = "ctrl+s";
    };
  };
}
