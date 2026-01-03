{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule {
  pname = "hypr-i3-move";
  version = "0.1.0";

  src = ./.;

  vendorHash = null;
  # vendorHash = pkgs.lib.fakeHash; # Run once, then replace with actual hash

  # Or if you have a go.mod file:
  # vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  meta = {
    description = "hypr-i3-move";
    license = pkgs.lib.licenses.mit;
  };
}
