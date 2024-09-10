all: test_gaming test_macbook

test_gaming:
	[ -d test ] && rm -rf test || true
	mkdir -p test
	rsync -av ./ test/ --exclude=test --exclude=hosts --exclude=.git
	rsync -av hosts/gaming/ test/
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

test_macbook:
	[ -d test ] && rm -rf test || true
	mkdir -p test
	rsync -av ./ test/ --exclude=test --exclude=hosts --exclude=.git
	rsync -av hosts/macbook/ test/
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

clean:
	nix-collect-garbage -d

gaming:
	rsync -av ./ /etc/nixos --exclude=test --exclude=hosts --exclude=.git
	rsync -av hosts/gaming/ /etc/nixos
	nixos-rebuild boot

macbook:
	rsync -av ./ /etc/nixos --exclude=test --exclude=hosts --exclude=.git
	rsync -av hosts/macbook/ /etc/nixos
	nixos-rebuild boot


mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

update:
	nix-channel --update
	nixos-rebuild boot