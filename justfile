username := `whoami`
hostname := `hostname -s`

# List available commands
default:
	just --list

# Run system inside VM
vm:
	nix run .#vm

# Check flake outputs and syntax
check:
	nix flake check

# Update all flake inputs and regenerate flake.nix
update:
	nix run .#write-flake
	nix flake update

# Rewrite flake.nix for new inputs
flake:
	nix run .#write-flake

# Update a specific flake input and regenerate flake.nix (usage: just update-input <input>)
update-input input:
	nix run .#write-flake
	nix flake update {{input}}

# Rebuild and switch NixOS system
[arg("host", long="host")]
switch host=hostname *args:
	nix run .#{{host}} -- {{args}}

# Rebuild and switch Home Manager profile
[arg("user", long="user")]
home user=username *args:
	nix run .#{{user}} -- {{args}}
