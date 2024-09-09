{ config, pkgs, ... }:

{
    # Customize bashrc
    programs.bash = {
        promptInit = "PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\] \\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\n\\$ '";
        shellAliases = {
            nix-diff = "if [ $(ls -dv /nix/var/nix/profiles/system-*-link | wc -l) -gt 1 ]; then nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2); fi";
            bat = "bat -P";
        };
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
        vim
        bat
        nvd
        inxi
        pciutils
        glxinfo
        fastfetch
    ];
}