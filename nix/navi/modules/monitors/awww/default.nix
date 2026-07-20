# ╭──────────╮
# │   awww   │
# ╰──────────╯

{ config, pkgs, ... }:

{
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
}
