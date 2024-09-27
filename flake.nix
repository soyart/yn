{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      homepage = "https://github.com/soyart/yn";

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
        # The C program
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

          meta = {
            inherit homepage;
            description = "Simple yes/no TTY prompt";
          };
        };

        # The Go program
        yn-go = pkgs.buildGoModule {
          inherit version;

          pname = "yn";
          src = ./.;

          meta = {
            inherit homepage;
            description = "Simple yes/no TTY prompt, in Go";
          };

          # No Go dependencies, if there is, run `go mod vendor`
          vendorHash = null;
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
