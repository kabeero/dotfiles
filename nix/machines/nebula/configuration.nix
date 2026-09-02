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

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit apps/games (like Steam)
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # does not work for vGPU passthru
    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # GPU passthrough to containers
  virtualisation.docker.rootless.enable = false;
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    docker-compose
    gum
    kmonad
    nvtopPackages.nvidia
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

  users.groups.media = {
    gid = 950;
  };

  users.users.media = {
    isSystemUser = true;
    uid = 950;
    description = "Media User";
    createHome = false;
    group = "media";
    extraGroups = [ "media" ];
  };
}
