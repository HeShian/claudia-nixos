{ config, lib, ... }:

{
  # ===========================================================================
  # Satty 截图标注工具配置
  # ===========================================================================
  xdg.configFile."satty/config.toml" = {
    force = true;
    text = ''
      [general]
      copy-command = 'wl-copy'
      focus-toggles-toolbars = true
      actions-on-right-click = [ 'save-to-clipboard' ]
    '';
  };
}
