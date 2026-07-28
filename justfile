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
	nix flake update
	nix run .#write-flake

# Update a specific flake input and regenerate flake.nix (usage: just update-input <input>)
update-input input:
	nix flake update {{input}}
	nix run .#write-flake

# Rebuild and switch NixOS system
os *args:
	nh os switch . -H {{hostname}} {{args}}

# Rebuild and switch Home Manager profile
home *args:
	nh home switch . -c {{username}} {{args}}
