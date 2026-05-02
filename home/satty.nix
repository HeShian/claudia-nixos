{ config, lib, ... }:

{
  # ===========================================================================
  # Satty 截图标注工具配置
  # ===========================================================================
  programs.satty = {
    enable = true;
    settings = {
      general = {
        "copy-command" = "wl-copy";
        "focus-toggles-toolbars" = true;
        "actions-on-right-click" = [ "save-to-clipboard" ];
      };
    };
  };
}
