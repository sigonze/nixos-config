# nixos-config

Store my NixOS configuration file

## How to use

Configuration testing
```
make
```

Cleanup generation
```
make clean
```

Configuration deployment
```
sudo make install
```

Cleanup old generations
```
sudo make mr_proper
```

## Fanatec Wheel support
Based on package [PhilT/hid-fanatecff](https://github.com/PhilT/nixos-files/blob/main/src/hid-fanatecff/default.nix)

For new version
1) update `version` using latest tag in [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/tags)
2) update `sha256` based on the latest tag (here 0.1.1):
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.1.tar.gz
```
