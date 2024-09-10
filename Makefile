check-host:
ifndef HOST
	$(error HOST not defined)
endif
	@test -d "hosts/$(HOST)" || (echo "Directory hosts/$(HOST) does not exist" && exit 1)

test: check-host
	mkdir -p test
	rsync -avz ./ hosts/$(HOST)/ test/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

install: check-host
	rsync -av ./ hosts/$(HOST)/ /etc/nixos/ --exclude=test --exclude=hosts --exclude=.git --delete-after
	nixos-rebuild boot

clean:
	nix-collect-garbage -d

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

update:
	nix-channel --update
	nixos-rebuild boot

.PHONY: all test clean check-host