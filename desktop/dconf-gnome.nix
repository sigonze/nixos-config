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
                    icon-theme = "Adwaita";
                };
                "org/gnome/mutter" = {
                    check-alive-timeout = lib.gvariant.mkInt32 30000;
                    dynamic-workspaces = true;
                    edge-tiling = true;
                    experimental-features = ["variable-refresh-rate"];
                };
                "org/gnome/desktop/wm/preferences" = {
                    theme = "adw-gtk3-dark";
                };
                "org/gnome/desktop/wm/preferences" = {
                    button-layout = "appmenu:minimize,maximize,close";
                };

                # Extensions
                "org/gnome/shell" = {
                    enabled-extensions = [
                        "caffeine@patapon.info"
                        "gsconnect@andyholmes.github.io"
                        "appindicatorsupport@rgcjonas.gmail.com"
                        "dash-to-dock@micxgx.gmail.com"
                    ];
                };
                "org/gnome/shell/extensions/dash-to-dock" = {
                    always-center-icons = true;
                    apply-custom-theme = false;
                    autohide-in-fullscreen = false;
                    background-color = "rgb(0,0,0)";
                    background-opacity = 0.8;
                    click-action = "minimize-or-previews";
                    custom-background-color = true;
                    custom-theme-shrink = true;
                    dash-max-icon-size = lib.gvariant.mkUint32 48;
                    disable-overview-on-startup = true;
                    dock-fixed = false;
                    dock-position = "BOTTOM";
                    extend-height = false;
                    height-fraction = 0.9;
                    icon-size-fixed = false;
                    intellihide-mode = "MAXIMIZED_WINDOWS";
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
                "org/gnome/simple-scan" = {
                    paper-height=lib.gvariant.mkUint32 2970;
                    paper-width=lib.gvariant.mkUint32 2100;
                };
            };
        }];
    };
}