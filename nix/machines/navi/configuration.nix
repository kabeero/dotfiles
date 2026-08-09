{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "navi";

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  services.desktopManager.plasma6.enable = true;

  # libvirtd daemon with KVM/QEMU support
  programs.virt-manager.enable = true;  # virt-manager GUI
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;          # saves space by only building host architecture support
      runAsRoot = true;
      swtpm.enable = true;              # enables TPM 2.0 emulation (required for Windows 11 VMs)
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    android-studio-full
    btop-rocm
    cargo
    clang
    cmake
    fastfetch
    file
    gvisor
    imv
    mediainfo
    nix-your-shell
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
    showmethekey
    thonny
    tigervnc
    tldr
    tree
  ];

  stylix.base16Scheme = "${inputs.tt-schemes}/base16/moonlight.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/ml/wallhaven-mlzgy1.jpg";
    hash = "sha256-96EJVBDp7ltc21DiylcSbhULmzxgKK+14hwpXrLvi5Q=";
  };

  stylix.fonts.monospace = {
    package = pkgs.nerd-fonts.geist-mono;
    name = "GeistMono Nerd Font Mono";
  };

  home-manager.users."mkgz" = {
    imports = [ ./home.nix ];
  };
}
