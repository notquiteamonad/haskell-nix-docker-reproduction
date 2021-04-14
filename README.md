# haskell-nix-docker-reproduction

Minimal reproducible example for [this NixOS Discourse thread](https://discourse.nixos.org/t/copying-only-certain-files-from-a-derivation-into-a-docker-image/12466/5)

This repository enables building a static binary and wrapping that in a docker image using [Nix](https://nixos.org/).

## To build the docker image:

1. `nix-build nix/pkgs.nix -A cloud-run-image`
2. `docker load < result`
3. `docker run --rm -it server:latest server-prod`
