{ config, pkgs, inputs, colors, ... }:

{
  imports = [
    ./monitors/awww
    ./monitors/kanshi
    ./terminal/kitty
    ./terminal/zellij
    ./tools/fish
    ./tools/git
    ./apps/zed.nix
    ./wm/hypr
    ./wm/stylix.nix
  ];

  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/${config.home.username}";
  home.packages = with pkgs; [ ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.btop.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  services.wlsunset = {
    enable = true;
    latitude = 33.68;
    longitude = -117.83;
  };
}
