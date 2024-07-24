{ config, pkgs, lib, ... }:

let fanatecff = config.boot.kernelPackages.callPackage ./hid-fanatecff.nix {};
in
{
    system.stateVersion = "24.05";

    imports = [
        ./hardware-configuration.nix
        ./gnome.nix
        # ./xfce.nix
    ];

    # Select Kernel
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Fanatec Wheel
    boot.extraModulePackages = [ fanatecff ];
    services.udev.packages = [ fanatecff ];
    boot.kernelModules = [ "hid-fanatec" ];
    users.groups.games = {};                    # needed by udev rules

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable zram
    zramSwap.enable = true;
    # Enable fstrim
    services.fstrim.enable = true;

    # Enable networking
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    # Set your time zone
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

    # User
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" "games" "scanner" "lp" ];
    };

    programs.bash = {
        promptInit = "PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n\$ '";
        shellAliases = {
            nix-diff = "nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)";
        };
    };

    # Enable the X11 windowing system
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
        
        extraConfig.pipewire."92-low-latency" = {
            context.properties = {
                default.clock.rate = 48000;
            };
        };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate Flatpak
    services.flatpak.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
        vim
        git
        gnumake
        gcc
        fastfetch
        nvd

        game-devices-udev-rules     # gamepads
        linuxConsoleTools           # evdev-joystick for hid-fanatecff
    ];


    # Optimise Store
    nix.settings.auto-optimise-store = true;
}
