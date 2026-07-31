# (WIP) NixOS configuration

## Install

1. Clone the repo

```sh
git clone https://github.com/itm154/nixos.git
```

2. Rebuild system

```sh
nix run .#hostname -- switch --impure
```

## Secure Boot

1. Turn off secure boot and reset keys to enter setup mode
2. On the next reboot in the rebuilt system, run:

```bash
sudo sbctl enroll-keys -m -f
```

3. Verify secure boot

```sh
sudo sbctl status # Setup mode should say disabled with a green checkmark
sudo sbctl verify # limine entry should be signed
```

_Do not sign the kernels, limine will throw up a checksum mismatch and panic_

## Quick commands

```sh
just --list
Available recipes:
    check              # Check flake outputs and syntax
    default            # List available commands
    home *args         # Rebuild and switch home manager configuration
    switch *args       # Rebuild and switch NixOS system
    update             # Update all flake inputs and regenerate flake.nix
    update-input input # Update a specific flake input and regenerate flake.nix
    vm                 # Run system inside VM
    write              # Rewrite flake.nix
```
