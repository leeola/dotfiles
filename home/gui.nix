{ prev, pkgs }:
{
  inherit prev;
  home.packages = with pkgs; [
    mosh
  ];
  home.file = {
    bar = "bar";
  };
}
