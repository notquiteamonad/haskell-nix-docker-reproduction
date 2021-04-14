{ ghc }:
let pkgs = import ./haskell-nix-pkgs.nix;
in
with pkgs;
haskell.lib.buildStackProject {
  inherit ghc;
  name = "server";
  # If you change buildInputs or nativeBuildInputs, make sure you also check the Docker image
  # doesn't need any additional libraries.
  buildInputs = [ pkgs.zlib ];
}
