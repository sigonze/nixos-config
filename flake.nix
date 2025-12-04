{
    description = "NixOS System Configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    };
    outputs = { self, nixpkgs }: {
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
                    src/hosts/macbook/host-configuration.nix
                    src/configuration.nix
                ];
            };
        };
    };
}