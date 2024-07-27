all:
	nixos-rebuild dry-build -I nixos-config=./configuration.nix

clean:
	nix-collect-garbage -d

install:
	[ -d /etc/nixos.bak ] && rm -rf /etc/nixos.bak || true
	mv /etc/nixos /etc/nixos.bak
	mkdir /etc/nixos
	cp -r * /etc/nixos
	nixos-rebuild boot

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

update:
	nix-channel --update
	nixos-rebuild boot