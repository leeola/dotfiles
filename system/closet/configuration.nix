# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "closet";

  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings.bind_port = 7000;
  };

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

  users.users.lee = {
    isNormalUser = true;
    initialPassword = "eel";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJc8zqhshx+cSdrJqffeCKRGwbCI66rdxnpvK6wT1KqPuHaWQxL1nmiNk9n5ilP3sylGVZNCPYjerNLnF9cSnIJ8SpEb2MYRvdopBcjULw39b2msJG7SeRJPhy/htwGPEBPvNzGh5J1kgrSrdNoCZ/h83MvEAOdiEXULfgTm/1USD5fH9syEYbpiqNVESlLL5hGkQo8HvctgKW63UIwh33MOVCt/n5FTX0MAqBoHlKX7HIfZ/ySZ+WZTFzsYWq5JHKFdYuHZAvPXmBmNH54Qsto9CNHWi8vgIVcv8evZQtxO/jX4/hFDc+pg1HGjQtBIzNt/bav0WN/jnxmP7NoVrd lee@home"
    ];
  };
  users.users.veronica = {
    isNormalUser = true;
    extraGroups = [];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
  programs.mosh.enable = true;
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    git
    tmux
    helix
    kakoune
    vim
    htop
    parted
    snapraid
  ];

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

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    2049 # NFSv4
    5357 # samba-wsdd
    22000 # syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # samba-wsdd
    22000 21027 # syncthing
    53 # ? adguard?
  ];
  # Allowping and openFirewall seem to be required for Samba.. :sus:
  networking.firewall.allowPing = true;
  services.samba.openFirewall = true;

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export       192.168.1.48(rw,fsid=0,no_subtree_check)          192.168.1.57(rw,fsid=0,no_subtree_check)          192.168.1.218(rw,fsid=0,no_subtree_check)
    /export/gen01 192.168.1.48(rw,nohide,insecure,no_subtree_check) 192.168.1.57(rw,nohide,insecure,no_subtree_check) 192.168.1.218(rw,nohide,insecure,no_subtree_check)
    /export/gen02 192.168.1.48(rw,nohide,insecure,no_subtree_check) 192.168.1.57(rw,nohide,insecure,no_subtree_check) 192.168.1.218(rw,nohide,insecure,no_subtree_check)
  '';

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
    '';
    shares = {
      closet_general = {
        path = "/export";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "lee veronica";
      };
    };
  };

  services.plex = {
    enable = true;
    openFirewall = true;
    # TODO: Move appstate to a mut-friendly drive.
    # dataDir = "/mnt/gen01/appstate/plex";
    dataDir = "/var/lib/plex";
  };
  # For:
  # - Plex
  nixpkgs.config.allowUnfree = true;

  services.syncthing = {
    enable = true;
    dataDir = "/mnt/archive01/lee/sync";
    configDir = "/home/lee/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    user = "lee";
    group = "users";
    devices = {
      "desk" = { id = "RBZADNL-JLTLMTS-W6G5Z62-EZ3T4JP-N6SNIWM-6ZPJRRY-NIPRNIQ-ZZ2Y6Q6"; };
    };
    extraOptions = {
      options.globalAnnounceEnabled = false;
      options.relaysEnabled = false;
    };
    folders = {
      "blender_config" = {
        path = "/mnt/archive01/lee/blender_config";
        devices = [ "desk" ];
        versioning = {
          # docs: https://docs.syncthing.net/users/versioning.html#staggered-file-versioning
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "30758400"; # 356 days in seconds
          };
        };
      };
      "blender" = {
        path = "/mnt/archive01/lee/blender";
        devices = [ "desk" ];
        versioning = {
          # docs: https://docs.syncthing.net/users/versioning.html#staggered-file-versioning
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "30758400"; # 356 days in seconds
          };
        };
      };
      "krita" = {
        path = "/mnt/archive01/lee/krita";
        devices = [ "desk" ];
        versioning = {
          # docs: https://docs.syncthing.net/users/versioning.html#staggered-file-versioning
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "30758400"; # 356 days in seconds
          };
        };
      };
      "projects" = {
        path = "/mnt/archive01/lee/projects";
        devices = [ "desk" ];
      };
      "work" = {
        path = "/mnt/archive01/lee/work";
        devices = [ "desk" ];
      };
    };
  };
  systemd.timers.snapraid_sync= {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
    };
  };
  systemd.services.snapraid_sync = {
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.snapraid}/bin/snapraid sync";
    };
  };

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

