{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./base-configuration.nix
        ./drivers/fanatec.nix
        ./desktop/gnome.nix
    ];

    # Hostname
    networking.hostName = "nix-gaming";

    # Configure keyboard variant
    services.xserver.xkb.variant = "oss";

    # Select Kernel
    # boot.kernelPackages = pkgs.linuxPackages_xanmod;
    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # boot.kernelPackages = pkgs.linuxPackages_lqx;
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enable opengl drivers
    hardware.opengl = {
        enable = true;
        driSupport = true;
        # driSupport32Bit = true;
    };

    # Change default governor
    # powerManagement.cpuFreqGovernor = "schedutil";

    # amd-pstate
    boot.kernelParams = [ "amd_pstate=active" ];

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };

    # Enable Gamemode
    programs.gamemode.enable = true;

    # Steam device
    hardware.steam-hardware.enable = true;

    # Rules to disable Dualshock touchpad
    services.udev.extraRules = ''
        # USB
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Bluetooth
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    # Update user group for fanatec wheel && gamemode
    users.users.nicolas.extraGroups =  [ "games" "gamemode" ];

    # Packages
    environment.systemPackages = with pkgs; [
        # game-devices-udev-rules     # gamepads
    ];

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
