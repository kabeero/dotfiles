# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.unstable.linuxPackages;
  # boot.kernelModules = [ "uinput" ];

  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;

  networking.hostName = "navi";

  ## not compatible with NetworkManager
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable Desktop environments.
  # services.xserver.displayManager.lightdm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    autoLogin = {
      user = "mkgz";
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    # alsa.support32Bit = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Bluetooth: don't install bluez :)
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mkgz = {
    isNormalUser = true;
    description = "Kabeer";
    extraGroups = [
      "adbusers"
      "dialout"
      "input"
      "kvm"
      "networkmanager"
      "render"
      "wheel"
      "video"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # > https://wiki.hypr.land/Nix/Cachix/
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2d";
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    # (optional): hint Electron apps use Wayland
    NIXOS_OZONE_WL = "1";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search nixpkgs wget
  environment.systemPackages = with pkgs; [
    # gcc
    android-studio-full
    android-tools
    bat
    blender
    bluetui
    brightnessctl
    btop-rocm
    calibre
    cargo
    clang
    cmake
    curl
    delta
    distrobox
    distrobox-tui
    kdePackages.dolphin
    eza
    file
    fzf
    gitFull
    gitui
    git-lfs
    glmark2
    gnumake
    gopls
    grimblast
    htop
    # hyprlauncher
    # hyprshade
    # hypridle
    # hyprpanel
    # hyprpaper
    # hyprsysteminfo
    hyprviz
    imv
    inkscape
    inotify-tools
    jq
    jujutsu
    k9s
    kicad
    kitty
    kmonad
    lazyjj
    luarocks
    mediainfo
    mise
    mpd
    mpremote
    mpv
    mupdf
    ncmpcpp
    neovim
    nix-your-shell
    nixfmt
    nmap
    nushell
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    obsidian
    opencode
    OVMF
    pavucontrol
    pciutils
    pfetch
    playerctl
    podman
    podman-compose
    powertop
    pulsemixer
    qemu
    redshift
    ripgrep
    rofi
    showmethekey
    slurp
    socat
    sshfs
    ssm-session-manager-plugin
    starship
    swappy
    tailscale
    telegram-desktop
    thonny
    tigervnc
    tldr
    unzip
    usbutils
    vim
    virt-manager
    vscodium
    watchman
    wget
    wlogout
    wlsunset
    wl-clipboard
    wofi
    yazi
    yq
    yt-dlp
    zathura
    zellij
    zig
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.lilex
    nerd-fonts.symbols-only
  ];

  programs.fish.enable = true;
  # fish causes man cache rebuilding
  documentation.man.generateCaches = false;
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs here, NOT in environment.systemPackages
    ## mise: use nix plugin instead, since doesn't seem to be working 😥
    # bzip2
    # libffi
    # ncurses
    # openssl_legacy
    # readline
    # zlib
    libgcc
    stdenv.cc.cc.lib
  ];

  # wtf
  # environment.interactiveShellInit = ''
  #   ${pkgs.nix-your-shell}/bin/nix-your-shell --nom fish | source
  # '';
  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.udisks2.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # tailscaled
  services.tailscale.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;

  system.stateVersion = "25.11";

  # ╭──────────────────╮
  # │   home-manager   │
  # ╰──────────────────╯

  home-manager.users."mkgz" = import ./home.nix;
  home-manager.useGlobalPkgs = true; # share overlay'd pkgs
  ## to share flake `inputs` with home-manager modules : { config, pkgs, inputs, colors, ... }
  ## NOTE: this will be in your home.nix, not here
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit (config.lib.stylix) colors;
  };

  # enable stylix for home-manager
  stylix.enable = true;
  stylix.autoEnable = true;
  # > https://nix-community.github.io/stylix/configuration.html
  # > https://tinted-theming.github.io/tinted-gallery/
  # > https://github.com/SenchoPens/base16.nix (base16-schemes pkg)
  # > https://github.com/tinted-theming/schemes (not a nix pkg yet)
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/isotope.yaml"; # vibrant
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/pasque.yaml";
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/eris.yaml"; # dark
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/emil.yaml"; # light
  stylix.base16Scheme = "${inputs.tt-schemes}/base16/moonlight.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/ml/wallhaven-mlzgy1.jpg"; # blue space
    # url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png"; # cyan / orange / pink space
    # url = "https://w.wallhaven.cc/full/zx/wallhaven-zx26ly.png"; # lightbulb: orange / brown
    # url = "https://w.wallhaven.cc/full/gw/wallhaven-gw5k67.jpg"; # aurora: pink / green
    hash = "sha256-96EJVBDp7ltc21DiylcSbhULmzxgKK+14hwpXrLvi5Q=";
  };
  # generating a palette works OK, but seems to produce crazy combinations, completely unreadable
  # stylix.polarity = "light";
  # stylix.polarity = "dark";

  stylix.fonts = with pkgs; {
    serif = {
      package = dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = nerd-fonts.geist-mono;
      name = "GeistMono Nerd Font Mono";
    };

    emoji = {
      package = nerd-fonts.symbols-only;
      name = "Symbols Nerd Font Mono";
    };
  };

}
