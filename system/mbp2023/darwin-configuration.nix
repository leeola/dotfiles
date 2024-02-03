{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    pkgs.tmux
    pkgs.helix
    ];

  users.users.lee = {
    home = "/Users/lee";
    # Seems this doesn't work for nix-darwin.
    # Ref:
    # - https://github.com/LnL7/nix-darwin/issues/779
    # - https://github.com/LnL7/nix-darwin/issues/361
    # - https://github.com/LnL7/nix-darwin/issues/328
    #
    # My solution then is to set it manually in OSX -_-
    shell = pkgs.fish;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Default shell, my primary shell.
  programs.fish.enable = true;
  # OSX Default shell! Important incase the mac gets reverted back to zsh and
  # i lose Nix and have to repair. Which is more annoying than it should be.
  programs.zsh.enable = true;  # default shell on catalina

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # # imports = [ <home-manager/nix-darwin> ];

  # # List packages installed in system profile. To search by name, run:
  # # $ nix-env -qaP | grep wget
  # environment.systemPackages =
  #   [ #pkgs.vim
  #     pkgs.fish
  #     pkgs.bash
  #     #pkgs.kakoune
  #     #pkgs.slack
  #     #pkgs.signal
  #   ];

  # # Use a custom configuration.nix location.
  # # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # # Auto upgrade nix package and the daemon service.
  # # services.nix-daemon.enable = true;
  # # nix.package = pkgs.nixUnstable;
  # # # NOTE: This isn't workin for some reason...
  # # # I've added the setting manually for now.
  # # nix.extraOptions = ''
  # #   experimental-features = nix-command flakes
  # # '';

  # # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = false;
  # programs.fish.enable = true;
  # #programs.bash.enable = true;

  # # Used for backwards compatibility, please read the changelog before changing.
  # # $ darwin-rebuild changelog
  # system.stateVersion = 4;
}

