{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;

      pkgs = nixpkgs.legacyPackages.x86-64.linux;

      # The set of systems to provide outputs for
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
          inherit version;

          pname = "yn";
          src = ./.;

          buildPhase = ''
            cc main.c
          '';

          installPhase = ''
            mkdir -p $out/bin;
            cp a.out $out/bin/yn;
          '';
        };
      });

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          go
          gopls
          gotools
          go-tools

          clang
        ];
      };
    };
}
