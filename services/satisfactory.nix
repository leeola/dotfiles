# Placeholder, to be enabled next time i care.
{}: {
  users.users.satisfactory = {
    home = "/var/lib/satisfactory";
    createHome = true;
    isSystemUser = true;
    group = "satisfactory";
  };
  users.groups.satisfactory = {};
  networking = {
    firewall = {
      allowedTCPPortRanges = [ { from=7777; to=7827; } ];
      allowedTCPPorts = [ 5222 6666 27015 27016 8766 ];
      allowedUDPPorts = [ 5222 6666 15777 15000 27015 27016 8766 ];
      allowedUDPPortRanges = [ { from=7777; to=7827; } ];
    };
  };
  systemd.services.satisfactory = {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      ${pkgs.steamcmd}/bin/steamcmd \
        +login anonymous \
        +force_install_dir /var/lib/satisfactory/SatisfactoryDedicatedServer \
        +app_update 1690800 validate \
        +quit
      ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 /var/lib/satisfactory/SatisfactoryDedicatedServer/Engine/Binaries/Linux/UE4Server-Linux-Shipping
    '';
    script = ''
      /var/lib/satisfactory/SatisfactoryDedicatedServer/Engine/Binaries/Linux/UE4Server-Linux-Shipping FactoryGame -multihome 192.168.1.169
    '';
    serviceConfig = {
      Nice = "-5";
      Restart = "always";
      User = "satisfactory";
      WorkingDirectory = "/var/lib/satisfactory";
    };
    environment = {
      LD_LIBRARY_PATH="SatisfactoryDedicatedServer/linux64:SatisfactoryDedicatedServer/Engine/Binaries/Linux:SatisfactoryDedicatedServer/Engine/Binaries/ThirdParty/PhysX3/Linux/x86_64-unknown-linux-gnu/";
    };
  };
}
