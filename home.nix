{ pkgs, ... }:
{
    home.packages = [
      pkgs.htop
      pkgs.tmux
      pkgs.spotify
      pkgs._1password
      pkgs.slack
      pkgs.blender
    ];

    # programs.git = {
    #     enable = true;
    #     includes = [ { path = ./.gitconfig; } ];
    # };

    home.file = {
        ".gitconfig".source = ./.gitconfig;
    };
}
