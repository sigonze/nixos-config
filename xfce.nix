{ config, lib, pkgs, ... }:

{
    # Enable XFCE Desktop Environment.
    services.xserver.desktopManager.xfce.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.displayManager.defaultSession = "xfce";

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
        blueman
        xfce.xfce4-docklike-plugin
        xfce.xfce4-whiskermenu-plugin
        papirus-icon-theme
        adw-gtk3
    ];
}