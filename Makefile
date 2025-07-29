# Colors
_NC_     := \033[0m
_BOLD_   := \033[1m
_RED_    := \033[0;31m
_GREEN_  := \033[0;32m
_YELLOW_ := \033[0;33m
_BLUE_   := \033[0;34m
_PURPLE_ := \033[0;36m
_CYAN_   := \033[0;36m
_WHITE_  := \033[0;37m


# Check if config.mk exists before including it
ifneq ("$(wildcard config.mk)","")
include config.mk
else
$(warning Configuration file config.mk does not exist)
endif


# Macro to copy current configuration (only nix files) in the given directory
define cfg_copy
	@if [ -d "$(1)" ]; then \
		rsync -ar --out-format="%n" --delete-after src/ hosts/$(HOST)/ $(1); \
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


# check if HOST has be provided
check-host:
ifndef HOST
	@echo -e "$(_RED_)error:$(_NC_) HOST variable not provided"; \
	exit 1
endif
	@test -d "hosts/$(HOST)" || (echo -e "$(_RED_)error:$(_NC_) directory hosts/$(HOST) does not exist" && exit 1)


# check if hardware-configuration has changed (should not in 99% of the cases)
check-hwconf:
	@diff hosts/$(HOST)/hardware-configuration.nix /etc/nixos/hardware-configuration.nix > /dev/null; \
	if [ $$? -ne 0 ]; then \
		echo -e "$(_YELLOW_)warning:$(_NC_) hardware-configuration.nix has changed!"; \
		echo -e "It may BREAK your system if you do not know what you are doing."; \
		echo -e "$(_BOLD_)Do you want to continue (y/N)?$(_NC_)"; \
		read answer; \
		if [ "$$answer" != "y" ]; then \
			echo "Abort"; \
			exit 1; \
		fi; \
	fi;


# Check admin rights
check-admin:
	@[ "$$EUID" -eq 0 ] || (echo -e "$(_RED_)error:$(_NC_) this command needs admin rights" && exit 1);


# Test the configuration locally
test: check-host
	@mkdir -p test
	$(call cfg_copy,test)
	nixos-rebuild dry-build -I nixos-config=test/configuration.nix


# Update the configuration & rebuild NixOS
install: check-admin check-host check-hwconf
	$(call cfg_copy,/etc/nixos)
	nixos-rebuild switch
#	$(call nix_diff)


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
	nixos-rebuild switch
#	 $(call nix_diff)


.PHONY: all test clean check-admin check-host check-hwconf