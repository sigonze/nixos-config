{ config, pkgs, lib, ... }:

{
    programs.dconf.profiles.user = {
        databases = [{
            settings = {
                # Gnome
                "org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    enable-hot-corners = true;
                    gtk-theme = "adw-gtk3-dark";
                    # icon-theme = "Papirus-Dark";
                };
                "org/gnome/mutter" = {
                    check-alive-timeout = lib.gvariant.mkUint32 30000;
                    dynamic-workspaces = true;
                    edge-tiling = true;
                    experimental-features = ["variable-refresh-rate"];
                };
                "org/gnome/desktop/wm/preferences" = {
                    button-layout = "appmenu:minimize,maximize,close";
                };
                "org/gnome/desktop/peripherals/keyboard" = {
                    numlock-state = true;
                };

                # Extensions
                "org/gnome/shell" = {
                    enabled-extensions = [
                        "caffeine@patapon.info"
                        "gsconnect@andyholmes.github.io"
                        "appindicatorsupport@rgcjonas.gmail.com"
                        "dash-to-dock@micxgx.gmail.com"
                    ];
                    favorite-apps = [
                        "org.gnome.Nautilus.desktop"
                        "org.gnome.Console.desktop"
                        "codium.desktop"
                        "firefox.desktop"
                        "bitwarden.desktop"
                        "discord.desktop"
                        "steam.desktop"
                        "com.heroicgameslauncher.hgl.desktop"
                    ];
                };
                "org/gnome/shell/extensions/dash-to-dock" = {
                    background-color = "rgb(0,0,0)";
                    background-opacity = 0.8;
                    custom-background-color = true;
                    custom-theme-shrink = true;
                    disable-overview-on-startup = true;
                    running-indicator-style = "DOTS";
                    show-trash = false;
                    transparency-mode = "FIXED";
                };

                # Applications
                "org/gnome/nautilus/icon-view" = {
                    default-zoom-level="small-plus";
                };
                "org/gnome/TextEditor" = {
                    indent-style = "space";
                    restore-session = false;
                    show-line-numbers = true;
                    show-map = true;
                    spellcheck = false;
                    tab-width = lib.gvariant.mkUint32 4;
                    wrap-text = false;
                };
            };
        }];
    };
}