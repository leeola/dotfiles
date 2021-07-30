# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs-kak, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  #boot.loader.grub.extraEntries = ''
  #  menuentry "Windows 10" {
  #    chainloader (hd1,1)+1
  #  }
  #'';

  # Required to make bluetooth HSP/HFP mode work for my older PC.
  hardware.enableAllFirmware = true;

  networking.hostName = "spew"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fish
    nixpkgs-kak.legacyPackages.x86_64-linux.kakoune
    firefox-bin
    git
    xclip
    # Using this to swap between Bluetooth A2DP and HFP/HSP modes,
    # allowing AirPods Pro and JayBirds3 to be used with a mic.
    #
    # NOTE: At the time of writing, AirPods Pro didn't work with mic,
    # as it said HFP/HSP was "unavailable" in the dropdown. I'm hoping it's
    # due to an older bluetooth dongle, so i'm ordering a newer one. Fingers
    # crossed.
    pavucontrol
    killall
  ];

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  # Including opengl as part of my attempt to get Vulkan working,
  # no idea if this is needed... :sus:
  hardware.opengl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the ssh agent to make ssh-add work, remembering key passes.
  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
    # extraConfig = "
    #   load-module module-switch-on-connect
    # ";
    # configFile = pkgs.writeText "default.pa" ''
    #   load-module module-bluetooth-policy
    #   load-module module-bluetooth-discover
    #   # module fails to load with
    #   ##   module-bluez5-device.c: Failed to get device path from module arguments
    #   ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    #   # load-module module-bluez5-device
    #   # load-module module-bluez5-discover
    # '';
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.config.General = {
    # ControllerMode = "dual";
    # ControllerMode = "bredr";
    Enable = "Source,Sink,Media,Socket";
  };
  # services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:swapescape";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  # # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

  # Enable Docker.
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?


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

