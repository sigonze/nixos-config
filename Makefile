all:
	nixos-rebuild dry-build -I nixos-config=./configuration.nix

clean:
	nix-collect-garbage -d

install:
	cp -r * /etc/nixos
	nixos-rebuild boot

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild switch