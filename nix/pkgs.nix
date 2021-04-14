let
  # Get nixpkgs
  sources = import ./sources.nix { };
  pkgs = import (fetchTarball sources.nixpkgs.url) {};

  # haskell.nix server build
  haskellNixPkgs = import ./haskell-nix-pkgs.nix;
  server = haskellNixPkgs.haskell-nix.project {
    src = haskellNixPkgs.haskell-nix.haskellLib.cleanGit {
      name = "server";
      src = ../.;
    };
    stack-sha256 = "0k000l07066pyps0gqh5qanhpk3kgghanmywcwcw3lpczxxanhsf";
    materialized = ./server.materialized;
    checkMaterialization = true;
  };
  
  # Static production build via musl
  server-prod-static =
    server.projectCross.musl64.hsPkgs.server.components.exes.server-prod.override {
      configureFlags = [
        "--disable-executable-dynamic"
        "--disable-shared"
        "--ghc-option=-optl=-pthread"
        "--ghc-option=-optl=-static"
        "--ghc-option=-optl=-L${pkgs.gmp6.override { withStatic = true; }}/lib"
      ];
    };
  builtStaticExecutable = pkgs.runCommand
    "server"
    { }
    "cp -r ${server-prod-static} $out";

  # Docker image for Cloud Run
  alpine = pkgs.dockerTools.pullImage {
    imageName = "alpine";
    imageDigest = "sha256:ec14c7992a97fc11425907e908340c6c3d6ff602f5f13d899e6b7027c9b4133a";
    sha256 = "08nmxp5zzy5qakqk621lmrzndiddjcpxfvpzyraf30jdp6ca528d";
    finalImageName = "alpine";
    finalImageTag = "3.13.4";
  };
  cloud-run-image = pkgs.dockerTools.buildImage {
    name = "server";
    tag = "latest";
    fromImage = alpine;
    fromImageName = "alpine";
    fromImageTag = "3.13.4";
    contents = "${builtStaticExecutable}";
  };
in
{ inherit server builtStaticExecutable cloud-run-image; }
