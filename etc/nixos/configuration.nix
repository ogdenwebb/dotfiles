# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # # Run unpatched binaries on Nix/NixOS  
      # ./nix-alien.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
	  hostName = "joy"; # Define your hostname.
	  useNetworkd = true;
  };
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "UTC";
  # time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/Kiev";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    # package = config.boot.kernelPackages.nvidiaPackages.latest;
  
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "580.82.09";

      # detect hash version (replace step by step
      # sha256_64bit = lib.fakeHash;
      # sha256_aarch64 = lib.fakeHash;
      # openSha256 = lib.fakeHash;
      # settingsSha256 = lib.fakeHash;
      # persistencedSha256 = lib.fakeHash;


    #  # Replace with the hashes nix gives you
    #  sha256_64bit = "sha256-Puz4MtouFeDgmsNMKdLHoDgDGC+QRXh6NVysvltWlbc=";
    #   # sha256_aarch64 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
    #   sha256_aarch64 = lib.fakeHash;
    #   openSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
    #   settingsSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
    #   persistencedSha256 = lib.fakeHash;

    #   # persistencedSha256 = lib.fakeSha256;
    # };
  };

  # for brithness control
  powerManagement.enable = true;

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];

      #desktopManager.cinnamon.enable = true;
      #displayManager.lightdm.enable = true;
    };
    
    displayManager = {
      sddm = {
	package = lib.mkForce pkgs.kdePackages.sddm;
        enable = true;
        wayland = {
	  enable = true;
	  compositor = "kwin";
	};
	# extraPackages = [pkgs.catppuccin-sddm-corners];
	theme = "catppuccin-sddm-corners";
      };
    };

    desktopManager.plasma6.enable = true;
    # desktopManager.cinnamon.enable = true;
    # desktopManager.lxqt.enable = true;
    # displayManager.defaultSession = "lxqt";

    # enable flatpak (for OBS and plugins)
    flatpak.enable = true;
  };

  # KDE brightness control
  hardware.i2c.enable = true;
  services.udev.packages = [pkgs.ddcutil];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight" "nct6775" "ntsync"];
  
  # Cache DNS & speed up download speed
  # SEE: https://www.reddit.com/r/linux_gaming/comments/1pl0rxl/
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      listen-address = "127.0.0.1";
      no-resolv = true;
      port = 0;
      server = [ "1.1.1.1" "1.0.0.1" ];
    };
  };

  systemd.services.dnsmasq.requires = ["network-online.target"];
  systemd.services.dnsmasq.after = ["network-online.target"];

  # fwupd is a simple daemon allowing you to update some devices' firmware
  services.fwupd = {
    enable = false;
    daemonSettings.DisabledPlugins = [ "test" "test_ble" "invalid" "bios" ];
  };

  # Control RGB devices
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd"; 
    server = { 
      port = 6742; 
    }; 
  };

  
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # systemWide = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  # FOR SYSTEM-WIDE PIPEWIRE
  # systemd.services.mpd.serviceConfig.SupplementaryGroups = [ "pipewire" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ogden = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "usb" "pipewire" "gamemode"];
    shell = pkgs.zsh;
    # try to use zsh without NixOS module (built-in)
    ignoreShellProgramCheck = true;

  #   packages = with pkgs; [
  #     tree
  #   ];
  };

  # for waydroid
  # virtualisation.waydroid.enable = true;
  # networking.firewall.interfaces."enp34s0".allowedTCPPorts = [ 67 53 ];

  programs.firefox.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };


  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

    package = pkgs.steam.override {
      extraPkgs = (pkgs: with pkgs; [
        gamemode
        # additional packages...
        # e.g. some games require python3
      ]);
    };

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.kdeconnect.enable = true;
  # programs.hyprland.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
	  "electron-35.7.5" # for obsidian 1.8.10 and legcord
  ];


  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ 
	  self.mpvScripts.mpris
	];
      };
      appimage-run = super.appimage-run.override {
        extraPkgs = p:
          with p; [
            at-spi2-core
            gsettings-desktop-schemas
            fuse3
            fuse
	    xorg.libxshmfence
	    libunwind
          ];
      };
    })
  ];


  # nixpkgs.config.cudaSupport = true;

  environment.shells = with pkgs; [ bash zsh ];
  environment = {
	  etc = {
		  "sysconfig/lm_sensors".text = ''
			  HWMON_MODULES="nct6775"
			  '';
	  };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # MAAAAYBE
  davinci-resolve
  nvidia-vaapi-driver

    # System
    # kitty
    appimage-run
    lm_sensors
    mesa-demos
    openssh
    openvpn
    pciutils
    rofi
    smartmontools
    wezterm
    wget
    jq
    libunwind

    # boot
    efibootmgr
    # scx.full

    # pulseaudio for tools
    pulseaudio
    lxqt.pavucontrol-qt

    # Dev
    git
    xsel
    wl-clipboard
    neovim 
    emacs

    gcc
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      # select Python packages here
      # pandas
      requests
      # pycryptodome
      pycryptodomex
      colorama
      pyqt6
    ]))

    go
    gopls

    rustc
    rustfmt
    rust-analyzer
    cargo
    cargo-binstall

    # Dev testing
    # clang
    # ccls
    # nim
    # nimlsp
    # nimble

    # GAMING
    mangohud
    protonup-ng
    protonup-qt

    # Media
    playerctl

    ffmpeg
    qimgv
    mpc
    mpv
    ncmpcpp

    # Userland
    drive
    dropbox
    megasync
    # telegram-desktop
    obsidian
    legcord
    pass
    zathura

    # Fonts
    #iosevka-bin

    # Tools
    fd
    htop
    ripgrep
    file
    tree
    p7zip
    rar unrar
    unzip

    ncdu

    audacity

    qbittorrent
    kdePackages.partitionmanager
    catppuccin-sddm-corners
    kdePackages.sddm-kcm
    kdePackages.filelight
  ];


  # FONTS
  fonts.packages = with pkgs; [
          # favorites
	  d2coding 
	  (iosevka-bin.override { variant = "SS10"; })
	  (iosevka-bin.override { variant = "Etoile"; })
	  (iosevka-bin.override { variant = "Aile"; })

	  # Other fonts
	  dejavu_fonts
	  fira
	  fira-code
	  # gentium # TODO: test
	  # liberation_ttf
	  noto-fonts
	  noto-fonts-cjk-sans
	  # office-code-pro
	  open-sans
	  roboto
	  # roboto-slab
	  # zilla-slab
	  # ubuntu-classic
	  # ubuntu-sans
	  # ubuntu-sans-mono

	  # emoji
	  noto-fonts-color-emoji

	  # CJK fonts
	  ipafont

	  # new
	  ibm-plex
	  inter
	  # geist-font
	  # go-font
	  lato
	  # rubik
	  # cantarell-fonts
	  # source-sans-pro

          # EXTRA
	  poppins
	  # lexend
	  # borg-sans-mono
	  # work-sans
	  # karla

	  nerd-fonts._0xproto
          nerd-fonts.droid-sans-mono
	];


  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    gwenview
    # okular
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "blender"
    "cuda_cudart"
    "cuda_cccl"
    "cuda_nvcc"
    "libnpp"
    "libcublas"
    "libcufft"

    "davinci-resolve"

    "dropbox"
    "megasync"
    "firefox-bin"
    "firefox-bin-unwrapped"
    "nvidia-x11"
    "nvidia-settings"
    "obsidian"
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run" 

    "rar"
    "unrar"
  ];

  nix.settings = {
    # enable flakes support
    experimental-features = [ "nix-command" "flakes" ];

    # To speed up system upgrade
    download-buffer-size = 524288000; # 500 MiB

    # MAYBE: Setting up CUDA Binary Cache
    # substituters = [
    #   "https://cuda-maintainers.cachix.org"
    # ];
    # trusted-public-keys = [
    #   "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    # ];
  };

  # nix-ld
  programs.nix-ld = {
    enable = true;
    # libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    # libraries = pkgs.steam-run.args.multiPkgs pkgs;
    libraries = with pkgs; [
	zlib
	zstd
	stdenv.cc.cc
	curl
	openssl
	attr
	libssh
	bzip2
	libxml2
	acl
	libsodium
	util-linux
	xz
	systemd
    ];
  };

  # MAYBE you need that for pinetry
  # services.pcscd.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    pinentryPackage = pkgs.pinentry-qt;
  };

  #
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [
      "--performance"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # For Droidcam
  # Virtual cam settings: see https://wiki.nixos.org/wiki/OBS_Studio#Using_the_Virtual_Camera
  #boot.extraModulePackages = with config.boot.kernelPackages; [
  #  v4l2loopback
  #];
  #boot.extraModprobeConfig = ''
  #  options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  #'';
  security.polkit.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 27015 27036 ];
  networking.firewall.allowedUDPPorts = [ 27015 27031 27032 27033 27034 27035 27036 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

