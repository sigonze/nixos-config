# Colors
_NC_     := \033[0m
_BOLD_   := \033[1m

FLAKE_DIR := /etc/nixos

FLAKE_SUM := $(shell sha256sum $(FLAKE_DIR)/flake.lock)

# Macro to copy current configuration (only nix files) in the given directory
define cfg_copy
	@if [ -d "$(1)" ]; then \
		rsync -ar --out-format="%n" --delete-after . $(1); \
	else \
		echo -e "$(_RED_)error:$(_NC_) directory $(1) not found"; \
		exit 1; \
	fi
endef

# Macro to perform nix diff
CURR_GEN := $(shell ls -dv /nix/var/nix/profiles/system-*-link | tail -1)

# make without argument will perform a test & clean
all: test clean

# Test the configuration locally
test:
	nixos-rebuild dry-build -I nixos-config=src/configuration.nix

# Update the configuration & rebuild NixOS
install:
	$(call cfg_copy,$(FLAKE_DIR))
	sudo $(MAKE) rebuild

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

rebuild:
	nixos-rebuild boot --flake $(FLAKE_DIR)
	nvd diff "$(CURR_GEN)" "$$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)"

.PHONY: all test clean