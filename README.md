# server-mre

Example for [this thread](https://discourse.nixos.org/t/copying-only-certain-files-from-a-derivation-into-a-docker-image/12466/5)

## Ideal workflow

1. `nix-build nix/pkgs.nix -A cloud-run-image`
2. `docker load < result`
3. `docker run --rm -it server:latest sh`
