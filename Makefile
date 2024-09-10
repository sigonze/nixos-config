all: test_gaming test_macbook

test_gaming:
	mkdir -p test
	rsync -avz ./ hosts/gaming/ test/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

test_macbook:
	mkdir -p test
	rsync -avz ./ hosts/macbook/ test/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

clean:
	nix-collect-garbage -d

gaming:
	rsync -av ./ hosts/gaming/ /etc/nixos/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild boot

macbook:
	rsync -av ./ hosts/macbook/ /etc/nixos/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild boot

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

update:
	nix-channel --update
	nixos-rebuild boot