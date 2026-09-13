{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.kmonad.nixosModules.default
  ];

  networking.hostName = "fluo";

  environment.systemPackages = with pkgs; [
    btop
    gum
    hypridle
    hyprpaper
    hyprsysteminfo
    kmonad
    # wayle
  ];

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  services.kmonad = {
    enable = true;
    keyboards = {
      razerKB = {
        device = "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:6:1.1-event-kbd";
        config = builtins.readFile ../../home/tools/kmonad/config.kbd;
        extraGroups = [ "root" ];
        defcfg = {
          enable = true;
          allowCommands = true;
          fallthrough = true;
        };
      };
    };
  };

  stylix.base16Scheme = "${inputs.tt-schemes}/base16/eris.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png";
    hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
  };

  # stylix.fonts.monospace = {
  #   package = pkgs.nerd-fonts.lilex;
  #   name = "Lilex Nerd Font Mono";
  # };

  # stylix.fonts.monospace = {
  #   package = pkgs.nerd-fonts.hack;
  #   name = "Hack Nerd Font Mono";
  # };

  stylix.fonts.monospace = {
    package = pkgs.nerd-fonts.iosevka;
    name = "Iosevka Nerd Font Mono";
  };

  home-manager.users."mkgz" = {
    imports = [ ./home.nix ];
  };
}
