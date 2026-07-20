# ╭────────────╮
# │   waybar   │
# ╰────────────╯

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "hyprland/workspaces" ];

        "hyprland/workspaces" = {
          format = "{name}";
          disable-scroll = true;
          all-outputs = true;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: sans-serif;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #ffffff;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #888888;
      }

      #workspaces button.active {
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
      }
    '';
  };
}
