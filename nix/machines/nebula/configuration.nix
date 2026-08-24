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

  networking.hostName = "nebula";

  environment.systemPackages = with pkgs; [
    btop
    gum
    kmonad
    virt-manager
  ];

  stylix.base16Scheme = "${inputs.tt-schemes}/base16/atelier-forest.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png";
    hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
  };

  stylix.fonts.monospace = {
    package = pkgs.nerd-fonts.iosevka;
    name = "Iosevka Nerd Font";
  };

  home-manager.users."mkgz" = {
    imports = [ ./home.nix ];
  };
}
