{ pkgs, lib }:
{
  # All dev environment files to link
  files = {
    # Fish functions
    ".config/fish/functions/dev.fish".source = ../dev-envs/dev.fish;
    ".config/fish/functions/__dev_complete.fish".source = ../dev-envs/__dev_complete.fish;

    # Dev environment flake
    ".config/dev-envs/flake.nix".source = ../dev-envs/flake.nix;
    ".config/dev-envs/flake.lock".source = ../dev-envs/flake.lock;
  };
}
