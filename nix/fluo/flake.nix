{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # > https://github.com/hyprwm/hyprland-plugins
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    hy3.url = "github:outfoxxed/hy3?ref=master";
    # hy3.url = "github:outfoxxed/hy3?ref=hl0.53.0.1";
    hy3.inputs.hyprland.follows = "hyprland";

  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.fluo = nixpkgs.lib.nixosSystem {
      ## make flake inputs available to all nixos modules defined below
      specialArgs = { inherit inputs; } ;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        # hyprland.homeManagerModules.default
      ];
    };
  };
}
