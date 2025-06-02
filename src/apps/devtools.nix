{ config, pkgs, lib, ... }:

with lib;
{
    options.apps = {
        devtools = mkOption {
            type = types.bool;
            default = false;
            description = "Install development tools";
        };
    };

    config = mkIf config.apps.devtools {
        programs.git.enable = true;

        environment.systemPackages = with pkgs; [
            gnumake
            (vscode-with-extensions.override { vscodeExtensions = with vscode-extensions; [
                    bbenoist.nix
                    mhutchie.git-graph
                    github.vscode-pull-request-github
                    # github.copilot
                ];
            })
            (python3.withPackages(ps: with ps; [
                requests
                pygobject3
            ]))
        ];
    };
}