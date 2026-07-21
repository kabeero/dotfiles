# ╭─────────╮
# │   zed   │
# ╰─────────╯

{ config, pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "elixir"
      "make"
    ];

    userSettings = {

      agent_servers = {
        opencode = {
          type = "custom";
          command = "opencode";
          args = [ "acp" ];
        };
        poolside = {
          type = "custom";
          command = "pool";
          args = [ "acp" ];
        };
      };

      hour_format = "hour24";
      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = true;
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
          TERM = "kitty";
        };
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      lsp = {
        rust-analyzer = {
          binary = {
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
          format_on_save = true;
          formatter = {
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
          format_on_save = true;
          formatter = {
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

      load_direnv = "shell_hook";
      base_keymap = "VSCode";

      show_whitespaces = "selection";
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
}
