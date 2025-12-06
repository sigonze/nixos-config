{ config, pkgs, lib, ... }:

let
    target = import ./target.cfg;
in
{
    imports = [
        ./drivers
        ./desktop/gnome.nix
        ./apps
    ];

    # Bootloader
    boot.loader = {
        timeout = 3;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    # Enable fstrim
    services.fstrim.enable = true;

    # Enable zram
    zramSwap.enable = true;

    # Enable Firmware Service 
    services.fwupd.enable = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable firewall
    networking.firewall.enable = true;

    # Set your time zone
    time.timeZone = "Europe/Paris";
    # time.hardwareClockInLocalTime = true;

    # Select internationalisation properties
    i18n.defaultLocale = "fr_FR.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
    };

    # Change bash default prompt
    programs.bash.promptInit = "PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\] \\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\n\\$ '";

    # Enable the X11 windowing system
    services.xserver.enable = true;
    services.xserver.xkb.layout = "fr";

    # Remove xterm
    services.xserver.excludePackages = [ pkgs.xterm ];

    # Configure console keymap
    console.keyMap = "fr";

    # Enable sound with pipewire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        # alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Enable opengl drivers
    hardware.graphics = {
        enable = true;
        # enable32Bit = true;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate Flatpak
    services.flatpak.enable = true;

    # Enable AppImage
    # programs.appimage = {
    #     enable = true;
    #     binfmt = true;
    # };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Add aliases
    # programs.bash.shellAliases = {
    #     nix_diff = "$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1) nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2 | head -1)";
    #     nix_update = "sudo sh -c \"nix-channel --update && nixos-rebuild boot\" && nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)";
    #     nix_clean = "sudo sh -c \"nix-collect-garbage -d && nixos-rebuild switch\"";
    # };

    programs.bash.interactiveShellInit = ''
    function nix_diff() {
        # Get the most recent system profile link
        latest_profile=$(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)

        # Resolve the targets of both symlinks
        latest_profile_target=$(readlink -f "$latest_profile")
        current_system_target=$(readlink -f /run/current-system)

        if [[ "$latest_profile_target" == "$current_system_target" ]]; then
            # If the latest profile points to the current system's target
            previous_profile=$(ls -dv /nix/var/nix/profiles/system-*-link | tail -2 | head -1)
            nvd diff /run/current-system "$previous_profile"
        else
            # If not, compare the current system with the latest profile
            nvd diff /run/current-system "$latest_profile"
        fi
    }

    function nix_update() {
        sudo sh -c "nix-channel --update && nixos-rebuild boot"

        # Compare the current system with the latest profile
        nvd diff /run/current-system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
    }

    function nix_clean() {
        # Collect garbage and rebuild the system configuration
        sudo sh -c "nix-collect-garbage -d && nixos-rebuild switch"
    }
    '';

    # Base apps
    environment.systemPackages = with pkgs; [
        vim
        nvd
        fastfetch
        unrar-wrapper
    ];

    # Optimise Store
    nix.settings.auto-optimise-store = true;

    # Add Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Preserve space by disabling documentation
    documentation.nixos.enable = false;

    # Add ltunify
    # hardware.logitech.wireless.enable = true;

    # Enable automatic upgrade
    # system.autoUpgrade = {
    #     enable = true;
    #     dates = "weekly";
    # };

    # Enable Garbage Collector
    # nix.gc = {
    #     automatic = true;
    #     dates = "weekly";
    #     options = "--delete-older-than 30d";
    # };
}
