let
  sources = import ./sources.nix { };
  haskellNix = import sources.haskellNix { };
  pkgs = import haskellNix.sources.nixpkgs-2009 haskellNix.nixpkgsArgs;
in
pkgs
