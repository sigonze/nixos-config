# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    system.stateVersion = "24.05";

    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./gnome.nix
    ];

    # Xanmod kernel
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    
    # Enable zram
    zramSwap.enable = true;

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
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

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" "games" "scanner" "lp" ];
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Remove xterm
    services.xserver.excludePackages = [ pkgs.xterm ];

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "fr";
        variant = "oss";
    };

    # Configure console keymap
    console.keyMap = "fr";

    #services.displayManager.autoLogin = {
    #    enable = true;
    #    user = "nicolas";
    #};

    # Enable CUPS to print documents
    services.printing.enable = true;
    # Enable sane and airscan for scanner
    hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
    };

    # Enable sound with pipewire.
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

    # Programs
    programs.firefox.enable = true;
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [     
        vim
        git
        gnumake
        gcc
        #htop
        fastfetch
        #wget

        bitwarden
        discord
        vscodium
        mangohud
        protonup
        glxinfo
    ];

    # for protonup
    environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };

    # Garbage Collect
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
    };
}
