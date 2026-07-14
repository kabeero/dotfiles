{
  config,
  pkgs,
  inputs,
  colors,
  ...
}:

{
  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";
  home.packages = with pkgs; [ ];

  # ╭──────────╮
  # │   apps   │
  # ╰──────────╯

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.btop.enable = true;
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  services.wlsunset = {
    enable = true;
    latitude = 33.68;
    longitude = -117.83;
  };

  # awww for wallpaper rotation
  systemd.user.services.awww = {
    Unit = {
      Description = "Efficient animated wallpaper daemon for Wayland (awww)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    
    Service = {
      Environment = [ "RUST_BACKTRACE=1" ];
      # Ensure WAYLAND_DISPLAY is active before spawning the daemon
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'until [ -n \"$WAYLAND_DISPLAY\" ]; do sleep 0.1; done'";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Change wallpaper using awww";
      After = [ "awww.service" ];
      Requires = [ "awww.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/wallpaper";
    };
  };
  systemd.user.timers.wallpaper = {
    Unit = {
      Description = "Run wallpaper script every 30 minutes";
      After = [ "awww.service" ];
      Requires = [ "awww.service" ];
    };
    Timer = {
      OnActiveSec = "1sec";
      OnUnitActiveSec = "30min";
      AccuracySec = "1s";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
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
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-subs \
          --embed-metadata \
          --convert-subs 'srt' \
          --download-archive $argv[1].txt https://www.youtube.com/$argv[1]/videos; 
      '';

      ytarchivevideo = ''
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-metadata \
          --convert-subs 'srt' \
          --download-archive $argv[1] $argv[2]; 
      '';

      ytd = ''
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-subs \
          --embed-metadata \
          --convert-subs 'srt' \
          $argv
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
    plugins = [ ];
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

    configType = "lua";

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
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      ## flash focus to the new active window
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      # hypr-darkwindow.packages.${pkgs.stdenv.hostPlatform.system}.Hypr-DarkWindow
      # hyprlandPlugins.hypr-darkwindow
      # hyprlandPlugins.hypr-dynamic-cursors
      # TODO: investigate
      # hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
    ];

    extraConfig = builtins.readFile ./cfg/hypr/hyprland.lua;

  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # when sleeping, lock the hypr session
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
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
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && brightnessctl -r"; # screen on when activity is detected after timeout has fired
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
      # tab_title_template = "\" ◇ \"";
      # active_tab_title_template = "\" ◈ \"";
      tab_title_template = "\" 󰮋 \"";
      active_tab_title_template = "\" 󰇈 \"";
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

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            transform = "normal";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "tronics";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "640,2160";
            scale = 1.5;
            transform = "normal";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q *";
            mode = "3840x2160@60.00Hz";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
      {
        profile.name = "work-1-left";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160@59.94Hz";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-1-mid";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-2";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160@59.94Hz";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
        ];
      }
      {
        profile.name = "work-3";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "-3840,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q D*";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL U3223QE C*";
            mode = "3840x2160@60.00Hz";
            position = "2160,0";
            scale = 1.0;
            transform = "90";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q H*";
            mode = "3840x2160@59.94Hz";
            position = "4320,0";
            scale = 1.0;
            transform = "270";
          }
        ];
      }
      {
        profile.name = "work-vr";
        profile.outputs = [
          {
            criteria = "Sharp Corporation LQ*";
            mode = "3840x2400@59.99Hz";
            position = "0,0";
            scale = 1.5;
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL UP3221Q *";
            mode = "3840x2160@60.00Hz";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          }
          {
            criteria = "Visitech AS VITURE *";
            mode = "1920x1200@120.00Hz";
            position = "960,-1200";
            scale = 1.0;
            transform = "normal";
          }
        ];
      }
    ];
  };

  # ╭────────────╮
  # │   stylix   │
  # ╰────────────╯

  stylix.targets.btop.colors.enable = true;
  stylix.targets.kitty.colors.enable = true;
  stylix.targets.kitty.enable = true;

  # ╭─────────╮
  # │   zed   │
  # ╰─────────╯

  programs.zed-editor = {
    enable = true;

    # This populates the userSettings "auto_install_extensions"
    extensions = [
      "nix"
      "toml"
      "elixir"
      "make"
    ];

    # Everything inside of these brackets are Zed options
    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;

        # Provider options:
        # - zed.dev models (claude-3-5-sonnet-latest) requires GitHub connected
        # - anthropic models (claude-3-5-sonnet-latest, claude-3-haiku-latest, claude-3-opus-latest) requires API_KEY
        # - copilot_chat models (gpt-4o, gpt-4, gpt-3.5-turbo, o1-preview) requires GitHub connected
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };

        # inline_alternatives = [
        #   {
        #     provider = "copilot_chat";
        #     model = "gpt-3.5-turbo";
        #   }
        # ];
      };

      # node = {
      #   path = lib.getExe pkgs.nodejs;
      #   npm_path = lib.getExe' pkgs.nodejs "npm";
      # };

      hour_format = "hour24";
      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        # shell = {
        #   program = "zsh";
        # };
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      lsp = {
        rust-analyzer = {
          binary = {
            # path = lib.getExe pkgs.rust-analyzer;
            path_lookup = true;
          };
        };

        nix = {
          binary = {
            path_lookup = true;
          };
        };

        elixir-ls = {
          binary = {
            path_lookup = true;
          };
          settings = {
            dialyzerEnabled = true;
          };
        };
      };

      languages = {
        "Elixir" = {
          language_servers = [
            "!lexical"
            "elixir-ls"
            "!next-ls"
          ];
          format_on_save = {
            external = {
              command = "mix";
              arguments = [
                "format"
                "--stdin-filename"
                "{buffer_path}"
                "-"
              ];
            };
          };
        };

        "HEEX" = {
          language_servers = [
            "!lexical"
            "elixir-ls"
            "!next-ls"
          ];
          format_on_save = {
            external = {
              command = "mix";
              arguments = [
                "format"
                "--stdin-filename"
                "{buffer_path}"
                "-"
              ];
            };
          };
        };
      };

      vim_mode = true;
      relative_line_numbers = "enabled";
      cursor_blink = false;
      scrollbar = {
        show = "never";
      };

      # Tell Zed to use direnv and direnv can use a flake.nix environment
      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      # theme = {
      #   mode = "system";
      #   light = "Ayu Light";
      #   dark = "Ayu Dark";
      # };

      show_whitespaces = "selection";
      # ui_font_size = 16;
      # buffer_font_size = 16;
      buffer_line_height = {
        custom = 1.7;
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      which_key = {
        enabled = true;
        delay_ms = 100;
      };
    };

    userKeymaps = [
      {
        context = "VimControl";
        bindings = {
          "space" = "vim::NormalBefore";
        };
      }
      {
        context = "!menu && !dialog";
        bindings = {
          "cmd-e" = "project_panel::ToggleFocus";
          "ctrl-t" = "project_panel::ToggleFocus";
        };
      }
      {
        context = "Editor && !menu && !dialog && !Terminal && !AgentPanel && !Assistant";
        bindings = {
          "cmd-e" = "project_panel::ToggleFocus";
          "space o" = "file_finder::Toggle";
          "space a" = "workspace::ToggleLeftDock";
          "space e" = "workspace::ToggleRightDock";
          "space space" = "tab_switcher::Toggle";
          "space /" = "pane::DeploySearch";
          "space w m" = "workspace::ToggleZoom";
        };
      }
      {
        context = "Workspace && !menu && !dialog";
        bindings = {
          "ctrl-/" = "terminal_panel::Toggle";
          "ctrl-?" = "workspace::NewTerminal";
        };
      }
      {
        context = "Editor && VimControl && !VimWaiting && !menu && !dialog && !AgentPanel && !Assistant";
        bindings = {
          "space o" = "file_finder::Toggle";
          "space a" = "workspace::ToggleLeftDock";
          "space e" = "workspace::ToggleRightDock";
          "space space" = "tab_switcher::Toggle";
          "space /" = "pane::DeploySearch";
          "space w m" = "workspace::ToggleZoom";
        };
      }
      {
        context = "Editor && !menu && !dialog";
        bindings = {
          "space g c" = "editor::OpenGitBlameCommit";
          "space g h" = "editor::ToggleGitBlame";
          "space g b" = "editor::ToggleGitBlameInline";
        };
      }
      {
        context = "Editor && VimControl && !VimWaiting && !menu && !dialog";
        bindings = {
          "," = "vim::Down";
          "." = "vim::Up";
          "shift-h" = "workspace::ActivatePreviousPane";
          "shift-j" = "workspace::ActivatePaneDown";
          "shift-k" = "workspace::ActivatePaneUp";
          "shift-l" = "workspace::ActivateNextPane";
          "ctrl-h" = "pane::ActivatePreviousItem";
          "ctrl-l" = "pane::ActivateNextItem";
          "ctrl-c" = "pane::CloseActiveItem";
          "space t" = "workspace::NewFile";
          "ctrl-a" = "editor::SelectAll";
          "space shift-w" = "editor::ToggleSoftWrap";
          "space i" = "theme_selector::Toggle";
        };
      }
      {
        context = "Pane";
        unbind = {
          "ctrl-_" = "pane::GoForward";
        };
      }
      {
        context = "VimControl && !menu";
        unbind = {
          "ctrl-o" = "pane::GoBack";
        };
      }
      {
        context = "(VimControl && !menu) || (!Editor && !Terminal)";
        unbind = {
          "g shift-t" = "vim::GoToPreviousTab";
        };
      }
      {
        bindings = {
          "ctrl-l" = "vim::GoToTab";
        };
      }
    ];
  };

  # ╭────────────╮
  # │   zellij   │
  # ╰────────────╯

  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".source = ./cfg/zellij/config.kdl;
  xdg.configFile."zellij/plugins/zjstatus.wasm".source = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  xdg.configFile."zellij/layouts/default.swap.kdl".source = ./cfg/zellij/layout.swap.kdl;
  # inject + interpolate, so we can specify colors dynamically
  # > https://nix-community.github.io/stylix/styling.html
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
