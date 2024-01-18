{ config, pkgs, overlays, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "beat";
  home.homeDirectory = "/home/beat";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  nixpkgs.overlays = overlays;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    wget
    curl
    bat
    firefox
    chromium
    obsidian
    discord
    signal-desktop
    telegram-desktop
    slack
    zoom-us
    tmux
    cachix
    ydotool
    wl-clipboard
    
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnomeExtensions.pop-shell

    ripgrep
    fd
    emacs-unstable

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

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      
      enabled-extensions = [
        # "pop-shell@system76.com"
        "gnome-magic-window@adrienverge"
      ];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".local/share/gnome-shell/extensions/gnome-magic-window@adrienverge/extension.js".source = dotfiles/gnome-magic-window/extension.js;
    ".local/share/gnome-shell/extensions/gnome-magic-window@adrienverge/metadata.json".source = dotfiles/gnome-magic-window/metadata.json;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/beat/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "bah@posteo.de";
    userName = "Beat Hagenlocher";
    extraConfig = {
      core.sshCommand = "ssh -i ~/.ssh/id_rsa -F /dev/null";
      init.defaultBranch = "main";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "cp" = "cp -i";
      "h" = "history";
      "l" = "lla";
      "mv" = "mv -i";
      "rm" = "rm -i";
      "which" = "type -a";

      "grep" = "grep --color=auto";

      "gi" = "git init";
      "ga" = "git add";
      "gu" = "git restore --staged";
      "gs" = "git status -s -b";
      "gst" = "git status";
      "gb" = "git branch -a -v";
      "gl" = "git log --oneline --decorate --graph";
      "gcm" = "git commit -m";
      "gam" = "git add . && git commit -m";
      "gp" = "git push";
      "gf" = "git pull";
      "gF" = "git fetch";
      "gun" = "git rm --cached";
      "gcb" = "git checkout -b";
      "gsw" = "git switch";
      "gco" = "git checkout";
      "gra" = "git remote add";
      "grv" = "git remote --verbose";
      "gca" = "git commit --amend";
      "gcan" = "git commit --amend --no-edit";
      "gcl" = "git clone";
      "gd" = "git diff";
      "gsh" = "git stash";

      "nix-list" = "nix profile history --profile /nix/var/nix/profiles/system";
      "nix-rm-boot-entries" = "nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d";
      "nre" = "sudo nixos-rebuild switch --flake .";
      "nure" = "nix flake update && sudo nixos-rebuild switch --flake .";
      "nsh" = "nix shell";

      "nf" = "nix flake";
      "nfc" = "nix flake check";
      "nft" = "nix flake init --template ";
      "nfs" = "nix flake show";
      "nfu" = "nix flake update";
      "nb" = "nix build";
      "nd" = "nix develop";

      "da" = "direnv allow";
      "dr" = "direnv reload";

      "e" = "emacs";
      "c" = "code . &";
      
      "hm" = "home-manager";
      "hsw" = "home-manager switch --flake .";
      "reload" = ". ~/.bash_profile";
    };

    initExtra = ''
      md () {
        mkdir -p -- "$1" && cd -P -- "$1"
      } 

      freq () {
        history | cut -c8- | cut -d" " --fields=1"$1" | sort | uniq -c | sort -rn
      }

      gap () {
        git add . && git commit --message="$1" && git push 
      }
      gm () {
        git add "''${@:2}" && git commit --message="$1"
      }

      export PATH="$PATH:~/.config/emacs/bin"
      export PATH="$PATH:~/.emacs.d/bin"
      export EDITOR="emacs"
    '';
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

  programs.vscode = {
    enable = true;
    userSettings = {
      "workbench.colorTheme" = "Palenight (Mild Contrast)";
      "editor.fontFamily" = "'FiraCode Nerd Font', 'DroidSansMono', monospace";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.glyphMargin" = false;
      "editor.folding" = false;
      "editor.scrollbar.verticalScrollbarSize" = 3;
      "editor.scrollbar.horizontalScrollbarSize" = 3;
      "editor.bracketPairColorization.enabled" = true;
      "workbench.colorCustomizations" = {
        "editorBracketHighlight.foreground1" = "#5caeef";
        "editorBracketHighlight.foreground2" = "#dfb976";
        "editorBracketHighlight.foreground3" = "#c172d9";
        "editorBracketHighlight.foreground4" = "#4fb1bc";
        "editorBracketHighlight.foreground5" = "#97c26c";
        "editorBracketHighlight.foreground6" = "#abb2c0";
        "editorBracketHighlight.unexpectedBracket.foreground" = "#db6165";
      };
      "files.autoSave" = "onFocusChange";
      "editor.tabSize" = 2;
      "direnv.restart.automatic" = true;
      "terminal.integrated.enableMultiLinePasteWarning" = false;
      "explorer.confirmDelete" = false;
    };
    keybindings = [
      {
          "key" = "shift+alt+down";
          "command" = "editor.action.copyLinesDownAction";
          "when" = "editorTextFocus && !editorReadonly";
      }
      {
          "key" = "ctrl+shift+alt+down";
          "command" = "-editor.action.copyLinesDownAction";
          "when" = "editorTextFocus && !editorReadonly";
      }
      {
          "key" = "shift+alt+up";
          "command" = "editor.action.copyLinesUpAction";
          "when" = "editorTextFocus && !editorReadonly";
      }
      {
          "key" = "ctrl+shift+alt+up";
          "command" = "-editor.action.copyLinesUpAction";
          "when" = "editorTextFocus && !editorReadonly";
      }
      {
          "key" = "shift+alt+up";
          "command" = "-editor.action.insertCursorAbove";
          "when" = "editorTextFocus";
      }
      {
          "key" = "shift+alt+down";
          "command" = "-editor.action.insertCursorBelow";
          "when" = "editorTextFocus";
      }
      {
        "key" = "ctrl+shift+t";
        "command" = "workbench.action.terminal.split";
        "when" = "terminalFocus && terminalProcessSupported || terminalFocus && terminalWebExtensionContributedProfile";
      }
      {
        "key" = "ctrl+shift+5";
        "command" = "-workbench.action.terminal.split";
        "when" = "terminalFocus && terminalProcessSupported || terminalFocus && terminalWebExtensionContributedProfile";
      }
    ];
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;

      format = builtins.concatStringsSep "" [
        "$line_break"
        "$all"
      ];

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # package.disabled = true;
    };
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
  };
  programs.zoxide = {
    enable = true;
  };
  programs.fzf = {
    enable = true;
  };
}
