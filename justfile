username := `whoami`
hostname := `hostname -s`

# List available commands
default:
	just --list

# Run system inside VM
vm:
	-rm -f ./*.qcow2
	nix run .#vm

# Check flake outputs and syntax
check:
	nix flake check

# Rewrite flake.nix
write:
	nix run .#write-flake

# Update all flake inputs and regenerate flake.nix
update:
	nix run .#write-flake
	nix flake update

# Update a specific flake input and regenerate flake.nix
update-input input:
	nix run .#write-flake
	nix flake update {{input}}

# Rebuild and switch NixOS system
switch *args:
	nix run .#{{hostname}} -- switch {{args}}

# Rebuild and switch home manager configuration
home *args:
	nix run .#{{username}} -- switch {{args}}
