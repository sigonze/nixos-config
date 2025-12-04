{
    description = "NixOS System Configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixos-hardware.url = "github:nixos/nixos-hardware/master";
    };
    outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations = {
            nix-gaming = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    src/hosts/gaming/host-configuration.nix
                    src/configuration.nix
                ];
            };
            macbook = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    nixos-hardware.nixosModules.apple-macbook-pro-11-1
                    src/hosts/macbook/host-configuration.nix
                    src/configuration.nix
                ];
            };
        };
    };
}