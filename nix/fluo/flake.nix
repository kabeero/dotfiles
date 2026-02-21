{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/3021884f525546d29972368d37452e753443834e";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    hy3 = {
      url = "github:outfoxxed/hy3?ref=master";
      # url = "github:outfoxxed/hy3?ref=hl0.53.0.1";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };

  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.fluo = nixpkgs.lib.nixosSystem {
        ## make flake inputs available to all nixos modules defined below
        specialArgs = { inherit inputs; };
        modules = with inputs; [
          {
            nixpkgs.overlays = [
                (final: prev: {
                    zjstatus = zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
                })
                (final: prev: {
                    hyprland = hyprland.packages.${prev.stdenv.hostPlatform.system}.hyprland;
                })
                (final: prev: {
                    hyprland-plugins = hyprland-plugins.packages.${prev.stdenv.hostPlatform.system}.hyprland-plugins;
                })
            ];
          }
          ./configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          # hyprland.homeManagerModules.default
          stylix.nixosModules.default
        ];
      };
    };
}
