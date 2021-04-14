{
  extras = hackage:
    { packages = { server = ./server.nix; }; };
  resolver = "lts-17.8";
  modules = [ ({ lib, ... }: { packages = {}; }) { packages = {}; } ];
  }