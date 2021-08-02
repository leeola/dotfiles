{ lib, ... }:
  let
    mkTuple = lib.hm.gvariant.mkTuple;
  in
  {
    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        "sources" = [ (mkTuple [ "xkb" "us" ]) ];
        "xkb-options" = [ "caps:swapescape" ];
      };
    };
  }
