# Colors
_NC_     := \033[0m
_BOLD_   := \033[1m
_RED_    := \033[0;31m


# Macro to copy current configuration (only nix files) in the given directory
define cfg_copy
	@if [ -d "$(1)" ]; then \
		rsync -ar --out-format="%n" --delete-after src/ $(1); \
	else \
		echo -e "$(_RED_)error:$(_NC_) directory $(1) not found"; \
		exit 1; \
	fi
endef


# Macro to perform nix diff
CURR_GEN := $(shell ls -dv /nix/var/nix/profiles/system-*-link | tail -1)

define nix_diff
	@NEXT_GEN=$$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1); \
	if [ "$$NEXT_GEN" != "$(CURR_GEN)" ]; then \
		nvd diff "$(CURR_GEN)" "$$NEXT_GEN"; \
		echo -e "$(_BOLD_)you can restart to switch$(_NC_)"; \
	else \
		echo -e "$(_BOLD_)no new generation$(_NC_)"; \
	fi
endef


# make without argument will perform a test & clean
all: test clean


# Check admin rights
check-admin:
	@[ "$$EUID" -eq 0 ] || (echo -e "$(_RED_)error:$(_NC_) this command needs admin rights" && exit 1);


# Test the configuration locally
test:
	@mkdir -p test
	$(call cfg_copy,test)
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix


# Update the configuration & rebuild NixOS
install: check-admin
	$(call cfg_copy,/etc/nixos)
	nixos-rebuild boot
	$(call nix_diff)


# Clean local build
clean:
	nix-collect-garbage -d
	@if [ -d "test" ]; then rm -r test; fi


# Delete old generations
mr_proper: check-admin
	nix-collect-garbage -d
	nixos-rebuild switch


# Update NixOS
update: check-admin
	nix-channel --update
	nixos-rebuild boot
	 $(call nix_diff)


.PHONY: all test clean check-admin