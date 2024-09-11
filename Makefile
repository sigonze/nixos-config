include config.mk

all: test clean

check-host:
ifndef HOST
	$(error HOST not defined)
endif
	@test -d "hosts/$(HOST)" || (echo "Directory hosts/$(HOST) does not exist" && exit 1)

check-hwconf:
	@diff hosts/$(HOST)/hardware-configuration.nix /etc/nixos/hardware-configuration.nix > /dev/null; \
	if [ $$? -ne 0 ]; then \
		echo -e "\033[31mWARNING!\033[0m File hardware-configuration.nix has changed!"; \
		echo "It may BREAK your system if you do not know what you are doing."; \
		echo "Do you want to continue (y/n)?"; \
		read answer; \
		if [ "$$answer" != "y" ]; then \
			echo "Aborting."; \
			exit 1; \
		fi; \
	fi;

test: check-host
	mkdir -p test
	rsync -arvz --exclude=test --exclude=hosts --exclude=.git ./ hosts/$(HOST)/ test/ --delete-after
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

install: check-host check-hwconf
	rsync -arvz --exclude=test --exclude=hosts --exclude=.git ./ hosts/$(HOST)/ /etc/nixos/ --delete-after
	nixos-rebuild boot

clean:
	nix-collect-garbage -d

mr_proper:
	nix-collect-garbage -d
	nixos-rebuild boot

update:
	nix-channel --update
	nixos-rebuild boot

.PHONY: all test clean check-host check-hwconf