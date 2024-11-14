{ config, pkgs, ... }:

{
    # hardware.facetimehd.enable = true;

    # Configure keyboard variant
    services.xserver.xkb.variant = "mac";

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
