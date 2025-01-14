{ config, pkgs, ... }:

# TODO: include zshenv and bindkey from zshrc
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ogden";
  home.homeDirectory = "/home/ogden";
  xdg.configHome = "/home/ogden/.config/";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.zsh-powerlevel10k
    pkgs.tela-icon-theme
    pkgs.tela-circle-icon-theme
    pkgs.droidcam
    pkgs.easyeffects

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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
  };

  # PATH
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/dev/go/bin"
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
    dotDir = ".config/zsh";
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
      update = "sudo nixos-rebuild switch";
      vim = "nvim";

      diff = "diff --color";
      mp = "ncmpcpp";
      grep = "grep --color=auto";

      # zshmarks plugin
      g = "wd";
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
      ];
    };

    initExtra = ''
    bindkey "^p" history-beginning-search-backward
    bindkey "^n" history-beginning-search-forward

    # Edit command
    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line
  '';
  };

  # Enable fastfetch
  programs.fastfetch = {
      enable = true;
  };

  # Custom Rofi
  # programs.rofi = {
  #   enable = true;
  #   package = pkgs.rofi-wayland;
  #   plugins = with pkgs; [
  #     (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
  #   ];
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
