# check if config.mk exists before including it
ifeq ("$(wildcard config.mk)","")
	$(warning Configuration file config.mk does not exist)
else
	include config.mk
endif


# define macro to copy current configuration (only nix files) in the given directory
define cfg_copy
	@if [ -d "$(1)" ]; then \
		rsync -arvz --delete-after --include='*.nix' --exclude='test/' --exclude='hosts/' --exclude='.git/' --include='*/' --exclude='*' ./ hosts/$(HOST)/ $(1); \
	else \
		echo "Directory $(1) not found"; \
		exit 1; \
	fi
endef

# define a macro to perform nix diff
CURR_GEN=$(shell ls -dv /nix/var/nix/profiles/system-*-link | tail -1)

define nix_diff
	NEXT_GEN=$$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1); \
	if [ "$$NEXT_GEN" != "$(CURR_GEN)" ]; then \
		nvd diff "$(CURR_GEN)" "$$NEXT_GEN"; \
	else \
		echo "No new package installed"; \
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


# check if hardware-configuration has changed (should not in 99% of the cases)
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


# check admin rights
check-admin:
	@[ "$$EUID" -eq 0 ] || (echo "This command needs admin rights" && exit 1);


# test the configuration
test: check-host
	mkdir -p test
	$(call cfg_copy,test)
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix


# update the configuration & rebuild nixos
install: check-admin check-host check-hwconf
	$(call cfg_copy,/etc/nixos)
	nixos-rebuild boot
	$(call nix_diff)


# clean local build
clean:
	nix-collect-garbage -d
	@if [ -d "test" ]; then rm -r test; fi


# delete old generations
mr_proper: check-admin
	nix-collect-garbage -d
	nixos-rebuild boot


# update nixos
update: check-admin
	nix-channel --update
	nixos-rebuild boot
	$(call nix_diff)


.PHONY: all test clean check-admin check-host check-hwconf