{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86-64.linux;
    in
    {
      devShells.default = {
        buildInputs = with pkgs; [
          ccls

          go
          gopls
          gotools
          go-tools
          clang
        ];
      };
    };
}
