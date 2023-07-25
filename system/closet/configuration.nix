# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
 

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lee = {
    isNormalUser = true;
    initialPassword = "eel";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    #  firefox
    #  thunderbird
    #];
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      /etc/nixos/ssh/authorized_keys  
    ];
  };
  programs.mosh.enable = true;
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    tmux
    helix
    kakoune
    vim
    htop
  ];

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

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

