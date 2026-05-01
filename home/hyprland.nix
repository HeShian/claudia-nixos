# =============================================================================
# 文件名:   home/hyprland.nix
# 功能描述: Hyprland 窗口管理器用户级配置
# 说明:     从 ~/dotfiles/.config/hypr/ 迁移至 Home Manager 管理。
#           配置 Hyprland 的监视器、快捷键、外观、输入设备等。
#           注意：系统级启用（programs.hyprland.enable）在系统配置中管理。
# =============================================================================
{ config, pkgs, ... }:

{
  # ===========================================================================
  # Hyprland 配置
  # ===========================================================================
  wayland.windowManager.hyprland = {
    # --- 启用 Hyprland ---
    enable = true;

    # --- 系统设置 ---
    systemd.enable = true;           # 启用 Systemd 集成
    xwayland.enable = true;          # 启用 XWayland 兼容层

    # ================================================================
    # Hyprland 配置文件
    # ================================================================
    extraConfig = ''
      ################
      ### 监视器设置 ###
      ################
      monitor = DP-1, 1920x1080@60, 0x1080, 1

      ###################
      ### 程序快捷方式 ###
      ###################
      $terminal = kitty
      $fileManager = nautilus
      $menu = fuzzel --show drun

      #################
      ### 自动启动  ###
      #################
      exec-once = noctalia-shell
      exec-once = fcitx5 -d

      #############################
      ### 环境变量 ###
      #############################
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24
      env = XCURSOR_THEME,Bibata-Modern-Ice
      env = HYPRCURSOR_THEME,Bibata-Modern-Ice

      #####################
      ### 外观设置 ###
      #####################
      general {
          gaps_in = 2
          gaps_out = 5
          border_size = 1
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          resize_on_border = false
          allow_tearing = false
          layout = dwindle
      }

      decoration {
          rounding = 5
          rounding_power = 2
          active_opacity = 1.0
          inactive_opacity = 1.0
          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }
          blur {
              enabled = true
              size = 3
              passes = 1
              vibrancy = 0.1696
          }
      }

      animations {
          enabled = yes, please :)
          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1
          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          new_status = master
      }

      misc {
          force_default_wallpaper = -1
          disable_hyprland_logo = false
      }

      #############
      ### 输入  ###
      #############
      input {
          kb_layout = us
          follow_mouse = 1
          sensitivity = 0
          touchpad {
              natural_scroll = false
          }
      }

      ###################
      ### 快捷键绑定  ###
      ###################
      $mainMod = SUPER

      # 启动终端和菜单
      bind = $mainMod, Return, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, D, exec, $menu
      bind = $mainMod, P, pseudo,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod, T, exec, alacritty

      # 移动焦点
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # 切换工作区
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # 移动窗口到工作区
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # 特殊工作区（草稿本）
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # 鼠标滚轮切换工作区
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # 鼠标拖动移动/调整窗口
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # 多媒体键
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

      # 媒体控制
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      # 导入 Noctalia 颜色配置
      source = ~/.config/hypr/noctalia/noctalia-colors.conf
    '';
  };
}
