{
  description = "Gideon's wallpaper collection";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    packages = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        wallpapers = pkgs.stdenvNoCC.mkDerivation {
          pname = "gideon-wallpapers";
          version = "1.0.0";

          src = self;

          installPhase = ''
            mkdir -p $out/share/wallpapers
            cp -r ./wallpapers/* $out/share/wallpapers/
          '';
        };

        default = self.packages.${system}.wallpapers;
      }
    );
  };
}
