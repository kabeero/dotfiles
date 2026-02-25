{
  config,
  pkgs,
  inputs,
  colors,
  ...
}:

## used overlay in config.nix instead
# let 
#   zjstatus = pkgs.fetchurl {
#     url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
#     sha256 = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
#   };
# in 
{
  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";
  home.packages = with pkgs; [];

  home.shell.enableFishIntegration = true;
  services.ssh-agent.enableFishIntegration = true;

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

  # ╭──────────╮
  # │   apps   │
  # ╰──────────╯

  programs.btop.enable = true;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # ╭──────────╮
  # │   fish   │
  # ╰──────────╯

  programs.fish = {
    enable = true;
    shellAbbrs = {
      gitclean = "git fetch -p && git branch -vv | grep ': gone]' | awk '{print}' | xargs git branch -D $argv;";
      dotdot = {
        regex = "^\\.\\.+$";
        function = "multicd";
      };
    };
    shellAliases = {
      ls = "eza";
      l = "ls";
      l1 = "ls -1";
      ll = "ls -l --icons --git";
      r = "ranger";
      y = "yazi";
      v = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      cdr = "cd (git rev-parse --show-cdup)";
      cdllm = "cd (mktemp -d -t llm.XXXXXXXX); type -q opencode && opencode";
      diffk = "kitty +kitten diff";
      glow = "glow -p";
      gu = "gitui";
      jless = "jless -r";
      sio = "sioyek";
      tfia = "terraform init ; terraform apply";
      tfmt = "terraform fmt -recursive";
    };
    functions = {
      d = ''
        set apps bat fzf
        for a in $apps
            if ! command -v $a >/dev/null
                echo "❗ Please install $a"
                return
            end
        end
        set flags -e -1 --preview='bat --color always -p {}' --bind shift-up:preview-page-up,shift-down:preview-page-down
        set chosen ""
        if test (count $argv) -gt 0
            set chosen (fzf $flags -q $argv[1])
        else
            set chosen (fzf $flags)
        end
        if set -q chosen && test -n "$chosen"
            cd (dirname $chosen)
        end
      '';

      e = ''
        set apps bat fzf nvim
        for a in $apps
            if ! command -v $a >/dev/null
                echo "❗ Please install $a"
                return
            end
        end
        set flags -e -1 --preview='bat --color always -p {}' --bind shift-up:preview-page-up,shift-down:preview-page-down
        set chosen ""
        if test (count $argv) -gt 0
            set chosen (fzf $flags -q $argv[1])
        else
            set chosen (fzf $flags)
        end
        if set -q chosen && test -n "$chosen"
            nvim $chosen
        end
      '';

      z = ''
        zellij ls -s | sort | awk '{printf "\033[32m%15s\033[0m\n", $1}'
        alias z="zellij"
      '';

      dockerls = ''
        docker ps --format "table {{.Image}}\t{{.Ports}}\t{{.Names}}"
      '';

      multicd = ''
        echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
      '';

      fish_hybrid_key_bindings = ''
        for mode in default insert visual
            fish_default_key_bindings -M $mode
        end
        fish_vi_key_bindings --no-erase
      '';

      ytarchive = '' 
        function ytarchive
         yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
           --sponsorblock-mark "all" \
           --geo-bypass \
           --sub-langs 'all' \
           --embed-subs \
           --embed-metadata \
           --convert-subs 'srt' \
           --download-archive $argv[1].txt https://www.youtube.com/$argv[1]/videos; 
        end
      '';

      ytarchivevideo = '' 
        function ytarchivevideo
          yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
            --sponsorblock-mark "all" \
            --geo-bypass \
            --sub-langs 'all' \
            --embed-metadata \
            --convert-subs 'srt' \
            --download-archive $argv[1] $argv[2]; 
        end
      '';

      ytd = '' 
        function ytd
          yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
            --sponsorblock-mark "all" \
            --geo-bypass \
            --sub-langs 'all' \
            --embed-subs \
            --embed-metadata \
            --convert-subs 'srt' \
            $argv
        end
      '';

    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -gx EDITOR nvim
      set -Ux GOPATH {$HOME}/Code/go
      set -Ux GOBIN {$GOPATH}/bin
      set -Ux AWS_CLI_AUTO_PROMPT on-partial
      set -Ux ERL_AFLAGS "-kernel shell_history enabled"
      set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin
      pfetch
      echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"
      zellij setup --generate-completion fish | source
      fish_add_path {$HOME}/.asdf/bin
      fish_add_path {$HOME}/.cargo/bin
      fish_add_path {$HOME}/.yarn/bin
      fish_add_path {$HOME}/.local/bin
      fish_add_path {$GOBIN}
      mise activate fish | source
      starship init fish | source
      zoxide init --cmd c fish | source
      eval (ssh-agent -c) >/dev/null
      ssh-add -q
      set -g fish_key_bindings fish_hybrid_key_bindings
    '';
    plugins = [];
  };

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

    plugins = with inputs; [
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hypr-darkwindow
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      ## touchscreen gestures
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprgrass
      ## overview
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprspace
      ## title bars
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      ## flash focus to the new active window
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      # hypr-darkwindow.packages.${pkgs.stdenv.hostPlatform.system}.Hypr-DarkWindow
      # hyprlandPlugins.hypr-darkwindow
      # hyprlandPlugins.hypr-dynamic-cursors
      hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
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
        "CTRL, up, exec, hyprctl dispatch hyprexpo:expo toggle"
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
        # "$moveMod, q, hy3:movewindow, u"
        # "$moveMod, code:52, hy3:movewindow, d"
        ## with hyprscrolling, windows can sometimes stop being focused...
        # "$mod, j, movefocus, l"
        # "$mod, left, movefocus, l"
        # "$mod, k, movefocus, r"
        # "$mod, right, movefocus, r"
        "$mod, q, movefocus, u"
        "$mod, up, movefocus, u"
        "$mod, code:52, movefocus, d" # ;
        "$mod, down, movefocus, d"
        # "$moveMod, j, movewindow, l"
        # "$moveMod, left, movewindow, l"
        # "$moveMod, k, movewindow, r"
        # "$moveMod, right, movewindow, r"
        # "$moveMod, q, movewindow, u"
        # "$moveMod, up, movewindow, u"
        # "$moveMod, code:52, movewindow, d" # ;
        # "$moveMod, down, movewindow, d" # ;

        # "$mod, S, togglespecialworkspace, magic"
        # "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # screenshots
        ", Print, exec, grimblast copysave area"
        "$mod, o, exec, grimblast copysave area"
        "$mod SHIFT, o, exec, swappy -f $(grimblast copysave area)"

        # hyprscrolling

        "$mod, j, layoutmsg, move -col"
        "$mod, left, layoutmsg, move -col"
        "$mod, comma, layoutmsg, move -col"

        "$mod, k, layoutmsg, move +col"
        "$mod, right, layoutmsg, move +col"
        "$mod, period, layoutmsg, move +col"

        "$moveMod, comma, layoutmsg, swapcol l"
        "$moveMod, period, layoutmsg, swapcol r"

        "$moveMod, j, layoutmsg, movewindowto l"
        "$moveMod, left, layoutmsg, movewindowto l"

        "$moveMod, k, layoutmsg, movewindowto r"
        "$moveMod, right, layoutmsg, movewindowto r"

        "$moveMod, q, layoutmsg, movewindowto u"
        "$moveMod, up, layoutmsg, movewindowto u"

        "$moveMod, code:52, layoutmsg, movewindowto d"
        "$moveMod, down, layoutmsg, movewindowto d"

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

      cursor = {
        hide_on_key_press = true;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 1.0;
        inactive_opacity = 0.8;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
          vibrancy = "0.1696";
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          # color = "rgba(1a1a1aee)";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        # layout = "dwindle"; # default
        # layout = "hy3"; # hyprland i3-like
        layout = "scrolling"; # hyprland niri-like
      };

      gestures = {
        workspace_swipe_touch = true;
        workspace_swipe_cancel_ratio = "0.25";
        workspace_swipe_create_new = false;
        gesture = [
          "2, swipe, mod: SUPER, resize"
          "2, pinch, mod: SUPER, float"
          "3, vertical, fullscreen"
          "3, left, dispatcher, layoutmsg, move +col" # natural scroll
          "3, right, dispatcher, layoutmsg, move -col" # natural scroll
          "4, horizontal, workspace"
          "4, vertical, dispatcher, hyprexpo:expo, toggle"
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
        accel_profile = "flat";
        sensitivity = "0.3";
        follow_mouse = false;
        natural_scroll = true;

        kb_layout = "us";
        kb_variant = "dvorak";
        repeat_delay = 180;
        repeat_rate = 100;

        touchpad = {
          natural_scroll = true;
        };
      };

      monitor = [
        ",preferred,auto,auto"
      ];

      plugin = {
        hyprbars = {
          bar_height = 20;
          # hyprbars-button = [
          #   "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
          #   "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
          # ];
          on_double_click = "hyprctl dispatch fullscreen 1";
        };
        hyprscrolling = {
          column_width = "0.90";
          fullscreen_on_one_column = true;
        };
      };

      windowrule = [
        "match:class kitty, opacity 0.9"
      ];

      exec-once = [
        "hypridle"
        "kanshi"
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
        # ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 60; # 1min
          on-timeout = "brightnessctl -s set 10"; # razer max is 448
          on-resume = "brightnessctl -r";
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 180; # 3min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 1800; # 30min
          on-timeout = "systemctl suspend"; # suspend pc
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
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

  # ╭───────────╮
  # │   kitty   │
  # ╰───────────╯

  programs.kitty = {
    enable = true;
    # background_opacity = "0.85";
    settings = {
      adjust_line_height = "120%";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      strip_trailing_spaces = "smart";
      focus_follows_mouse = true;
      sync_to_monitor = true;
      enable_audio_bell = false;
      remember_window_size = false;
      initial_window_width = 960;
      initial_window_height = 720;
      enabled_layouts = "Tall, Fat, Vertical, Horizontal, Stack, Grid";
      window_border_width = 0;
      window_margin_width = "3.0";
      window_padding_width = "6.0";
      inactive_text_alpha = "0.7";
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 2;
      tab_bar_edge = "top";
      tab_bar_style = "separator";
      tab_powerline_style = "round";
      tab_separator = "\"\"";
      # tab_title_template = " {title.split('/')[-1].partition('-')[0].strip()} ";
      tab_title_template = "\" ◇ \"";
      active_tab_title_template = "\" ◈ \"";
      tab_bar_background = "none";
      # background_opacity = "0.85"; # hyprland overrides
      dynamic_background_opacity = true;
      dim_opacity = "0.75";
      selection_background = "#aaffaa";
    };
    keybindings = {
      "kitty_mod+c" = "copy_or_interrupt";
      "kitty_mod+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_selection";
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+i" = "set_tab_title";
      "kitty_mod+l" = "next_layout";
      "kitty_mod+/" = "last_used_layout";
      "kitty_mod+m" = "goto_layout stack";
      "kitty_mod+s" = "goto_layout vertical";
      "kitty_mod+p>u" = "kitten hints";
      "kitty_mod+p>c>l" = "kitten hints --program @ --type line";
      "kitty_mod+p>c>h" = "kitten hints --program @ --type hash";
      "kitty_mod+p>c>p" = "kitten hints --program @ --type path";
      "kitty_mod+p>c>u" = "kitten hints --program @";
      "kitty_mod+a>m" = "set_background_opacity +0.05";
      "kitty_mod+a>l" = "set_background_opacity -0.05";
    };
  };

  # ╭──────────────╮
  # │   monitors   │
  # ╰──────────────╯

  xdg.configFile."kanshi/config".text = ''
    # https://gitlab.freedesktop.org/emersion/kanshi/-/blob/master/config.c
    # position is flipped in Y
    
    profile laptop-only {
    	output "Sharp Corporation LQ*" mode 3840x2400 scale 1.5 position 0,0 transform normal
    }
    
    profile tronics {
    	output "Sharp Corporation LQ*" mode 3840x2400 scale 1.5 position 0,2160 transform normal
    	output "Dell Inc. DELL UP3221Q *" mode 3840x2160 scale 1.0 position 0,0 transform normal
    }
  '';

  # ╭────────────╮
  # │   stylix   │
  # ╰────────────╯

  ## from config.nix
  # stylix.enable = true;
  # stylix.autoEnable = true;
  # # > https://nix-community.github.io/stylix/configuration.html
  # # > https://tinted-theming.github.io/tinted-gallery/
  # # > https://github.com/SenchoPens/base16.nix (base16-schemes pkg)
  # # > https://github.com/tinted-theming/schemes (not a nix pkg yet)
  # # ayu-dark*, deep, grape, gruvbox-dark-hard* (meh), hipster-green, homebrew, horizon-dark* (!), isotope* (!)
  # # stylix.base16Scheme = "${inputs.tt-schemes}/base16/horizon-dark.yaml"; # no green or fellow
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/isotope.yaml";
  # stylix.image = pkgs.fetchurl {
  #   # url = "https://w.wallhaven.cc/full/ml/wallhaven-mlzgy1.jpg"; # blue space
  #   url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png"; # cyan / orange / pink space
  #   hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
  # };
  # # generating a palette works OK, but seems to produce crazy combinations, completely unreadable
  # # stylix.polarity = "light";
  # # stylix.polarity = "dark";

  # stylix = {
  #   enable = true;
  #   base16Scheme = "${inputs.tt-schemes}/base16/isotope.yaml";
  #   # image = pkgs.fetchurl {
  #   #     # url = "https://w.wallhaven.cc/full/ml/wallhaven-mlzgy1.jpg"; # blue space
  #   #     url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png"; # cyan / orange / pink space
  #   #     hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
  #   # };
  # };
  stylix.targets.btop.colors.enable = true;
  stylix.targets.kitty.colors.enable = true;
  stylix.targets.kitty.enable = true;

  # ╭────────────╮
  # │   zellij   │
  # ╰────────────╯

  programs.zellij.enable = true;

  xdg.configFile."zellij/plugins/zjstatus.wasm".source = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  xdg.configFile."zellij/config.kdl".source = ./cfg/zellij/config.kdl;
  # inject + interpolate, so we can specify colors dynamically
  # > https://nix-community.github.io/stylix/styling.html
  xdg.configFile."zellij/layouts/default.swap.kdl".source = ./cfg/zellij/layout.swap.kdl;
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
        pane size=2 borderless=true {
          plugin location="file:$HOME/.config/zellij/plugins/zjstatus.wasm" {

            color_bg "#${colors.base00}"
            color_fg "#${colors.base06}"
            color_black "#${colors.base00}"
            color_gray1 "#${colors.base01}"
            color_gray2 "#${colors.base02}"
            color_gray3 "#${colors.base03}"
            color_gray4 "#${colors.base04}"
            color_gray5 "#${colors.base05}"
            color_gray6 "#${colors.base06}"
            color_white "#${colors.base07}"
            color_red "#${colors.base08}"
            color_orange "#${colors.base09}"
            color_yellow "#${colors.base0A}"
            color_green "#${colors.base0B}"
            color_blue "#${colors.base0C}"
            color_cyan "#${colors.base0D}"
            color_magenta "#${colors.base0E}"
            color_maroon "#${colors.base0F}"

            hide_frame_for_single_pane "false"

            // style: pill
            // format_left   "#[fg=$bg,bg=none]#[fg=$maroon,bg=$bg,bold] {session}#[fg=$bg,bg=none]◗ {tabs}"

            // style: plain
            format_left   " #[fg=$maroon,bg=none,bold] {session}  {tabs}"

            format_right  "{mode} {datetime}"

            // format_space  ""

            // palette
            // format_left  "#[bg=#${colors.base00}]00;#[bg=#${colors.base01}]01;#[bg=#${colors.base02}]02;#[bg=#${colors.base03}]03;#[bg=#${colors.base04}]04;#[bg=#${colors.base05}]05;#[bg=#${colors.base06}]06;#[bg=#${colors.base07}]07;#[bg=#${colors.base08}]08;#[bg=#${colors.base09}]09;#[bg=#${colors.base0A}]0A;#[bg=#${colors.base0B}]0B;#[bg=#${colors.base0C}]0C;#[bg=#${colors.base0D}]0D;#[bg=#${colors.base0E}]0E;#[bg=#${colors.base0F}]0F; {tabs}"
            // format_left  "#[bg=$fg]fg;#[bg=none]bg;#[bg=$black]black;#[bg=$gray1]gray1;#[bg=$gray2]gray2;#[bg=$gray3]gray3;#[bg=$gray4]gray4;#[bg=$gray5]gray5;#[bg=$red]red;#[bg=$orange]orange;#[bg=$yellow]yellow;#[bg=$green]green;#[bg=$cyan]cyan;#[bg=$blue]blue;#[bg=$magenta]magenta;#[bg=$maroon]maroon;#[bg=$white]white;"
  
            mode_normal        ""
            mode_locked        "#[fg=$maroon,bg=none]#[bg=$maroon,fg=$gray1,bold]{name}#[fg=$maroon,bg=none]◗"
            mode_pane          "#[fg=$gray5,bg=none]#[bg=$gray5,fg=$gray1,bold]{name}#[fg=$gray5,bg=none]◗"
            mode_tab           "#[fg=$gray5,bg=none]#[bg=$gray5,fg=$gray1,bold]{name}#[fg=$gray5,bg=none]◗"
            mode_scroll        "#[fg=$red,bg=none]#[bg=$red,fg=$gray1,bold]{name}#[fg=$red,bg=none]◗"
            mode_enter_search  "#[fg=$yellow,bg=none]#[bg=$yellow,fg=$gray1,bold]{name}#[fg=$yellow,bg=none]◗"
            mode_search        "#[fg=$yellow,bg=none]#[bg=$yellow,fg=$gray1,bold]{name}#[fg=$yellow,bg=none]◗"
            mode_resize        "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_rename_tab    "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_rename_pane   "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_move          "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_session       "#[fg=$green,bg=none]#[bg=$green,fg=$gray1,bold]{name}#[fg=$green,bg=none]◗"
            mode_prompt        "#[fg=$magenta,bg=none]#[bg=$magenta,fg=$gray1,bold]{name}#[fg=$magenta,bg=none]◗"
            mode_tmux          "#[fg=$cyan,bg=none]#[bg=$cyan,fg=$gray1,bold]{name}#[fg=$cyan,bg=none]◗"
            mode_default_to_mode "tmux" // if not listed above, which color to use

            // style: pill
            // tab_normal              "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none]◗"
            // tab_normal_fullscreen   "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none]◗"
            // tab_normal_sync         "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none]◗"

            // style: plain
            tab_normal              "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none] "
            tab_normal_fullscreen   "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none] "
            tab_normal_sync         "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none] "

            // formatting for the current active tab
            // style: pill
            tab_active              "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none]◗"
            tab_active_fullscreen   "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none]◗"
            tab_active_sync         "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none]◗"

            // style: plain
            // tab_active              "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{floating_indicator} "
            // tab_active_fullscreen   "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{fullscreen_indicator} "
            // tab_active_sync         "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{sync_indicator} "
  
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
  
            datetime          "#[fg=$gray3,bold] {format} "
            datetime_format   "%H:%M"
            datetime_timezone "America/Los_Angeles"
          }
        }
        children
      }
    }
  '';
}
