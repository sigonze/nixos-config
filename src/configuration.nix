{ config, pkgs, lib, ... }:

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
    # services.fwupd.enable = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable firewall
    networking.firewall.enable = true;

    # Set your time zone
    time.timeZone = "Europe/Paris";

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
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Enable opengl drivers
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate Flatpak
    # services.flatpak.enable = true;

    # Enable AppImage
    programs.appimage = {
        enable = true;
        binfmt = true;
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Add aliases
    programs.bash.shellAliases = {
        nix_diff = "if [ $(ls -dv /nix/var/nix/profiles/system-*-link | wc -l) -gt 1 ]; then nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2); fi";
        # nix_update = "sudo sh -c \"nix flake update --flake /etc/nixos && nixos-rebuild switch --flake /etc/nixos\"";
        # nix_clean = "sudo sh -c \"nix-collect-garbage -d && nixos-rebuild switch --flake /etc/nixos\"";
    };

    # Base apps
    environment.systemPackages = with pkgs; [
        vim
        nvd
        fastfetch
        unrar-wrapper
    ];

    system.activationScripts.diff-gens = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nix ]}
      ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
    '';

    # Optimise Store
    nix.settings.auto-optimise-store = true;

    # Add Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Preserve space by disabling documentation
    documentation.nixos.enable = false;

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
