{ config, pkgs, lib, extra-config, ... }:

{
    users.users = builtins.listToAttrs(
        map (user_name: {
            name = lib.toLower user_name;
            value = {
                isNormalUser = true;
                description = user_name;
                extraGroups = if builtins.elem (user_name) extra-config.sudoers
                            then [ "networkmanager" "wheel" ]
                            else [ "networkmanager" ];
            };
        }) extra-config.users
    );
}
