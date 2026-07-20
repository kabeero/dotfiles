{
  config,
  pkgs,
  inputs,
  colors,
  ...
}:

{
  imports = [
    ./modules/monitors/awww
    ./modules/monitors/kanshi
    ./modules/terminal/kitty
    ./modules/terminal/zellij
    ./modules/tools/fish
    ./modules/tools/git
    ./modules/wm/hypr
  ]; 

  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/${config.home.username}";
  home.packages = with pkgs; [ ];

  # ╭──────────╮
  # │   apps   │
  # ╰──────────╯

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

  # # to prevent constant ~/.gtkrc-2.0 overwrite warnings
  # programs.plasma.configFile.kded5rc = {
  #   "Module-gtkconfig"."autoload" = false;
  # };

  # > https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # ╭────────────╮
  # │   stylix   │
  # ╰────────────╯

  stylix.targets.btop.colors.enable = true;
  stylix.targets.kitty.colors.enable = true;
  stylix.targets.kitty.enable = true;
}
