# Colors
_NC_     := \033[0m
_BOLD_   := \033[1m
_RED_    := \033[0;31m

FLAKE_DIR := .
FLAKE_SUM := $(shell sha256sum $(FLAKE_DIR)/flake.lock)


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
	nixos-rebuild dry-build --flake $(FLAKE_DIR)


# Clean local build
clean:
	nix-collect-garbage -d


# Delete old generations
mr_proper: check-admin
	nix-collect-garbage -d
	nixos-rebuild switch --flake $(FLAKE_DIR)


# Update NixOS
update:
	nix flake --extra-experimental-features "nix-command flakes" update --flake $(FLAKE_DIR)
	@UPDATED_FLAKE_SUM=$$(sha256sum $(FLAKE_DIR)/flake.lock); \
	if [ "$$UPDATED_FLAKE_SUM" != "$(FLAKE_SUM)" ]; then \
		echo -e "$(_BOLD_)Flake was updated$(_NC_)"; \
		sudo $(MAKE) rebuild; \
	else \
		echo -e "$(_BOLD_)No update$(_NC_)"; \
	fi


rebuild: check-admin
	nixos-rebuild boot --flake $(FLAKE_DIR)
	$(call nix_diff)


.PHONY: all test clean check-admin