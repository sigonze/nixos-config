all:
	nixos-rebuild dry-build -I nixos-config=./configuration.nix

clean:
	nix-collect-garbage -d

diff:
	alias nix-diff 2>/dev/null && nix-diff || true

rebuild:
	[ -d /etc/nixos.bak ] && rm -rf /etc/nixos.bak || true
	mv /etc/nixos /etc/nixos.bak
	mkdir /etc/nixos
	cp -r * /etc/nixos
	nixos-rebuild boot

install: rebuild diff

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

channel_update:
	nix-channel --update
	nixos-rebuild boot

update: channel_update diff
