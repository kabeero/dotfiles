# ╭──────────╮
# │   hypr   │
# ╰──────────╯

{ config, pkgs, inputs, ... }:

{
  imports = [ ./waybar.nix ];

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
      ## removed?
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      ## flash focus to the new active window
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprfocus
      ## merged
      # hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      # hypr-darkwindow.packages.${pkgs.stdenv.hostPlatform.system}.Hypr-DarkWindow
      # hyprlandPlugins.hypr-darkwindow
      # hyprlandPlugins.hypr-dynamic-cursors
      hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
    ];

    extraConfig = builtins.readFile ./hyprland.lua;

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
}
