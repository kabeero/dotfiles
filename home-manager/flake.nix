{
  description = "Home Manager configuration of mkgz";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # > https://github.com/hyprwm/hyprland-plugins
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      homeConfigurations."mkgz" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        # Specify your home configuration modules here, for example, the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs to pass through arguments to home.nix
        extraSpecialArgs = {
            inherit inputs;
        };
      };
    };
}
