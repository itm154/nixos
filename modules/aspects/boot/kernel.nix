{ den, inputs, ... }: {
  flake-file.inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  den.aspects.kernel-cachyos = variant: {
    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];

      boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-${variant}";
    };
  };

  # Might add other kernels
  # zen
  # xanmod
  # ...
}

# Available kernels
# Latest kernel, provides all LTO/CPU arch variants
# latest
# latest-x86_64-v2 (no binary cache)
# latest-x86_64-v3
# latest-x86_64-v4
# latest-zen4
# latest-lto
# latest-lto-x86_64-v2 (no binary cache)
# latest-lto-x86_64-v3
# latest-lto-x86_64-v4
# latest-lto-zen4

# LTS kernel, provides all LTO/CPU arch variants
# lts
# lts-x86_64-v2 (no binary cache)
# lts-x86_64-v3
# lts-x86_64-v4
# lts-zen4
# lts-lto
# lts-lto-x86_64-v2 (no binary cache)
# lts-lto-x86_64-v3
# lts-lto-x86_64-v4
# lts-lto-zen4

# Latest kernel with BORE scheduler, all LTO/CPU arch variants
# bore
# bore-x86_64-v2 (no binary cache)
# bore-x86_64-v3
# bore-x86_64-v4
# bore-zen4
# bore-lto
# bore-lto-x86_64-v2 (no binary cache)
# bore-lto-x86_64-v3
# bore-lto-x86_64-v4
# bore-lto-zen4

# Additional CachyOS kernel variants
# bmq
# bmq-lto (no binary cache)
# deckify
# deckify-lto (no binary cache)
# eevdf
# eevdf-lto (no binary cache)
# hardened
# hardened-lto (no binary cache)
# rc
# rc-lto (no binary cache)
# rt-bore
# rt-bore-lto (no binary cache)
# server
# server-lto (no binary cache)
