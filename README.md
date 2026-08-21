# itm154's NixOS configuration

## Install

1. Install the base NixOS system, enable flakes and nix commands

2. Clone the repo

```sh
git clone https://github.com/itm154/nixos.git
```

3. Rebuild system

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
    boot *args         # Rebuild and add to boot menu
    check              # Check flake outputs and syntax
    default            # List available commands
    switch *args       # Rebuild and switch system
    update             # Update all flake inputs and regenerate flake.nix
    update-input input # Update a specific flake input and regenerate flake.nix
    vm                 # Run current configuration inside a VM
    write              # Rewrite flake.nix
```
