{
  config,
  pkgs,
  inputs,
  colors,
  ...
}:

let 
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };
in 
{
  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";
  home.packages = with pkgs; [
    # pkgs.hyprlandPlugins.hypr-darkwindow
    # pkgs.hyprlandPlugins.hypr-dynamic-cursors
    # # pkgs.hyprlandPlugins.hyprgrass
    # # pkgs.hyprlandPlugins.hyprspace
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

  # ╭────────────╮
  # │   stylix   │
  # ╰────────────╯

  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  # };
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.targets.btop.colors.enable = true;

  # ╭─────────╮
  # │   git   │
  # ╰─────────╯

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
        l = "log --color --stat";
        ll = "log --color --stat -p";
        lg = "log --graph --format=\"%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)\"";
        lgg = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
        pu = "push";
        pl = "pull";
        s = "status";
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

  # ╭──────────╮
  # │   hypr   │
  # ╰──────────╯

  wayland.windowManager.hyprland = {
    enable = true;

    # Warning: If you use the Home Manager module, make sure to disable systemd integration, as it conflicts with UWSM.
    systemd.enable = false;

    # > https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
    # This explicitly tells Home-Manager, "Don't install your own version of Hyprland; just manage the configuration files for the one that the system is providing."
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

      # > https://wiki.hyprland.org/Configuring/Animations/ for more
      animations = {
        # animation = NAME, ONOFF, SPEED, CURVE [,STYLE]
        animation = [
          "workspaces, 1, 4, default, fade"
          "windows, 1, 4, default"
          "fade, 1, 4, default"
        ];
      };

      bind = [
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
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          ) 9
        )
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
          # color = "rgba(1a1a1aee)";
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
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        layout = "hy3";
        # layout = "dwindle";
        # layout = "scrolling";
      };

      gestures = {
        gesture = [
          "2, swipe, mod: SUPER, resize"
          "4, horizontal, workspace"
          "3, vertical, fullscreen"
        ];
      };

      group = {
        # "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.border_inactive" = "rgba(595959aa)";
        groupbar = {
          enabled = true;
          keep_upper_gap = true;
          render_titles = false;
          height = 32;
          indicator_gap = -6;
          indicator_height = 6;
          rounding = 2;
          gaps_out = 8;
          # "col.active" = "rgba(33ccff66) rgba(00ff9966) 180deg";
          # "col.inactive" = "rgba(59595966)";
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

      exec-once = [
        "hypridle"
      ];

    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # when sleeping, lock the hypr session
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 60; # 1min
          on-timeout = "brightnessctl -s set 10"; # razer max is 448
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 180; # 3min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
        }
        # {
        #   # razer kb is apparently not controlled this way
        #   # > for device in (brightnessctl -l | grep Device | awk '{print $2}' | tr -d "'" | grep -v intel); echo $device ; sleep 1 ; brightnessctl -sd $device set 0 ; sleep 3 ; brightnessctl -sd $device set 1; end
        #   timeout = 30; # 0.5min
        #   on-timeout = "brightnessctl -sd phy0-led set 0"; # turn off keyboard backlight
        #   on-resume = "brightnessctl -rd phy0-led"; # turn on keyboard backlight on resume
        # }
      ];
    };
  };

  # ╭────────────╮
  # │   zellij   │
  # ╰────────────╯

  programs.zellij.enable = true;

  home.file.".config/zellij/plugins/zjstatus.wasm".source = zjstatus;

  xdg.configFile."zellij/config.kdl".source = ./cfg/zellij/config.kdl;
  # inject + interpolate, so we can specify colors dynamically
  # > https://nix-community.github.io/stylix/styling.html
  # Default text color: base00
  # Alternate text color: base01
  # Item on background color: base0E
  # Item off background color: base0D
  # Alternate item on background color: base09
  # Alternate item off background color: base02
  # List unselected background: base0D
  # List selected background: base03
  xdg.configFile."zellij/layouts/default.kdl".text = 
  ''
    layout {
      default_tab_template {
        pane size=2 borderless=true {
          plugin location="file:$HOME/.config/zellij/plugins/zjstatus.wasm" {
            hide_frame_for_single_pane "false"
  
            // format_left   "{mode} {tabs}"
            // format_right  "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base02},bold] #[bg=#${colors.base02},fg=#${colors.base05},bold] {session}#[fg=#${colors.base02},bold]◗ {datetime}"

            // format_left   "#[fg=#${colors.base0F}]#[bg=#${colors.base0F},fg=#${colors.base00},bold] #[bg=#${colors.base0F},fg=#${colors.base00},bold] {session}#[fg=#${colors.base0F},bold]◗ {tabs}"
            format_left   "#[fg=#${colors.base00}]#[bg=#${colors.base00},fg=#${colors.base0D},bold] #[bg=#${colors.base00},fg=#${colors.base0D},bold] {session}#[fg=#${colors.base00},bold]◗ {tabs}"
            format_right  "{mode} {datetime}"

            // format_space  ""

            // palette
            // format_left  "#[bg=#${colors.base00}]00;#[bg=#${colors.base01}]01;#[bg=#${colors.base02}]02;#[bg=#${colors.base03}]03;#[bg=#${colors.base04}]04;#[bg=#${colors.base05}]05;#[bg=#${colors.base06}]06;#[bg=#${colors.base07}]07;#[bg=#${colors.base08}]08;#[bg=#${colors.base09}]09;#[bg=#${colors.base0A}]0A;#[bg=#${colors.base0B}]0B;#[bg=#${colors.base0C}]0C;#[bg=#${colors.base0D}]0D;#[bg=#${colors.base0E}]0E;#[bg=#${colors.base0F}]0F; {tabs}"
  
            mode_normal        "#[fg=#${colors.base0B}]#[bg=#${colors.base0B},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0B}]◗"
            mode_locked        "#[fg=#${colors.base04}]#[bg=#${colors.base04},fg=#${colors.base00},bold]{name}#[fg=#${colors.base04}]◗"
            mode_resize        "#[fg=#${colors.base08}]#[bg=#${colors.base08},fg=#${colors.base00},bold]{name}#[fg=#${colors.base08}]◗"
            mode_pane          "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0D}]◗"
            mode_tab           "#[fg=#${colors.base07}]#[bg=#${colors.base07},fg=#${colors.base00},bold]{name}#[fg=#${colors.base07}]◗"
            mode_scroll        "#[fg=#${colors.base0A}]#[bg=#${colors.base0A},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0A}]◗"
            mode_enter_search  "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0D}]◗"
            mode_search        "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0D}]◗"
            mode_rename_tab    "#[fg=#${colors.base07}]#[bg=#${colors.base07},fg=#${colors.base00},bold]{name}#[fg=#${colors.base07}]◗"
            mode_rename_pane   "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0D}]◗"
            mode_session       "#[fg=#${colors.base0E}]#[bg=#${colors.base0E},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0E}]◗"
            mode_move          "#[fg=#${colors.base0F}]#[bg=#${colors.base0F},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0F}]◗"
            mode_prompt        "#[fg=#${colors.base0D}]#[bg=#${colors.base0D},fg=#${colors.base00},bold]{name}#[fg=#${colors.base0D}]◗"
            mode_tmux          "#[fg=#${colors.base09}]#[bg=#${colors.base09},fg=#${colors.base00},bold]{name}#[fg=#${colors.base09}]◗"
            mode_default_to_mode "tmux" // if not listed above, which color to use
  
            // formatting for inactive tabs
            tab_normal              "#[fg=#${colors.base00}]#[bg=#${colors.base00},fg=#${colors.base03},bold]{index} #[bg=#${colors.base00},fg=#${colors.base01},bold] {name}{floating_indicator}#[fg=#${colors.base00},bold]◗"
            tab_normal_fullscreen   "#[fg=#${colors.base00}]#[bg=#${colors.base00},fg=#${colors.base03},bold]{index} #[bg=#${colors.base00},fg=#${colors.base01},bold] {name}{fullscreen_indicator}#[fg=#${colors.base00},bold]◗"
            tab_normal_sync         "#[fg=#${colors.base00}]#[bg=#${colors.base00},fg=#${colors.base03},bold]{index} #[bg=#${colors.base00},fg=#${colors.base01},bold] {name}{sync_indicator}#[fg=#${colors.base00},bold]◗"
  
            // formatting for the current active tab
            tab_active              "#[fg=#${colors.base0B}]#[bg=#${colors.base0B},fg=#${colors.base00},bold]{index} #[bg=#${colors.base01},fg=#${colors.base06},bold] {name}{floating_indicator}#[fg=#${colors.base01},bold]◗"
            tab_active_fullscreen   "#[fg=#${colors.base0B}]#[bg=#${colors.base0B},fg=#${colors.base00},bold]{index} #[bg=#${colors.base01},fg=#${colors.base06},bold] {name}{fullscreen_indicator}#[fg=#${colors.base01},bold]◗"
            tab_active_sync         "#[fg=#${colors.base0B}]#[bg=#${colors.base0B},fg=#${colors.base00},bold]{index} #[bg=#${colors.base01},fg=#${colors.base06},bold] {name}{sync_indicator}#[fg=#${colors.base01},bold]◗"
  
            // separator between the tabs
            tab_separator           " "
  
            // indicators
            tab_sync_indicator       " "
            tab_fullscreen_indicator " 󰊓"
            tab_floating_indicator   " 󰹙"
  
            command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
            command_git_branch_format      "#[fg=blue] {stdout} "
            command_git_branch_interval    "10"
            command_git_branch_rendermode  "static"
  
            datetime          "#[fg=#6C7086,bold] {format} "
            datetime_format   "%H:%M"
            datetime_timezone "America/Los_Angeles"
          }
        }
        children
      }
    }
  '';
}
