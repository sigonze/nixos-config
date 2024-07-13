# nixos-config

Store my NixOS configuration file

## Cheat sheet

Configuration testing
```
nixos-rebuild dry-build -I nixos-config=./configuration.nix
```

Configuration deployment
```
cp *.nix /etc/nixos
sudo nixos-rebuild switch
```

List generations
```
nixos-rebuild list-generations
```

Cleanup
```
sudo nix-collect-garbage -d
sudo nixos-rebuild switch
```

