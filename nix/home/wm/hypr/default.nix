# ╭──────────╮
# │   hypr   │
# ╰──────────╯

{ config, pkgs, inputs, ... }:

{
  imports = [ ./waybar.nix ];

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "lua";

    systemd.enable = false;

    package = null;
    portalPackage = null;

    plugins = with inputs; [
      hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
    ];

    extraConfig = builtins.readFile ./hyprland.lua;

  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
      };

      listener = [
        {
          timeout = 60;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 180;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && brightnessctl -r";
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
          and = "! hyprctl activewindow -j | jq -e '.fullscreen == 2'";
        }
      ];
    };
  };
}
