{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";
  home.packages = with pkgs; [
    pkgs.hyprland
    pkgs.hyprlandPlugins.hy3
    pkgs.hyprlandPlugins.hypr-darkwindow
    pkgs.hyprlandPlugins.hypr-dynamic-cursors
    # pkgs.hyprlandPlugins.hyprgrass
    # pkgs.hyprlandPlugins.hyprspace
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.wlsunset = {
    enable = true;
    latitude = 33.68;
    longitude = -117.83;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
       user = {
         useConfigOnly = true;
         name = "M K Gharzai";
         email = "kabeer@gharzai.net";
       };
       alias = {
          l   = "log --color --stat";
          ll  = "log --color --stat -p";
          lg  = "log --graph --format=\"%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)\"";
          lgg = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
          pu  = "push";
          pl  = "pull";
          s   = "status";
       };
       branch.sort = "-committerdate";
       core = {
         pager = "delta --dark";
         editor = "nvim";
       };
       delta = {
         side-by-side = true;
         line-numbers = true;
       };
       diff = {
         algorithm = "histogram";
         colorMoved = "default";
       };
       init.defaultBranch = "main";
       log.date = "iso-local";
       merge = {
         tool = "difftastic";
         conflictstyle = "zdiff3";
       };
       push = {
         default = "simple";
         autoSetupRemote = true;
         followtags = true;
       };
       rerere.enabled = true;
    };
  };
  
  wayland.windowManager.hyprland = {
    enable = true;

    # Warning: If you use the Home Manager module, make sure to disable systemd integration, as it conflicts with UWSM. 
    systemd.enable = false;

    # > https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    package = null;
    portalPackage = null;

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hypr-darkwindow
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprgrass
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprspace
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
    ];

    settings = {
      "$mod" = "SUPER";
      "$moveMod" = "SUPER_SHIFT";
      "$menu" = "rofi -show combi -theme \"$HOME/.config/rofi/launchers/type-6/style-1.rasi\"";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";

      bind =
        [
          # utils
          # "$moveMod, F, exec, firefox"
          "$mod, code:36, exec, $terminal # enter"
          "$mod, R, exec, $menu"
          "$mod, L, exec, hyprlock"
          "$mod, M, exec, pavucontrol"
          "CTRL_SHIFT, X, exit,"
          "SUPER_SHIFT, E, exec, $fileManager"
          "$mod, C, killactive,"
          "$mod, code:24, killactive, # '"
          "CTRL, down, exec, hyprctl dispatch hyprexpo:expo toggle"

          # window manip
          "$mod, space, togglefloating,"
          "$moveMod, P, pin"
          "$mod, P, pseudo, # dwindle"
          "$mod, E, togglesplit, # dwindle"
          "$mod, W, togglegroup"
          "$mod, F, fullscreen, 1 # gaps"
          "$moveMod, F, fullscreen, 0 # no gaps"

          # window motions
          # "$mod, j, hy3:movefocus, l"
          # "$mod, k, hy3:movefocus, r"
          # "$mod, left, hy3:movefocus, l"
          # "$mod, right, hy3:movefocus, r"
          # "$mod, up, hy3:movefocus, u"
          # "$mod, q, hy3:movefocus, u"
          # "$mod, down, hy3:movefocus, d"
          # "$mod, code:52, hy3:movefocus, d # ;"
          # "$moveMod, j, hy3:movewindow, l"
          # "$moveMod, k, hy3:movewindow, r"
          # "$moveMod, left, hy3:movewindow, l"
          # "$moveMod, right, hy3:movewindow, r"
          # "$moveMod, code:52, hy3:movewindow, d"
          # "$moveMod, q, hy3:movewindow, u"
          "$mod, j, movefocus, l"
          "$mod, k, movefocus, r"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, q, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, code:52, movefocus, d # ;"
          "$moveMod, j, movewindow, l"
          "$moveMod, k, movewindow, r"
          "$moveMod, left, movewindow, l"
          "$moveMod, right, movewindow, r"
          "$moveMod, code:52, movewindow, d"
          "$moveMod, q, movewindow, u"

          # "$mod, S, togglespecialworkspace, magic"
          # "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # screenshots
          ", Print, exec, grimblast copysave area"
          "$mod, o, exec, grimblast copysave area"
          "$mod SHIFT, o, exec, swappy -f $(grimblast copysave area)"

          # hyprscrolling
          "$mod, period, layoutmsg, move +col"
          "$mod, comma, layoutmsg, move -col"
          "$mod SHIFT, h, layoutmsg, movewindowto l"
          "$mod SHIFT, l, layoutmsg, movewindowto r"
          "$mod SHIFT, c, layoutmsg, movewindowto u"
          "$mod SHIFT, t, layoutmsg, movewindowto d"

        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
              ]
            )
            9)
        );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
        };
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = "0.1696";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        layout = "hy3";
        # layout = "dwindle";
        # layout = "scrolling";
      };

      group = {
        "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.border_inactive" = "rgba(595959aa)";
        groupbar = {
            enabled = true;
            keep_upper_gap = true;
            render_titles = false;
            height = 32;
            indicator_gap = -6;
            indicator_height = 6;
            rounding = 2;
            gaps_out = 8;
            "col.active" = "rgba(33ccff66) rgba(00ff9966) 180deg";
            "col.inactive" = "rgba(59595966)";
        };
      };

      input = {
         kb_layout = "us";
         kb_variant = "dvorak";
         repeat_delay = 180;
         repeat_rate = 100;
         follow_mouse = true;
         sensitivity = 0;
         natural_scroll = true;
         touchpad = {
             natural_scroll = true;
         };
       };

      monitor = [
        "eDP-1,preferred,auto,auto"
      ];

      plugin = {
        hyprbars = {
            bar_height = 20;
            hyprbars-button = [
              "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
              "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
            ];
            on_double_click = "hyprctl dispatch fullscreen 1";
        };
        hyprscrolling = {
            column_width = "0.7";
            fullscreen_on_one_column = false;
        };
      };
    };
  };

}
