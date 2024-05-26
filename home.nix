{ config, pkgs, inputs, ... }:
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

  nix.registry = {
    my = {
      from = {
        id = "my";
        type = "indirect";
      };
      to = {
        owner = "haglobah";
        repo = "flakes";
        type = "github";
      };
    };
    n = {
      from = {
        id = "n";
        type = "indirect";
      };
      to = {
        type = "tarball";
        url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/*.tar.gz";
      };
    };
    nu = {
      from = {
        id = "nu";
        type = "indirect";
      };
      to = {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        ref = "nixos-unstable";
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    wget
    curl
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
    thunderbird
    
    eww
    dunst
    libnotify
    wofi
    jq
    
    gnome.gnome-tweaks

    ripgrep
    fd
    emacs29

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
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/terminal/legacy/keybindings" = {
      close-tab = "<Primary>w";
      close-window = "<Primary>q";
      move-tab-left = "<Shift><Alt>Left";
      move-tab-right = "<Shift><Alt>Right";
      new-tab = "<Primary>t";
      new-window = "<Primary>n";
      next-tab = "<Alt>Right";
      prev-tab = "<Alt>Left";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      
      enabled-extensions = [
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

    ".config/doom/config.el".source = dotfiles/doom/config.el;
    ".config/doom/init.el".source = dotfiles/doom/init.el;
    ".config/doom/packages.el".source = dotfiles/doom/packages.el;

    ".config/eww/eww.scss".source = dotfiles/eww/eww.scss;
    ".config/eww/eww.yuck".source = dotfiles/eww/eww.yuck;

    ".config/hypr/focus_or_start.sh" = {
      source = dotfiles/hypr/focus_or_start.sh;
      executable = true;
    };
    ".config/hypr/focus_or_special.sh" = {
      source = dotfiles/hypr/focus_or_special.sh;
      executable = true;
    };
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

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = (builtins.readFile ./dotfiles/hypr/hyprland.conf);
  };

  # programs.eww = {
  #   enable = true;
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "bah@posteo.de";
    userName = "Beat Hagenlocher";
    includes = [{
      condition = "gitdir:~/ag/";
      contents = { user.email = "beat.hagenlocher@active-group.de"; };
    }];
    ignores = [
      ".direnv/"

      ".calva"

      # Emacs
      "*~"
      "\\#*\\#"
      ".\\#*"
      ".dir-locals.el"
    ];
    extraConfig = {
      core.sshCommand = "ssh -i ~/.ssh/id_rsa -F /dev/null";
      init.defaultBranch = "main";
      rerere.enabled = true;
      branch.sort = "-committerdate";
      url = {
        "https://github.com/" = { insteadOf = "gh:"; };
        "git@github.com:haglobah/" = { insteadOf = "me:"; };
        "https://gitlab.com/" = { insteadOf = "gl:"; };
        "ssh://git@gitlab.active-group.de:1022/ag/" = { insteadOf = "ag:"; };
        "git@github.com:active-group/" = { insteadOf = "agh:"; };
      };
    };
  };

  programs.himalaya = {
    enable = true;
  };

  accounts.email.accounts = {
    posteo = {
      primary = true;
      himalaya = {
        enable = true;
      };
      address = "bah@posteo.de";
      realName = "Beat Hagenlocher";
      userName = "beat";
      passwordCommand = "bw login --api-key && bw unlock && bw get password bah_hagenlob@posteo.de";
      imap = {
        host = "posteo.de";
        port = 993;
        tls.enable = true;
      };
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;

    catppuccin.enable = true;

    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+w" = "close_tab";
      "ctrl+n" = "new_window";
      "alt+left" = "prev_tab";
      "alt+right" = "next_tab";
      "alt+shift+left" = "move_tab_backward";
      "alt+shift+right" = "next_tab_forward";
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+equal" = "change_font_size all 10.0";
      "ctrl+minus" = "change_font_size all -1.0";
    };
  };

  programs.firefox = {
    enable = true;
    profiles.beat = {

      settings = {
        "signon.rememberSignons" = false;
        "layout.spellcheckDefault" = "0";
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        darkreader
        videospeed
        vimium
        ublock-origin
      ];
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "cp" = "cp -i";
      "h" = "history";
      "l" = "lla";
      "lta" = "lt -la";
      "mv" = "mv -i";
      "rm" = "rm -i";
      "wh" = "type -a";
      "which" = "type -a";

      "grep" = "grep --color=auto";

      "g" = "git";
      "gi" = "git init";
      "ga" = "git add";
      "gu" = "git restore --staged";
      "gs" = "git status -s -b";
      "gbr" = "git branch -a -v";
      "gb" = "git for-each-ref --color --sort=-committerdate --format=$'%(color:green)%(ahead-behind:HEAD)\t%(color:blue)%(refname:short)\t%(color:yellow)%(committerdate:relative)\t%(color:default)%(describe)'     refs/ | sed 's/ /\t/' | column --separator=$'\t' --table --table-columns='Ahead,Behind,Branch Name,Last Commit,Description'";
      "gl" = "git log --oneline --decorate --graph";
      "gls" = "git log --graph --stat";
      "gcm" = "git commit -m";
      "gam" = "git add . && git commit -m";
      "gp" = "git push";
      "gpf" = "git push --force-with-lease";
      "gpu" = "git push --set-upstream";
      "gpo" = "git push --set-upstream origin";
      "gf" = "git pull";
      "gF" = "git fetch";
      "gun" = "git rm --cached";
      "gcb" = "git checkout -b";
      "gsw" = "git switch";
      "gco" = "git checkout";
      "gme" = "git merge";
      "gra" = "git remote add";
      "gro" = "git remote add origin";
      "grv" = "git remote --verbose";
      "gca" = "git commit --amend";
      "gcan" = "git commit --amend --no-edit";
      "gacan" = "git add . && git commit --amend --no-edit";
      "gcl" = "git clone";
      "gd" = "git diff --word-diff";
      "gdl" = "git diff";
      "gst" = "git stash";
      "gsh" = "git show";
      "gmb" = "git checkout HEAD^";

      "n" = "nix";
      "ni" = "nix repl";
      "nix-list" = "nix profile history --profile /nix/var/nix/profiles/system";
      "nix-rm-boot-entries" = "nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d";
      "nre" = "sudo nixos-rebuild switch --flake .";
      "nure" = "nix flake update && sudo nixos-rebuild switch --flake .";
      "nsh" = "nix shell";

      "nf" = "nix flake";
      "nfc" = "nix flake check";
      "nft" = "nix flake init --template";
      "nfn" = "nix flake new --template";
      "nfs" = "nix flake show";
      "nfu" = "nix flake update";
      "nr" = "nix run";
      "nru" = "nix run . --";
      "nl" = "nix run -L . --";
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
      gmf () {
        git checkout $(git rev-list --topo-order HEAD..''${1:-main})
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
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 160;
      "editor.scrollbar.verticalScrollbarSize" = 3;
      "editor.scrollbar.horizontalScrollbarSize" = 3;
      "editor.bracketPairColorization.enabled" = true;
      "window.titleBarStyle" = "custom";
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
      "window.zoomLevel" = -1;
      "files.associations" = {
        "*.glsl" = "c";
      };
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
      {
        "key" = "ctrl+n";
        "command" = "explorer.newFile";
      }
      {
        "key" = "ctrl+,";
        "command" = "editor.action.quickFix";
        "when" = "editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+.";
        "command" = "-editor.action.quickFix";
        "when" = "editorHasCodeActionsProvider && textInputFocus && !editorReadonly";
      }
      {
        "key" = "ctrl+.";
        "command" = "workbench.action.showCommands";
      }
      {
        "key" = "ctrl+shift+p";
        "command" = "-workbench.action.showCommands";
      }
      {
        "key" =  "ctrl+shift+,";
        "command" =  "workbench.action.openSettings";
      }
      {
        "key" =  "ctrl+,";
        "command" =  "-workbench.action.openSettings";
      }
      {
        "key" = "alt+right";
        "command" = "paredit.sexpRangeExpansion";
        "when" = "calva:keybindingsEnabled && editorTextFocus && !calva:cursorInComment && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "shift+alt+right";
        "command" = "-paredit.sexpRangeExpansion";
        "when" = "calva:keybindingsEnabled && editorTextFocus && !calva:cursorInComment && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "alt+left";
        "command" = "paredit.sexpRangeContraction";
        "when" = "calva:keybindingsEnabled && editorTextFocus && !calva:cursorInComment && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "shift+alt+left";
        "command" = "-paredit.sexpRangeContraction";
        "when" = "calva:keybindingsEnabled && editorTextFocus && !calva:cursorInComment && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "alt+,";
        "command" = "paredit.barfSexpForward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+alt+,";
        "command" = "-paredit.barfSexpForward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+alt+,";
        "command" = "paredit.barfSexpBackward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+shift+alt+right";
        "command" = "-paredit.barfSexpBackward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "alt+.";
        "command" = "paredit.slurpSexpForward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+alt+.";
        "command" = "-paredit.slurpSexpForward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+alt+.";
        "command" = "paredit.slurpSexpBackward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
      {
        "key" = "ctrl+shift+alt+left";
        "command" = "-paredit.slurpSexpBackward";
        "when" = "calva:keybindingsEnabled && editorTextFocus && editorLangId == 'clojure' && paredit:keyMap =~ /original|strict/";
      }
    ];
  };

  catppuccin.flavour = "macchiato";

  gtk.catppuccin = {
    enable = true;
    cursor.enable = true;
    icon.enable = true;
  };

  programs.starship = {
    enable = true;

    catppuccin.enable = true;
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

      battery = {
        display = [
          {threshold = 30; style = "bold red";}
        ];
      };

      # package.disabled = true;
    };
  };

  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
  };
  programs.zoxide = {
    enable = true;
  };
  programs.fzf = {
    catppuccin.enable = true;
    enable = true;
  };
}
