{ config, pkgs, lib, ... }:

let fanatecff = config.boot.kernelPackages.callPackage ./hid-fanatecff.nix {};
in
{
    system.stateVersion = "24.05";

    imports = [
        ./hardware-configuration.nix
        ./gnome.nix
    ];

    # Select Kernel
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # Change default governor
    powerManagement.cpuFreqGovernor = "schedutil";

    # Fanatec Wheel
    boot.extraModulePackages = [ fanatecff ];
    services.udev.packages = [ fanatecff ];
    boot.kernelModules = [ "hid-fanatec" ];
    users.groups.games = {};                    # needed by udev rules

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable zram
    zramSwap = {
        enable = true;
        priority = 100;
    };
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };
    
    # Enable fstrim
    services.fstrim.enable = true;

    # Enable networking
    networking.hostName = "nixos";
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
        extraGroups = [ "networkmanager" "wheel" "games" "scanner" "lp" ];
    };

    programs.bash = {
        promptInit = "PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\] \\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\n\\$ '";
        shellAliases = {
            nix-diff = "if [ $(ls -dv /nix/var/nix/profiles/system-*-link | wc -l) -gt 1 ]; then nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2); fi";
            bat = "bat -P";
            # fastfetch="stat --format=\"Installation Date : %w\" / | cut -d\".\"  -f1; fastfetch;";
        };
    };

    # Enable the X11 windowing system
    services.xserver = {
        enable = true;
        # Configure keymap
        xkb = {
            layout = "fr";
            variant = "oss";
        };
    
        # Remove xterm
        excludePackages = [ pkgs.xterm ];
    };

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
        # alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate Flatpak
    services.flatpak.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
        vim
        bat
        git
        gnumake
        gcc
        fastfetch
        nvd
        inxi
        pciutils
        glxinfo

        game-devices-udev-rules     # gamepads
        linuxConsoleTools           # evdev-joystick for hid-fanatecff

        vscodium
    ];

    # Optimise Store
    nix.settings.auto-optimise-store = true;

    # NixOS version diff
    system.activationScripts.report-changes = ''
        if [ $(ls -dv /nix/var/nix/profiles/system-*-link | wc -l) -gt 1 ]; then
            PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
            nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
        fi;
    '';

    # Enable automatic upgrade
    # system.autoUpgrade.enable = true;

    # Enable Garbage Collector
    # nix.gc = {
    #     automatic = true;
    #     dates = "weekly";
    #     options = "--delete-older-than 7d";
    # };
}
