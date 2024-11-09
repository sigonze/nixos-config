{ config, pkgs, lib, ... }:

{
    programs.dconf.profiles.user = {
        databases = [{
            settings = {
                "org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    enable-hot-corners = true;
                    gtk-theme = "adw-gtk3-dark";
                    icon-theme = "Adwaita";
                };
                "org/gnome/mutter" = {
                    check-alive-timeout = lib.gvariant.mkInt32 30000;
                    dynamic-workspaces = true;
                };
                "org/gnome/desktop/wm/preferences" = {
                    theme = "adw-gtk3-dark";
                };
                "org/gnome/settings-daemon/plugins/xsettings" = {
                    theme-name = "adw-gtk3-dark";
                };
                "org/gnome/nautilus/icon-view" = {
                    default-zoom-level="small-plus";
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
                "org/gnome/shell" = {
                    enabled-extensions = lib.gvariant.mkArray [
                        "caffeine@patapon.info"
                        "gsconnect@andyholmes.github.io"
                        "appindicatorsupport@rgcjonas.gmail.com"
                        "dash-to-dock@micxgx.gmail.com"
                    ];
                    favorite-apps = lib.gvariant.mkArray [
                        "org.gnome.Nautilus.desktop"
                        "org.gnome.Console.desktop"
                        "codium.desktop"
                        "org.mozilla.firefox.desktop"
                        "com.bitwarden.desktop.desktop"
                        "com.discordapp.Discord.desktop"
                        "com.valvesoftware.Steam.desktop"
                        "com.heroicgameslauncher.hgl.desktop"
                    ];
                };
            };
        }];
    };
}