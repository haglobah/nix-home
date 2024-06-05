{ config, pkgs, inputs, ... }:
{

  imports = [
    ./programs/vscode.nix
    ./programs/bash.nix
    ./programs/fish.nix
  ];

  config = {
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
      complete-alias
      bash-completion
      
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
      shellIntegration.enableFishIntegration = true;

      settings = {
        shell = "fish";
      };

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
        "ctrl+backspace" = "send_text all \\x17";
        "ctrl+delete" = "send_key alt+d";
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

    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
    };

    programs.direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };

    catppuccin.flavour = "macchiato";

    gtk.catppuccin = {
      enable = true;
      cursor.enable = true;
      icon.enable = true;
    };

    programs.starship = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;

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

    programs.btop = {
      enable = true;
    };
    programs.bat = {
      enable = true;
      catppuccin.enable = true;
    };
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      git = true;
    };
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    programs.fzf = {
      enable = true;
      catppuccin.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
