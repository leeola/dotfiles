# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  system,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.timeout = 25;
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  # boot.loader.grub.configurationLimit = 20;
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 10 1 1" {
  #     insmod part_msdos
  #     insmod chain
  #     set root='(hd1,gpt1)'
  #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  #   menuentry "Windows 10 0 1" {
  #     insmod part_msdos
  #     insmod chain
  #     set root='(hd0,gpt1)'
  #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  # '';

  networking.hostName = "desk"; # Define your hostname.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "default";
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # moonlander keyboard support.
  hardware.keyboard.zsa.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Disabled, because now i flash my keyboards via QMK, so no need for
  # software swap. Fancy.
  #
  # services.xserver.xkbOptions = "caps:caps";
  services.xserver.wacom.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  # Looks like this is required now to enable closed source driver:
  #     https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix#L261-L269
  hardware.nvidia.open = false;

  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = false;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;

  #hardware.nvidia.modesetting.enable = true;
  #services.xserver.displayManager.gdm.nvidiaWayland = true;

  # Not available in 22.11 it seems
  # services.dbus.packages = [ pkgs.gnome3.dconf ];
  # services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lee = {
    isNormalUser = true;
    initialPassword = "eel";
    extraGroups = [
      "wheel"
      "docker"
      "plugdev"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJc8zqhshx+cSdrJqffeCKRGwbCI66rdxnpvK6wT1KqPuHaWQxL1nmiNk9n5ilP3sylGVZNCPYjerNLnF9cSnIJ8SpEb2MYRvdopBcjULw39b2msJG7SeRJPhy/htwGPEBPvNzGh5J1kgrSrdNoCZ/h83MvEAOdiEXULfgTm/1USD5fH9syEYbpiqNVESlLL5hGkQo8HvctgKW63UIwh33MOVCt/n5FTX0MAqBoHlKX7HIfZ/ySZ+WZTFzsYWq5JHKFdYuHZAvPXmBmNH54Qsto9CNHWi8vgIVcv8evZQtxO/jX4/hFDc+pg1HGjQtBIzNt/bav0WN/jnxmP7NoVrd lee@home"
    ];
  };

  # Adding this due to the message:
  #   Failed assertions:
  #   - users.users.lee.shell is set to fish, but
  #   programs.fish.enable is not true. This will cause the fish
  #   shell to lack the basic nix directories in its PATH and might make
  #   logging in as that user impossible. You can fix it with:
  #   programs.fish.enable = true;
  programs.fish.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    firefox-bin
    git

    # Some utils that were handy to manually get multi-OS jiggery done.
    parted
    os-prober
    woeusb-ng

    # moonlander keyboard flashing tool
    wally-cli
    # qmk udev configuration necessary to flash qmk keyboards.
    qmk-udev-rules
    # qmk_cli tool
    qmk

    # KWallet<->SSH integration. Used by `programs.ssh.askPassword`
    kdePackages.ksshaskpass

    system.lutris
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.ssh.startAgent = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  environment.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  # TODO: Probably move to home configuration? /shrug
  services.syncthing = {
    enable = true;
    dataDir = "/home/lee/sync";
    configDir = "/home/lee/.config/syncthing";
    openDefaultPorts = true;
    user = "lee";
    group = "users";
    settings = {
      overrideDevices = true;
      overrideFolders = true;
      extraOptions = {
        options.globalAnnounceEnabled = false;
        options.relaysEnabled = false;
      };
      devices = {
        "closet" = {
          id = "C7H5SPI-OBTQKPO-W6JNSVV-JXPIKDS-A5M5ELB-LFQBPRX-K4YP32I-DIZMVQH";
        };
      };
      folders = {
        "blender_config" = {
          path = "/home/lee/.config/blender";
          devices = [ "closet" ];
        };
        "blender" = {
          path = "/home/lee/blender";
          devices = [ "closet" ];
        };
        "krita" = {
          path = "/home/lee/krita";
          devices = [ "closet" ];
        };
        "projects" = {
          path = "/home/lee/projects";
          devices = [ "closet" ];
        };
        "work" = {
          path = "/home/lee/work";
          devices = [ "closet" ];
        };
        "courses" = {
          path = "/home/lee/courses";
          devices = [ "closet" ];
        };
        "references" = {
          path = "/home/lee/references";
          devices = [ "closet" ];
        };
      };
    };
  };

  #
  # # Setup OpenVPN
  #
  # ## Usage
  #
  # Start the vpn:
  # ```
  # sudo systemctl start openvpn-officeVPN.service
  # ```
  #
  # Tools to debug:
  # ```
  # systemctl status openvpn-officeVPN.service
  # journalctl -xe
  #
  # ```
  #
  # ## Notes
  #
  # There's something exported config.. so i was getitng a failure indicating that
  # /etc/openvpn/update-resolv-conf didn't exist. I'm guessing it's because the config
  # inhibits Nix's ability to configure the proper resolve location?
  #
  # Regardless, the below environment.etc modification got it working. Which
  # seems to softlink the proper resolve location into the default path.
  services.openvpn.servers = {
    officeVPN = {
      config = ''config /home/lee/work/client.ovpn '';
      autoStart = false;
      updateResolvConf = true;
    };
  };
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
}
