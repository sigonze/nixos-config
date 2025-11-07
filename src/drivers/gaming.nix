{ config, pkgs, lib, ... }:
{
    options.hardware.gaming = {
        enable = lib.mkOption {
            type = with lib.types; bool;
            default = false;
            description = "Enable Gaming Device support";
        };
    };

    config = lib.mkIf config.hardware.gaming.enable {
        hardware.steam-hardware.enable = true;
        environment.systemPackages = with pkgs; [
            game-devices-udev-rules
        ];

        # Rules to disable Dualshock touchpad
        services.udev.extraRules = ''
            # USB
            ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
            ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
            # Bluetooth
            ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
            ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        '';
    };
}