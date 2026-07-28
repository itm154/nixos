vm:
	nix run .#vm

vm-clean:
	rm -f ./*.qcow2
	nix run .#vm

check:
	nix flake check

write-flake:
	nix run .#write-flake

update-den:
	nix flake update den
	nix run .#write-flake

update-flake:
	nix flake update
	nix run .#write-flake
