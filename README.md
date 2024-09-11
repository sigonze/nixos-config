# nixos-config

NixOS configuration (for my Gaming PC and my old Macbook Pro 11)


## How to use

### Configure your HOST (should be done only once)
Create a configuration file `config.mk` to specify your current host and put the files related to your host in the folder `hosts/<hostname>`.
Note: this file is optionnal if you specify the HOST for each command (for instance `HOST=gaming`)
Its content should be something like this:
```
ifndef HOST
	HOST=gaming
endif
```

Two example are avaible and may be reused.
For my Gaming PC:
```
cp config.gaming.mk config.mk
```

For my Macbook Pro:
```
cp config.macbook.mk config.mk
```

### Test the NixOS configuration
Just call the command:
```make```
It will perform a dry-run without modifying your configuration and cleanup the generated content after.

### Install the NixOS configuration
The command to call is:
```
sudo make install
```
It will install (the previous configuration will be replaced) and rebuild NixOS (reminder: better to test first).

Then you can use NixOS as usual.


## Additionnal Commands

### Update NixOS
This command is not mandatory, only more convenient to me.
```
sudo make update
```

### Cleanup old generations
Same here. This command is not mandatory, only more convenient to me.
```
sudo make mr_proper
```

### Perform a dry-run (only)
With the HOST specified in `config.mk` file
```
make test
```

Or for a specific host
```
make test HOST=gaming
```
or
```
make test HOST=macbook
```

### Perform a local clean (typically after test command)
```
make clean
```

### Install and rebuild NixOS for another HOST than the one specified in `config.mk` file.
Careful here your may break your installation. But since the update is applied after the restart, you norammly only have to choose the previous configuration to restart and to fix.
```
sudo make install HOST=gaming
```
or

```
sudo make install HOST=macbook
```
Note: if `hardware-configuration` file has changed it will ask for confirmation to insure it is not a mistake.


## Fanatec Wheel driver update
Based on deleted package [PhilT/hid-fanatecff](https://github.com/PhilT/nixos-files/blob/f986b126212368a8eab702d2cb28f234e3b4230a/src/hid-fanatecff/default.nix)

To update to a new version hid-fanatecff, the file `drivers/hid-fanatecff/default.nix` has to be updated, as described:
1) update `version` using latest tag in [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/tags)
2) update `sha256` based on the latest tag (here 0.1.2 as example):
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.2.tar.gz
```
