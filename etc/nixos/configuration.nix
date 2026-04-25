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
      # TODO:
      # ./system-specialisation.nix
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
    open = false;
    nvidiaSettings = true;

    # latest
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "595.58.03";

    #   # detect hash version (replace step by step
    #   # sha256_64bit = lib.fakeHash;
    #   # sha256_aarch64 = lib.fakeHash;
    #   # openSha256 = lib.fakeHash;
    #   # settingsSha256 = lib.fakeHash;
    #   # persistencedSha256 = lib.fakeHash;


    # #  # Replace with the hashes nix gives you
    #   sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
    #   sha256_aarch64 = lib.fakeHash;
    #   openSha256 = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
    #   settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
    #   persistencedSha256 = lib.fakeHash;

    # #   # persistencedSha256 = lib.fakeSha256;
    # };
  };

  # maybe

  # Power and CPU management
  powerManagement = {
    enable = true;
    # cpuFreqGovernor = "schedutil";
  };

  # Setup desktop
  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
    
    displayManager = {


      # PLM: Plasma Login Manager
      plasma-login-manager = {
	enable = true;
      };
      # SDDM for kde
      # sddm = {
      #   package = lib.mkForce pkgs.kdePackages.sddm;
      #   enable = true;
      #   wayland = {
      #     enable = true;
      #     compositor = "kwin";
      #   };
      #   # extraPackages = [pkgs.catppuccin-sddm-corners];
      #   # theme = "catppuccin-sddm-corners";
      # };
    };

    desktopManager.plasma6.enable = true;
    # displayManager.defaultSession = "lxqt";

    # enable flatpak
    flatpak.enable = true;
  };

  # KDE brightness control
  hardware.i2c.enable = true;
  services.udev.packages = [pkgs.ddcutil];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight" "nct6775" "ntsync"];
  
  services.irqbalance.enable = true;

  # MAYBE: Cache DNS & speed up download speed
  # SEE: https://www.reddit.com/r/linux_gaming/comments/1pl0rxl/
  services.resolved.enable = false;

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      listen-address = "::1,127.0.0.1";
      # no-resolv = true;
      cache-size=10000;
      # port = 0;
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

  # Manage Razer devices
  hardware.openrazer = {
    enable = true;
    users = [ "ogden" ];
  };

  # Control & overclock your GPU
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;

  # Pipewire
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

    # extraConfig.pipewire = {
    #   "11-resample-quality" = {
    #     "stream.properties" = {
    #       "resample.quality" = 10;
    #     };
    #   };
    # };

    configPackages = [
      (pkgs.writeTextDir "share/pipewire/resample/11-quality.conf" ''
        stream.properties = {
          resample.quality = 10
        }
      '')
    ];
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


  # Firefox browser
  programs.firefox.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

    protontricks.enable = true;

    # Vanilla Steam
    # package = pkgs.steam.override {
    #   extraPkgs = (pkgs: with pkgs; [
    #     gamemode
    #     # additional packages...
    #     # e.g. some games require python3
    #   ]);
    # };

    # Millennium
    package = pkgs.millennium-steam.override {
      extraPkgs = (pkgs: with pkgs; [
        gamemode
	gamescope-wsi
        # additional packages...
        # e.g. some games require python3
	# noto-fonts
      ]);
    };

  };

  programs.kdeconnect.enable = true;
  # programs.hyprland.enable = true;

  # nixpkgs.config.permittedInsecurePackages = [
  # 	  "electron-35.7.5" # for obsidian 1.8.10 and legcord
  # ];

  # for realtek r8168 kernel module
  # nixpkgs.config.allowBroken = true;

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
	    libxshmfence
	    libunwind
	    gnutls
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

  # MAYBE: environment.interactiveShellInit
  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -l";
    ls = "ls --color=tty";
    update-channels = "nix-channel --update";
    update-flake = "cd /etc/nixos/ && nix flake update";
    update-system = "nixos-rebuild switch --flake /etc/nixos/#default";
    update-boot = "nixos-rebuild boot --flake /etc/nixos/#default";
    update-all = "update-channels && update-flake && update-system";
  };

  # Use NeoVim as default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    
    # Creative Studio
    audacity
    davinci-resolve
    krita


    # Disk & storage management
    smartmontools
    kdiskmark
    ncdu
    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.dolphin-plugins

    # Stress-test, tests and benchmarks
    stress-ng
    furmark


    # Sensors and system info
    clinfo
    lm_sensors
    lshw
    pciutils
    vulkan-tools

    # Networking and tools
    ethtool
    openssh
    openvpn
    wget

    # System
    appimage-run
    jq
    libunwind
    mesa-demos

    wezterm
    rofi

    # boot
    efibootmgr

    # Audio, media
    pulseaudio
    lxqt.pavucontrol-qt

    # Dev
    git
    xsel
    wl-clipboard
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

    # Manage Razer devices
    razergenie

    # Media
    playerctl

    nvidia-vaapi-driver
    ffmpeg
    qimgv
    mpc
    mpv
    # ncmpcpp

    # Cloud storage
    drive
    dropbox
    megasync

    obsidian
    pass
    zathura

    # Fonts
    freetype

    # Tools
    lact 

    # Find, locate, grep
    fd
    ripgrep
    file
    tree

    htop

    # Archieve and compression
    p7zip
    rar unrar
    unzip
    zstd

    qbittorrent
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
	  nerd-fonts.jetbrains-mono
	];


  # Disable unused KDE packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
    gwenview
    # okular
  ];

  # Allow all packages with proprietary licenses
  nixpkgs.config.allowUnfree = true;

  # Tweak Nix package manager and setup binary cache
  nix.settings = {
    auto-optimise-store = true;
    # enable flakes support
    experimental-features = [ "nix-command" "flakes" ];

    # To speed up system upgrade
    download-buffer-size = 524288000; # 500 MiB

    substituters = [
      "https://cache.nixos.org/"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

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
    # scheduler = "scx_lavd";
    # extraArgs = [
    #   "--performance"
    # ];
    # scx_cake
    scheduler = "scx_cake";
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

