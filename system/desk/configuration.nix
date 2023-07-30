# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.timeout = 25;
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
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
  # NOTE: Not really sure the right combination of networkmanager nameserver settings to use.
  # I had to fight nameserver to update, so it was difficult to say what is needed or correct.
  # Ie repeatedly i could make a change here, such as disabling all of these, and nixos-switch
  # and then no change would be reflected on the resolv.conf.
  # Though, perhaps it actually is working and looking at resolv.conf is unrelated? :shrug.
  # Seems to be resolv.conf based on testing, though.
  # IMPORTANT: The only way i could get these things to show changes on resolv.conf was to toggle
  # .dns between `default` and `none`. Based on a small sample size of testing, that worked.
  networking.networkmanager.insertNameservers = [
    "192.168.1.169"
  ];
  networking.nameservers = [
    # Not sure why this is required, but if i leave this blank then `insertNameservers` also doesn't work,
    # and that one is the more important for ordering. See above `IMPORTANT:` on applying.
    "192.168.1.1"
  ];
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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

   #hardware.nvidia.modesetting.enable = true;
   #services.xserver.displayManager.gdm.nvidiaWayland = true;

  # Not available in 22.11 it seems
  # services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lee = {
    isNormalUser = true;
    initialPassword = "eel";
    extraGroups = [ "wheel" "docker" "plugdev" ];
    shell = pkgs.fish;
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
    kakoune
    firefox-bin
    git

    # Some utils that were handy to manually get multi-OS jiggery done.
    parted
    os-prober
    woeusb-ng

    # Get back my damn full screen terminal. Wtf Gnome Console?
    gnome.gnome-terminal

    # desktop look & feel
    gnome.gnome-shell-extensions
    matcha-gtk-theme

    # extensions
    # gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vitals
    # gnomeExtensions.sound-output-device-chooser
    # gnomeExtensions.fullscreen-notifications
    # gnomeExtensions.screenshot-tool
    # gjs # NOTE: seems to be a dependency of the prev Screenshot tool

    # xdg-desktop-portal
    # xdg-desktop-portal-wlr
    
    # moonlander keyboard flashing tool
    wally-cli
    # qmk udev configuration necessary to flash qmk keyboards.
    qmk-udev-rules
    # qmk_cli tool
    qmk
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
  # services.openssh.enable = true;

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
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    user = "lee";
    group = "users";
    devices = {
      "closet" = { id = "C7H5SPI-OBTQKPO-W6JNSVV-JXPIKDS-A5M5ELB-LFQBPRX-K4YP32I-DIZMVQH"; };
    };
    folders = {
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
    officeVPN  = {
      config = '' config /home/lee/work/client.ovpn '';
      autoStart = false;
      updateResolvConf = true;
    };
  };
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
}

