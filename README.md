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
sudo nixos-rebuild boot
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

## Fanatec Wheel support
Based on package [PhilT/hid-fanatecff](https://github.com/PhilT/nixos-files/blob/main/src/hid-fanatecff/default.nix)

For new version
1) update `version` based on latest tag [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/releases)
2) update `sha256`

How to get sha256
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.1.tar.gz
```
