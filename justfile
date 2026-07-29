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

# Update a specific flake input and regenerate flake.nix (usage: just update-input <input>)
update-input input:
	nix run .#write-flake
	nix flake update {{input}}

# Rebuild and switch NixOS system
switch *args:
	nh os switch . -H {{hostname}} {{args}}
	just home

# Rebuild and switch Home Manager profile
home *args:
	nh home switch . -c {{username}} {{args}}
