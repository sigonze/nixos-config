{ config, pkgs, ... }:

{
    # Configure keyboard variant
    services.xserver.xkb.variant = "oss";

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
