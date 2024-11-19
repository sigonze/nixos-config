{ config, pkgs,  lib, extra-config, ... }:
let
    extra-gnome-extensions = map(pkg: pkgs.gnomeExtensions."${pkg}") extra-config.gnome-extensions or [];
in
{
    imports = [
        ./dconf-gnome.nix
    ];

    # Enable the GNOME Desktop Environment
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # fix wifi question mark icon in gnome
    # networking.networkmanager.settings.connectivity.uri = "http://nmcheck.gnome.org/check_network_status.txt";

    # Debloat Gnome
    environment.gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-connections
        snapshot
        gnome-shell-extensions
        # baobab          # disk usage analyzer
        epiphany        # web browser
        totem           # video player
        yelp            # help viewer
        # evince          # document viewer
        geary           # email client
        gnome-calendar 
        gnome-characters
        gnome-clocks 
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-weather
        gnome-initial-setup
    ]);

    environment.systemPackages = with pkgs; [
        gnomeExtensions.dash-to-dock
        gnomeExtensions.appindicator
        gnomeExtensions.caffeine
        gnome-tweaks
        adw-gtk3
    ] ++ extra-gnome-extensions;

    programs.kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
    };
}