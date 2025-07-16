{
    description = "NixOS System Configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    };
    outputs = { self, nixpkgs }: {
    nixosConfigurations = {
            nix-gaming = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    hosts/gaming/hardware-configuration.nix
                    hosts/gaming/host-configuration.nix
                    src/configuration.nix
                ];
            };
            nix-mac = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    hosts/macbook/hardware-configuration.nix
                    hosts/macbook/host-configuration.nix
                    src/configuration.nix
                ];
            };
        };
    };
}