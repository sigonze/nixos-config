# nixos-config

Store my NixOS configuration file

## How to use

Test configurations

```
make test HOST=gaming
```
or
```
make test HOST=macbook
```

Cleanup generation

```
make clean
```

Configuration deployment is depending on host

```
sudo make install HOST=gaming
```
or

```
sudo make install HOST=macbook
```


Update packages

```
sudo make update
```

Cleanup old generations

```
sudo make mr_proper
```

## Fanatec Wheel support
Based on deleted package [PhilT/hid-fanatecff](https://github.com/PhilT/nixos-files/blob/f986b126212368a8eab702d2cb28f234e3b4230a/src/hid-fanatecff/default.nix)

To update to a new version hid-fanatecff, the file `drivers/hid-fanatecff/default.nix` has to be updated, as described:
1) update `version` using latest tag in [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/tags)
2) update `sha256` based on the latest tag (here 0.1.2 as example):
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.2.tar.gz
```
