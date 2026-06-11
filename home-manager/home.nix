{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ogden";
  home.homeDirectory = "/home/ogden";
  xdg.enable = true;
  xdg.configHome = "/home/ogden/.config/";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

# NOTE: Maaaybe
    inputs.zen-browser.packages.${system}.default
    inputs.helium.packages.${system}.default

    ###
    terminal-colors
    iperf
    tinyxxd # drop-in replacement of ViM hex dump utility
    perlPackages.FileMimeInfo
    inxi
    libinput

    difftastic
    rmlint
    tree-sitter-grammars.tree-sitter-qmljs

    # KDE related
    kdePackages.kget
    kdePackages.qt6ct

    # Better application & window styles for KDE
    darkly
    klassy

    # Cursors
    oreo-cursors-plus
    layan-cursors

    # KDE applets & widgets
    kurve
    kara
    plasmusic-toolbar
    plasma-panel-colorizer

    # Steam & Proton
    protonplus
    nero-umu

    # MAYBE: For Affinity
    # wine
    # winetricks
    # dotnet-sdk
    
    # Socil & messaging
    mailspring # email client
    telegram-desktop
    legcord # Advanced Discord client

    zsh-powerlevel10k

    # droidcam
    easyeffects
    # krita
    inkscape

    yt-dlp
    twitch-chat-downloader
    video2x

    # FONTS
    nerd-fonts.symbols-only
    nerd-fonts.lilex

    font-awesome

    # TRY FONT
    b612
    andika
    karla
    public-sans

    # For Monster hunter meme
    # cinzel
    # MB for editors
    source-sans
    source-code-pro
    monaspace
    moralerspace

    # For Rofi to run processes nicely
    # Mostly needed to make separated instances in KDE System Monitor
    runapp

    # Spell checking and dictionaries
    nuspell
    hunspellDicts.en-us
    hunspellDicts.ru-ru

    # clojure test
    # clojure
    # leiningen
    # swift

    # JAVA
    # jdk

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ogden/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    GOPATH = "$HOME/dev/go";
    GOMODCACHE = "$HOME/dev/go/cache";

    CUDA_DISABLE_PERF_BOOST = 1;

    # Respect XDG user directories
    XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    XDG_TEMPLATES_DIR = "$HOME/Templates";
    XDG_PUBLICSHARE_DIR = "$HOME/";
    XDG_DOCUMENTS_DIR = "$HOME/Documents";
    XDG_MUSIC_DIR = "$HOME/Music";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_PROJECTS_DIR = "$HOME/Projects";
    XDG_VIDEOS_DIR = "$HOME/Videos";
  };

  # PATH
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/dev/go/bin"
    "$HOME/.cargo/bin"
  ];



  # Services
  services.mpd = {
    enable = true;
    musicDirectory = "/home/ogden/Music";
    extraConfig = ''
      bind_to_address "127.0.0.1"
      port "6600"
      # must specify one or more outputs in order to play audio!
      # (e.g. ALSA, PulseAudio, PipeWire), see next sections
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }

      auto_update	"yes"
    '';

    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };


  services.mpd-mpris.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    setOptions = [
      "autocd"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_IGNORE_SPACE"
    ];
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Use system powerlevel10k package
    plugins = [
    {
      name = "powerlevel10k-config";
      src = ./p10k;
      file = "p10k.zsh";
    }
    {
      name = "zsh-powerlevel10k";
      src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
      file = "powerlevel10k.zsh-theme";
    }
    ];

    shellAliases = {
      ls = "ls -F --color=auto --group-directories-first";
      ll = "ls -l --color=auto";
      dff = "df -h -t ext4 -t vfat";

      update = "sudo nixos-rebuild switch";
      vim = "nvim";

      diff = "diff --color";
      mp = "rmpc";
      grep = "grep --color=auto";

      # zshmarks plugin
      g = "wd";

      # home-manager
      hm-flake = "nix flake update --flake ~/.config/home-manager";
      hm-build = "home-manager switch --flake ~/.config/home-manager/#ogden";
      hm-update = "hm-flake && hm-build";
    };

    history.size = 3000;


    # Plugins with Antidote manager
    antidote = {
      enable = true;

      plugins = [
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zsh-users/zsh-history-substring-search kind:defer"

        "mfaerevaag/wd kind:defer"
        "zsh-users/zsh-completions"
      ];
    };

    initContent = ''
    # Hotkeys
    bindkey "^p" history-beginning-search-backward
    bindkey "^n" history-beginning-search-forward

    bindkey "^A" beginning-of-line
    bindkey "^E" end-of-line
    bindkey "^B" backward-char
    bindkey "^F" forward-char

    # MAYBE
    bindkey "^D" delete-char-or-list
    bindkey '^H' backward-delete-char
    bindkey '^W' backward-kill-word
    bindkey '^L' clear-screen
    bindkey '^V' quoted-insert
    bindkey "^T" transpose-chars
    bindkey "^U" kill-line
    # conflicts with Vterm
    # bindkey "^J" backward-word
    bindkey "^K" forward-word
    bindkey '^R' history-incremental-search-backward
    bindkey '^S' history-incremental-search-forward

    # Delete key
    bindkey "\e[3~" delete-char

    # Edit command (in $EDITOR)
    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line
  '';
  };

  # Enable dircolors support in shells
  programs.dircolors.enable = true;

  # Enable fastfetch
  programs.fastfetch = {
      enable = true;
  };

  # Custom client for YouTube
  programs.freetube = {
      enable = true;
      settings = {
        allowDashAv1Formats = true;
        baseTheme = "catppuccinMocha";
        checkForUpdates = false;
        defaultQuality = "1080";
      };
  };

  # Use Zed editor
  programs.zed-editor.enable = true;

  # # Use chromium fork
  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.helium;
  # };
  
  # Helix editor
  programs.helix.enable = true;

  # Use Emacs with some extra packages
  programs.emacs = {
    enable = true;
    package =
      (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages
      (epkgs: [
       # myModule
       epkgs.vterm
       epkgs.jinx
      ]);
  };

  # Enable Emacs daemon suited for GUI
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = "graphical";
  };

  # OBS with extra features and plugins
  # programs.obs-studio = {
  #   enable = true;

  #   # optional Nvidia hardware acceleration
  #   package = (
  #     pkgs.obs-studio.override {
  #       cudaSupport = true;
  #     }
  #   );

  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     obs-backgroundremoval
  #     obs-pipewire-audio-capture
  #     # obs-vaapi #optional AMD hardware acceleration
  #     # obs-gstreamer

  #     # input-overlay
  #     obs-tuna
  #     obs-vkcapture
  #   ];
  # };

  # Custom Rofi
  # programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  #   plugins = with pkgs; [
  #     (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
  #   ];
  # };

  programs.cava = {
    enable = true;
    settings = {
      general.framerate = 60;
      input.method = "pipewire";
      smoothing.noise_reduction = 88;
      # color = {
      #   background = "'#000000'";
      #   foreground = "'#FFFFFF'";
      # };
    };
  };

  # # Thunderbird - email client
  # programs.thunderbird = {
  #   enable = true;
  # };
  #
  # when needed
  # nixpkgs.config.allowUnfree = true;

  # programs.vscode = {
  #   enable = true;
  #   profiles.default.extensions = with pkgs.vscode-extensions; [
  #     # dracula-theme.theme-dracula
  #     vscodevim.vim
  #     yzhang.markdown-all-in-one
  #     betterthantomorrow.calva
  #   ];
  # };


  # Enable darkly theme
  qt.style.package = with pkgs; [ darkly-qt5 darkly ];
  qt.platformTheme.name = "qtct";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
