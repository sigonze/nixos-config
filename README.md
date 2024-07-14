# nixos-config

Store my NixOS configuration file

## Cheat sheet

Configuration testing
```
nixos-rebuild dry-build -I nixos-config=./configuration.nix
```

Configuration deployment
```
sudo cp -r * /etc/nixos
sudo nixos-rebuild switch
```

List generations
```
nixos-rebuild list-generations
```

Cleanup old generations
```
sudo nix-collect-garbage -d
sudo nixos-rebuild switch
```

Get sha256 for fanatec wheel
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.1.tar.gz
```
