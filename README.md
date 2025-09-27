# nixos-config

NixOS configuration (for my Gaming PC and my old Macbook Pro 11)


## How to use

### Configure your HOST (should be done only once)
Create a configuration file `target.cfg` into `src` folder to specify your current host and put the files related to your host in the folder `src/hosts/<hostname>`.
Its content should be something like this:
```
gaming
```

Two example are avaible and may be reused.
For my Gaming PC:
```
cp target.gaming.cfg src/target.cfg
```

For my Macbook Pro:
```
cp target.macbook.cfg src/target.cfg
```

### Test the NixOS configuration
Just call the command:
```
make
```
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
With the HOST specified in `src/target.cfg` file
```
make test
```

### Perform a local clean (typically after test command)
```
make clean
```


## Fanatec Wheel driver

Based on deleted package [PhilT/hid-fanatecff](https://github.com/PhilT/nixos-files/blob/f986b126212368a8eab702d2cb28f234e3b4230a/src/hid-fanatecff/default.nix)

### Automatic update
From the root of the repository just call the python script `./UpdateVersionJson.py`.
It will check which is the latest release on [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/tags) and update the file `src/drivers/hid-fanatecff/version.json` if needed.

### Manual update
To update manually, the file `src/drivers/hid-fanatecff/version.json` has to be updated, as described:
1) update `version` using latest tag in [gotzl/hid-fanatecff](https://github.com/gotzl/hid-fanatecff/tags)
2) update `sha256` based on the latest tag (here 0.1.2 as example):
```
nix-prefetch-url --unpack https://github.com/gotzl/hid-fanatecff/archive/refs/tags/0.1.2.tar.gz
```
