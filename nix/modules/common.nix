{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.avenir.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.kmonad.nixosModules.default
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
      hyprland-plugins = inputs.hyprland-plugins.packages.${prev.stdenv.hostPlatform.system}.hyprland-plugins;
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.systemd.enable = true;
  security.tpm2.enable = true;

  networking.networkmanager.enable = true;

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
    fzf
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

  fonts.fontDir.enable = true;

  programs.fish.enable = true;
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

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.udisks2.enable = true;

  services.kmonad = {
    enable = true;
    keyboards = {
      razerKB = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:6:1.1-event-kbd";
        config = builtins.readFile ../home/tools/kmonad/config.kbd;
        extraGroups = [ "root" ];
        defcfg = {
          enable = true;
          allowCommands = true;
          fallthrough = true;
        };
      };
    };
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;

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
