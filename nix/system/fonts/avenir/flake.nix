{
  description = "Avenir font flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # This is the core derivation that packages the font
        avenir-font = pkgs.stdenv.mkDerivation {
          pname = "avenir-font";
          version = "1.0";

          # The source is our directory of .ttf files
          src = ./files;

          ## fc-cache can't see global /var/cache/fontconfig
          ## fontconfig is needed to build the font cache
          # nativeBuildInputs = [ pkgs.fontconfig ];

          # The install phase copies the fonts to the standard location
          installPhase = ''
            runHook preInstall
            install -d $out/share/fonts/truetype/avenir
            install -m 444 $src/* $out/share/fonts/truetype/avenir/
            runHook postInstall
          '';
        };
      in
      {
        # Expose the package for direct use, e.g., `nix build .#avenir`
        packages.default = avenir-font;
        packages.avenir = avenir-font;
      }) // {
        # An overlay allows other flakes to easily access this package
        overlays.default = final: prev: {
          avenir = self.packages.${final.system}.avenir;
        };

        # A NixOS module for easy system-wide installation
        nixosModules.default = { pkgs, ... }: {
          # This module adds the `avenir` package to the system's font packages
          # Import it into your home.nix modules[] config
          config.fonts.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.avenir ];
        };
      };
}

