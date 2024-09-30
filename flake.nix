rec {
  description = "Simple yes/no TTY prompt";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;

      # The set of systems to provide outputs for
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });

      meta = {
        inherit description;
        homepage = "https://github.com/soyart/yn";
      };
    in

    {
      packages = forAllSystems ({ pkgs }: {
        # The C program
        default = pkgs.stdenv.mkDerivation {
          inherit version meta;

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

        # The Go program
        yn-go = pkgs.buildGoModule {
          inherit version meta;

          pname = "yn";
          src = ./.;
          vendorHash = null; # No Go dependencies, if there is, run `go mod vendor`
        };

        yn-rs = pkgs.rustPlatform.buildRustPackage {
          inherit version meta;

          pname = "yn";
          src = pkgs.lib.cleanSource ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };
      });

      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell
          {
            packages = with pkgs; [
              file

              nixd
              nixpkgs-fmt

              clang

              go
              gopls
              gotools
              go-tools

              cargo
              rustfmt
              rust-analyzer
            ];
          };
      });
    };
}
