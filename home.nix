{ plug_kak }: { pkgs, ... }:
{
    home.packages = [
      pkgs.htop
      pkgs.tmux
      pkgs.spotify
      pkgs._1password
      pkgs.slack
      pkgs.blender
    ];

    home.file = {
        ".gitconfig".source = ./.gitconfig;
        ".config/kak/kakrc".source = ./.config/kak/kakrc;
        ".config/kak/cuser.kak".source = ./.config/kak/cuser.kak;
        ".config/kak/plugins/plug.kak".source = plug_kak;
    };
}
