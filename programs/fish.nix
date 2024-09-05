{ config, lib, pkgs, ...}:
{
  config = {
    programs.fish = {
      enable = true;
      shellAbbrs = {
        "gmb" = "git checkout HEAD^";

        "n" = "nix";
        "ni" = "nix repl";
        "nix-list" = "nix profile history --profile /nix/var/nix/profiles/system";
        "nix-rm-boot-entries" = "nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d";
        "nre" = "sudo nixos-rebuild switch --flake .";
        "nure" = "nix flake update && sudo nixos-rebuild switch --flake .";
        "nsh" = {
          expansion = "nix shell n#% -c fish";
          setCursor = true;
        };
        "nsu" = {
          expansion = "NIXPKGS_ALLOW_UNFREE=1 nix shell n#% --impure -c fish";
          setCursor = true;
        };

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
        "nd" = {
          expansion = "nix develop % -c fish";
          setCursor = true;
        };

        "c" = "code . &";
        "gcb" = "git checkout -b";
        "gsw" = "git switch";
        "gsc" = "git switch -c";
        "gco" = "git checkout";
        "gme" = "git merge";

        "da" = "direnv allow";
        "dr" = "direnv reload";
      };
      shellAliases = {
        ".." = "cd ..";
        "cp" = "cp -i";
        "h" = "history";
        "l" = "lla";
        "lta" = "lt -la";
        "mv" = "mv -i";
        "rm" = "rm -i";
        "wh" = "type -a";
        "du" = "du -ach | sort -h";

        "grep" = "grep --color=auto";

        "g" = "git";
        "gi" = "git init";
        "ga" = "git add";
        "gu" = "git restore --staged";
        "gs" = "git status -s -b";
        "gbr" = "git branch -a -v";
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
        "gra" = "git remote add";
        "gro" = "git remote add origin";
        "grv" = "git remote --verbose";
        "gca" = "git commit --amend";
        "gcan" = "git commit --amend --no-edit";
        "gacan" = "git add . && git commit --amend --no-edit";
        "gd" = "git diff --word-diff";
        "gdl" = "git diff";
        "gst" = "git stash";
        "gsh" = "git show";

        "e" = "emacs";
        
        "hm" = "home-manager";
        "hsw" = "home-manager switch --flake .";
        "reload" = ". ~/.config/fish/config.fish";
      };

      shellInit = ''
        function md
          mkdir -p $argv[1] && cd $argv[1]
        end

        function freq 
          history | cut -c8- | cut -d" " --fields=1"$argv[1]" | sort | uniq -c | sort -rn
        end

        function gap
          git add . && git commit --message="$argv[1]" && git push 
        end

        function gcl
          git clone $argv[1] && cd (string split : (basename $argv[1] .git))[-1]
        end

        function gm
          git add ''$argv[2..-1]
          git commit --message="$argv[1]"
        end

        function gmf
          git checkout (git rev-list --topo-order HEAD..''$argv[1] | string collect; or echo)
        end

        function gb
          git for-each-ref --color --sort=-committerdate --format="%(ahead-behind:HEAD)*%(refname:short)*%(committerdate:relative)*%(describe)" refs/ | column --separator='*' --table --table-columns='Ahead-Behind,Branch Name,Last Commit,Description'
        end

        # bind " " expand-abbr or self-insert

        set -gx PATH $PATH ~/.config/emacs/bin"
        set -gx PATH $PATH ~/.emacs.d/bin"
        set -gx EDITOR "emacs"
      '';
    };
  };
}