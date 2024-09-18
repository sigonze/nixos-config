{ config, pkgs, ... }:

{
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable zram
    zramSwap.enable = true;
    
    # Enable fstrim
    services.fstrim.enable = true;

    # Enable networking
    networking.networkmanager.enable = true;

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

    # User
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
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

    # Configure printer
    services.printing.enable = true;
    hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
    };

    # Enable sound with pipewire
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate Flatpak
    services.flatpak.enable = true;

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Add aliases
    programs.bash.shellAliases = {
        nix-diff = "if [ $(ls -dv /nix/var/nix/profiles/system-*-link | wc -l) -gt 1 ]; then nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2); fi";
    };

    # Base apps
    programs.git.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        python3
        python3Packages.pip
        gnumake
        nvd
        fastfetch
        vscodium
    ];

    # Optimise Store
    nix.settings.auto-optimise-store = true;

    # Enable automatic upgrade
    # system.autoUpgrade.enable = true;

    # Enable Garbage Collector
    # nix.gc = {
    #     automatic = true;
    #     dates = "weekly";
    #     options = "--delete-older-than 7d";
    # };
}
