{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  primaryUser = lib.findFirst (
    u: u.isNormalUser
  ) (throw "No normal user defined in config.users.users") (builtins.attrValues config.users.users);
  vpnConfigFile = "${primaryUser.home}/Documents/vpn/mullvad/mullvad.conf";
in
{
  imports = [
    inputs.avenir.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      zjstatus = inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
    })
    (final: prev: {
      hyprland = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system}.hyprland;
    })
    (final: prev: {
      hyprland-plugins =
        inputs.hyprland-plugins.packages.${prev.stdenv.hostPlatform.system}.hyprland-plugins;
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = "loose";

  systemd.services.networkmanager-wireguard-mullvad = {
    description = "Sync Mullvad WireGuard configuration with NetworkManager";
    after = [ "NetworkManager.service" ];
    wants = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      networkmanager
      coreutils
      gnugrep
      gawk
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      CONFIG="${vpnConfigFile}"
      STATE_DIR="/var/lib/networkmanager-wireguard"
      STATE_FILE="$STATE_DIR/mullvad.sha256"
      CON_NAME="mullvad"

      if [ ! -f "$CONFIG" ]; then
        if nmcli -t -f NAME connection show | grep -Fxq "$CON_NAME"; then
          echo "$CONFIG not found; removing connection $CON_NAME."
          nmcli connection delete "$CON_NAME" || true
          rm -f "$STATE_FILE"
        fi
        exit 0
      fi

      mkdir -p "$STATE_DIR"

      CURRENT_HASH=$(sha256sum "$CONFIG" | awk '{print $1}')
      SAVED_HASH=""
      if [ -f "$STATE_FILE" ]; then
        SAVED_HASH=$(cat "$STATE_FILE")
      fi

      CON_EXISTS=false
      if nmcli -t -f NAME connection show | grep -Fxq "$CON_NAME"; then
        CON_EXISTS=true
      fi

      if [ "$CON_EXISTS" = true ] && [ "$CURRENT_HASH" = "$SAVED_HASH" ]; then
        echo "WireGuard connection $CON_NAME is up to date."
        exit 0
      fi

      AUTOCONNECT="no"
      CON_WAS_ACTIVE=false
      if [ "$CON_EXISTS" = true ]; then
        CURRENT_AC=$(nmcli -g connection.autoconnect connection show "$CON_NAME" 2>/dev/null || echo "no")
        if [ -n "$CURRENT_AC" ]; then
          AUTOCONNECT="$CURRENT_AC"
        fi
        if nmcli -t -f NAME,STATE connection show --active | grep -Eq "^''${CON_NAME}:(activated|activating)"; then
          CON_WAS_ACTIVE=true
        fi
        nmcli connection delete "$CON_NAME" || true
      fi

      echo "Importing $CONFIG into NetworkManager..."
      nmcli connection import type wireguard file "$CONFIG"
      nmcli connection modify "$CON_NAME" \
        connection.autoconnect "$AUTOCONNECT" \
        ipv4.dns-priority -50 \
        ipv6.dns-priority -50

      if [ "$CON_WAS_ACTIVE" = true ] || [ "$AUTOCONNECT" = "yes" ]; then
        nmcli connection up "$CON_NAME" || true
      else
        nmcli connection down "$CON_NAME" || true
      fi

      echo "$CURRENT_HASH" > "$STATE_FILE"
      echo "Successfully configured $CON_NAME."
    '';
  };

  systemd.paths.networkmanager-wireguard-mullvad = {
    description = "Watch Mullvad VPN Config for NetworkManager WireGuard import";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = vpnConfigFile;
      Unit = "networkmanager-wireguard-mullvad.service";
    };
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.fstrim.enable = true;
  services.xserver.enable = true;

  services.displayManager = {
    autoLogin = {
      user = primaryUser.name;
      enable = false;
    };
    sddm = {
      enable = true;
      enableHidpi = true;
      theme = "${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners";
      extraPackages = [
        pkgs.catppuccin-sddm-corners
        pkgs.qt6.qt5compat
      ];
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "suspend";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };
  console.keyMap = "dvorak";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.libinput.enable = true;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };

  users.users.mkgz = {
    isNormalUser = true;
    description = "Kabeer";
    extraGroups = [
      "adbusers"
      "dialout"
      "docker"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "render"
      "uinput"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2d";
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    android-tools
    awscli2
    awww
    bat
    blender
    bluetui
    brightnessctl
    bun
    calibre
    curl
    delta
    distrobox
    distrobox-tui
    kdePackages.dolphin
    eza
    fastfetch
    fuse3
    fzf
    gcc
    gitFull
    git-lfs
    gitui
    glmark2
    gnumake
    gopls
    grimblast
    htop
    hyprviz
    inkscape
    inotify-tools
    jq
    jujutsu
    k9s
    kanshi
    kicad
    kitty
    kubectl
    lazyjj
    luarocks
    mise
    mpd
    mpremote
    mpv
    mupdf
    ncmpcpp
    neovim
    nixfmt
    nmap
    nodejs
    nushell
    obsidian
    opencode
    orca-slicer
    OVMF
    pandoc
    pavucontrol
    pciutils
    playerctl
    podman
    podman-compose
    powertop
    pulsemixer
    qemu
    redshift
    ripgrep
    rofi
    slurp
    socat
    sshfs
    ssm-session-manager-plugin
    starship
    swappy
    tailscale
    telegram-desktop
    texliveMedium
    unzip
    usbutils
    vim
    vscodium
    watchman
    wdisplays
    wget
    wireguard-tools
    wl-clipboard
    wlogout
    wlsunset
    wofi
    yazi
    yq
    yt-dlp
    zathura
    zed-editor
    zellij
    zig
    zoxide
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.lilex
    nerd-fonts.symbols-only
    nerd-fonts.victor-mono
  ];

  fonts.fontDir.enable = true;

  documentation.man.cache.enable = true;

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.fuse.userAllowOther = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  # provides a library path for unpatched binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libgcc
    stdenv.cc.cc
    stdenv.cc.cc.lib
    zlib
    glib
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.udisks2.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;
  networking.firewall.allowPing = false;

  system.stateVersion = "25.11";

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit (config.lib.stylix) colors;
  };

  home-manager.users."mkgz" = {
    imports = [ ../home/common.nix ];
  };

  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.fonts = with pkgs; {
    serif = {
      package = dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = dejavu_fonts;
      name = "DejaVu Sans";
    };
    emoji = {
      package = nerd-fonts.symbols-only;
      name = "Symbols Nerd Font Mono";
    };
  };
}
