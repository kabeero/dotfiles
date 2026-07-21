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

  networking.hostName = "fluo";

  environment.systemPackages = with pkgs; [
    btop
    gum
    hypridle
    hyprpanel
    hyprpaper
    hyprsysteminfo
    virt-manager
  ];

  stylix.base16Scheme = "${inputs.tt-schemes}/base16/eris.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png";
    hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
  };

  stylix.fonts.monospace = {
    package = pkgs.nerd-fonts.lilex;
    name = "Lilex Nerd Font Mono";
  };

  home-manager.users."mkgz" = {
    imports = [ ./home.nix ];
  };
}
