{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/registry.nix
    ./modules/email.nix

    ./programs/git.nix
    ./programs/vscode.nix
    ./programs/nvf.nix
    ./programs/bash.nix
    ./programs/fish.nix
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      # ];
    };

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

    home.packages = with pkgs; [
      # CLI
      wget
      curl
      traceroute
      jq
      tmux
      cachix
      ydotool
      wl-clipboard
      dua
      gnupg
      pass

      # Emacs
      ((emacsPackagesFor emacs30).emacsWithPackages (epkgs: [ epkgs.mu4e ]))
      ripgrep
      fd
      python314
      aider-chat
      # mu
      # isync

      # Neovim
      neovim
      zig
      gcc
      lua
      unzip
      gnumake
      markdownlint-cli

      # mob programming
      mob
      comma

      # other GUI Tools
      zed-editor
      tor-browser
      chromium
      librewolf
      obsidian
      discord
      signal-desktop
      telegram-desktop
      zoom-us
      thunderbird
      gnome-tweaks
      linphone
      teams-for-linux

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

    home.file = {
      ".local/share/gnome-shell/extensions/gnome-magic-window@adrienverge/extension.js".source =
        dotfiles/gnome-magic-window/extension.js;
      ".local/share/gnome-shell/extensions/gnome-magic-window@adrienverge/metadata.json".source =
        dotfiles/gnome-magic-window/metadata.json;

      ".config/zed/settings.json".source = dotfiles/zed/settings.json;
      ".config/zed/keymap.json".source = dotfiles/zed/keymap.json;

      ".mob".source = dotfiles/mob.sh/.mob;
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
      GNOME_SHELL_SLOWDOWN_FACTOR = 0.4;
    };

    xdg.enable = true;
    xdg.autostart = {
      enable = true;
      entries = [ "${pkgs.linphone}/share/applications/linphone.desktop" ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        enabled-extensions = [ "gnome-magic-window@adrienverge" ];
      };
      "org/gnome/shell/keybindings" = {
        toggle-message-tray = [ ];
        toggle-quick-settings = [ ];
        focus-active-notification = [ ];
        toggle-application-view = [ ];
      };
    };

    services.emacs.enable = true;

    programs.home-manager.enable = true;

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";

        prompt = "enabled";
      };
    };

    programs.kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableFishIntegration = true;

      settings = {
        enabled_layouts = "splits:split_axis=horizontal";
      };

      keybindings = {
        "ctrl+t" = "launch --cwd=current --type=tab";
        "alt+left" = "prev_tab";
        "alt+right" = "next_tab";
        "alt+shift+left" = "move_tab_backward";
        "alt+shift+right" = "next_tab_forward";
        "ctrl+]" = "launch --cwd=current --location=vsplit";
        "ctrl+[" = "launch --cwd=current --location=hsplit";
        "shift+left" = "neighboring_window left";
        "shift+right" = "neighboring_window right";
        "shift+up" = "neighboring_window up";
        "shift+down" = "neighboring_window down";
        "ctrl+shift+left" = "move_window left";
        "ctrl+shift+right" = "move_window right";
        "ctrl+shift+up" = "move_window up";
        "ctrl+shift+down" = "move_window down";
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

        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
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

    catppuccin = {
      enable = true;
      flavor = "macchiato";
      starship.enable = true;
      kitty.enable = true;
      gtk.icon.enable = true;
      gtk.enable = true;
      fzf.enable = true;
      bat.enable = true;
      cursors.enable = true;
    };

    programs.starship = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;

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
            {
              threshold = 30;
              style = "bold red";
            }
          ];
        };

        pijul_channel.disabled = false;
      };
    };

    programs.btop = {
      enable = true;
    };
    programs.bat = {
      enable = true;
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
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    programs.broot = {
      enable = true;
    };
  };
}
