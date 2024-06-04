{ config, lib, pkgs, ...}:
{
  config = {
        programs.fish = {
      enable = true;
      shellAbbrs = {
        "wh" = "type -a";

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
      };
      shellAliases = {
        ".." = "cd ..";
        "cp" = "cp -i";
        "h" = "history";
        "l" = "lla";
        "lta" = "lt -la";
        "mv" = "mv -i";
        "rm" = "rm -i";
        "which" = "type -a";

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

        "e" = "emacs";
        "c" = "code . &";
        
        "hm" = "home-manager";
        "hsw" = "home-manager switch --flake .";
        "reload" = ". ~/.bash_profile";
      };

      shellInit = ''
        function md
          mkdir -p -- $argv[1] && cd -P -- $argv[1]
        end

        function freq 
          history | cut -c8- | cut -d" " --fields=1"$argv[1]" | sort | uniq -c | sort -rn
        end

        function gap
          git add . && git commit --message="$argv[1]" && git push 
        end

        function gm
          git add ''$argv[2..-1]
          git commit --message="$argv[1]"
        end

        function gmf
          git checkout (git rev-list --topo-order HEAD..''$argv[1] | string collect; or echo)
        end

        function gb
          git for-each-ref --color --sort=-committerdate --format="%{\e[32m%}%(ahead-behind:HEAD)\t%{\e[34m%}%(refname:short)\t%{\e[33m%}%(committerdate:relative)\t%{\e[0m%}%(describe)" refs/ | sed 's/ /\t/' | column --separator='\t' --table --table-columns='Ahead,Behind,Branch Name,Last Commit,Description'
        end

        set -gx PATH $PATH ~/.config/emacs/bin"
        set -gx PATH $PATH ~/.emacs.d/bin"
        set -gx EDITOR "emacs"
      '';
    };
  };
}