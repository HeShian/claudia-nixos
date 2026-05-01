{ config, lib, ... }:

{
  # ===========================================================================
  # Clipse 剪贴板管理器配置
  #
  # 注意：仅管理配置文件（config.json），运行时数据
  # （clipboard_history.json, clipse.log, tmp_files/）由 clipse 自行管理。
  # ===========================================================================
  xdg.configFile."clipse/config.json" = {
    force = true;
    text = ''
      {
          "allowDuplicates": false,
          "historyFile": "clipboard_history.json",
          "maxHistory": 100,
          "logFile": "clipse.log",
          "themeFile": "custom_theme.json",
          "tempDir": "tmp_files",
          "keyBindings": {
              "choose": "enter",
              "clearSelected": "S",
              "down": "down",
              "end": "end",
              "filter": "/",
              "home": "home",
              "more": "?",
              "nextPage": "right",
              "prevPage": "left",
              "preview": " ",
              "quit": "q",
              "remove": "x",
              "selectDown": "ctrl+down",
              "selectSingle": "s",
              "selectUp": "ctrl+up",
              "togglePin": "p",
              "togglePinned": "tab",
              "up": "up",
              "yankFilter": "ctrl+s"
          },
          "imageDisplay": {
              "type": "basic",
              "scaleX": 9,
              "scaleY": 9,
              "heightCut": 2
          }
      }
    '';
  };
}
