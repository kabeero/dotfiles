# ╭────────────╮
# │   waybar   │
# ╰────────────╯

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        # - background - Below all other layers
        # - bottom - Below normal windows
        # - top - Above normal windows but below overlay
        # - overlay - Above everything, including fullscreen windows
        layer = "top";
        position = "bottom";
        height = 32;

        modules-left = [ "hyprland/workspaces" ];

        "hyprland/workspaces" = {
          format = "{name}";
          disable-scroll = true;
          all-outputs = false;
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

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #888888;
      }

      #workspaces button.active {
        color: #ffffff;
        /* 0D: cyan, 0B: green, 07: white, 01..06 : grays */
        border-top: 2px solid @base0D;
      }
    '';
  };
}
