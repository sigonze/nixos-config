# check if config.mk exists before including it
ifeq ("$(wildcard config.mk)","")
    $(warning Configuration file config.mk does not exist)
else
	include config.mk
endif

# define macro to copy current configuration (only nix files) is the specified directory
define cfg_copy
	@if [ -d "$(1)" ]; then \
		rsync -arvz --include='*.nix' --exclude='test/' --exclude='hosts/' --exclude='.git/' --include='*/' --exclude='*' ./ hosts/$(HOST)/ $(1) --delete-after; \
	else \
		echo "Directory $(1) not found"; \
		exit 1; \
	fi
endef

# make without argument will perform a test & clean
all: test clean

# check if HOST has be provided
check-host:
ifndef HOST
	$(error HOST not defined)
endif
	@test -d "hosts/$(HOST)" || (echo "Directory hosts/$(HOST) does not exist" && exit 1)

# check if hardware-configuration has change (99% of the cases => should not)
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
	$(call cfg_copy,test)
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix

install: check-host check-hwconf
	$(call cfg_copy,/etc/nixos)
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