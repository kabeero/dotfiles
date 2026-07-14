# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # # e.g: pinned version of disko
    # "${
    #   builtins.fetchTarball {
    #     url = "https://github.com/nix-community/disko/archive/refs/tags/v1.13.0.tar.gz";
    #     sha256 = "03jz60kw0khm1lp72q65z8gq69bfrqqbj08kw0hbiav1qh3g7p08";
    #   }
    # }/module.nix"
    ./disko-config.nix
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

  networking.hostName = "fluo";

  # Pick only one of the below networking options.
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
    # options = "eurosign:e,caps:escape";
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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
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
      "uinput"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # > https://wiki.hypr.land/Nix/Cachix/
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
    # (optional): hint Electron apps use Wayland
    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # android-studio
    android-tools
    awscli2
    awww
    bat
    blender
    bluetui
    brightnessctl
    btop
    bun
    calibre
    claude-code
    curl
    delta
    distrobox
    distrobox-tui
    kdePackages.dolphin
    eza
    fzf
    gitFull
    # build failure 2026-01-25
    # gitu
    git-lfs
    gitui
    glmark2
    gnumake
    gopls
    grimblast
    gum
    htop
    # hyprlauncher
    # hyprshade
    hypridle
    hyprpanel
    hyprpaper
    hyprsysteminfo
    hyprviz
    inkscape
    inotify-tools
    jq
    jujutsu
    k9s
    kanshi
    kicad
    kitty
    kmonad
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
    virt-manager
    vscodium
    watchman
    wdisplays
    wget
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
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.lilex
    nerd-fonts.symbols-only
  ];

  # This links all your system fonts into /run/current-system/sw/share/X11/fonts, giving applications a static path to scan.
  fonts.fontDir.enable = true;

  programs.fish.enable = true;
  # fish causes man cache rebuilding
  documentation.man.cache.enable = true;
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libgcc
    stdenv.cc.cc.lib
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.udisks2.enable = true;

  services.kmonad = {
    enable = true;
    keyboards = {
      razerKB = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:6:1.1-event-kbd";
        config = builtins.readFile ./cfg/kmonad/config.kbd;
        extraGroups = [ "root" ];
        defcfg = {
          # generate the defcfg portion of the kmonad config dynamically?
          enable = true;
          allowCommands = true;
          fallthrough = true;
        };
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.enable = true;
  networking.firewall.allowPing = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # NOTE: not compatible with flakes
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

  # ╭──────────────────╮
  # │   home-manager   │
  # ╰──────────────────╯

  home-manager.users."mkgz" = import ./home.nix;
  # This saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
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
  # ayu-dark*, deep, grape, gruvbox-dark-hard* (meh), hipster-green, homebrew, horizon-dark* (!), isotope* (!)
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/isotope.yaml"; # vibrant
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/pasque.yaml"; # sahar
  stylix.base16Scheme = "${inputs.tt-schemes}/base16/eris.yaml"; # dark
  # stylix.base16Scheme = "${inputs.tt-schemes}/base16/emil.yaml"; # light
  stylix.image = pkgs.fetchurl {
    # url = "https://w.wallhaven.cc/full/ml/wallhaven-mlzgy1.jpg"; # blue space
    url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png"; # cyan / orange / pink space
    hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
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
      package = nerd-fonts.lilex;
      name = "Lilex Nerd Font Mono";
    };

    emoji = {
      package = nerd-fonts.symbols-only;
      name = "Symbols Nerd Font Mono";
    };
  };

}
