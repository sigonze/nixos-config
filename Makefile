# Colors
_NC_     := \033[0m
_BOLD_   := \033[1m

FLAKE_SUM := $(shell sha256sum $(CURDIR)/flake.lock)
CURR_GEN  := $(shell ls -dv /nix/var/nix/profiles/system-*-link | tail -1)

# make without argument will perform a test & clean
all: test clean

# Test the configuration locally
test:
	nix flake --extra-experimental-features "nix-command flakes" check $(CURDIR)

# Clean local build
clean:
	nix-collect-garbage -d

# Delete old generations
mr_proper:
	sudo nix-collect-garbage -d
	sudo nixos-rebuild switch --flake $(CURDIR)

# Install new configuration
install:
	sudo nixos-rebuild switch --flake $(CURDIR)
	nvd diff "$(CURR_GEN)" "$$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)"

# Update NixOS
update:
	@$(CURDIR)/UpdateVersionJson.py
	nix flake --extra-experimental-features "nix-command flakes" update --flake $(CURDIR)
	@UPDATED_FLAKE_SUM=$$(sha256sum $(CURDIR)/flake.lock); \
	if [ "$$UPDATED_FLAKE_SUM" != "$(FLAKE_SUM)" ]; then \
		echo -e "$(_BOLD_)Flake was updated$(_NC_)"; \
		$(MAKE) install; \
	else \
		echo -e "$(_BOLD_)No update$(_NC_)"; \
	fi

.PHONY: all test clean