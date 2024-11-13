{ config, lib, pkgs, ...}:
{
  config = {
    programs.fish = {
      enable = true;
      shellAbbrs = {
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
        "nr" = "nix run ";
        "nra" = "nix run . --";
        "nru" = {
          expansion = "NIXPKGS_ALLOW_UNFREE=1 nix run n#% --impure";
          setCursor = true;
        };
        "nl" = "nix run -L . --";
        "nb" = "nix build";
        "nd" = {
          expansion = "nix develop % -c fish";
          setCursor = true;
        };

        "cu" = "cursor . &";
        "c" = "code . &";
        "e" = "emacs";
        "h" = "history";

        "g" = "git";
        "gi" = "git init";
        "gim" = "git init && git add . && git commit --message \"Initial commit\"";
        "gcl" = "git clone";
        "ga" = "git add";
        "gs" = "git status -s -b";
        "gbr" = "git branch -a -v";
        "gcm" = "git commit --message";
        "gam" = "git add . && git commit --message";
        "gp" = "git push";
        "gpf" = "git push --force-with-lease";
        "gpu" = "git push --set-upstream";
        "gpo" = "git push --set-upstream origin";
        "gpb" = "git push --set-upstream origin (git_branch_name)";
        "gf" = "git pull";
        "gfa" = "git fetch --all";
        "gfap" = "git fetch --all --prune";
        "gra" = "git remote add";
        "gro" = "git remote add origin";
        "grv" = "git remote --verbose";
        "gca" = "git commit --amend";
        "gcan" = "git commit --amend --no-edit";
        "gacan" = "git add . && git commit --amend --no-edit";
        "gd" = "git diff --word-diff";
        "gst" = "git stash";

        "gre" = "git restore";
        "gu" = "git restore --staged";
        "gun" = "git rm --cached";
        "gcb" = "git checkout -b";
        "gsw" = "git switch";
        "gs-" = "git switch -";
        "gsc" = "git switch -c";
        "gco" = "git checkout";
        "gme" = "git merge";
        "gmb" = "git checkout HEAD^";
        "gl" = "git log --oneline --decorate --graph";
        "gls" = "git log --graph --stat";
        "gld" = "git log --graph --pretty=format:'%Cred%h%Creset %an -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        "gsh" = "git show";

        "ghi" = {
          expansion = "gh repo create % --private --source=. --remote=origin";
          setCursor = true;
        };
        "gho" = {
          expansion = "gh repo create % --private --source=. --remote=origin && git push --set-upstream origin main";
          setCursor = true;
        };

        "da" = "direnv allow";
        "dr" = "direnv reload";

        "hm" = "home-manager";
        "hsw" = "home-manager switch --flake .";
        "reload" = "source ~/.config/fish/config.fish";
      };
      shellAliases = {
        ".." = "cd ..";
        "cp" = "cp -i";
        "l" = "lla";
        "lta" = "lt -la";
        "mv" = "mv -i";
        "rm" = "rm -i";
        "wh" = "type -a";
        "du" = "du -ach | sort -h";

        "grep" = "grep --color=auto";
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

        function gc
          git clone $argv[1] && cd (string split : (basename $argv[1] .git))[-1]
        end

        function gm
          git add ''$argv[2..-1]
          git commit --message="$argv[1]"
        end

        function gmf
          git checkout (git rev-list --topo-order HEAD..''$argv[1] | string collect; or echo)
        end

        function git_branch_name
          git rev-parse --abbrev-ref HEAD
        end

        function gb
          git for-each-ref --color --sort=-committerdate --format='%(color:green)%(ahead-behind:HEAD)%(color:reset)*%(color:blue)%(refname:short)%(color:reset)*%(color:yellow)%(committerdate:relative)%(color:reset)*%(describe)' refs/ | column --separator='*' --table --table-columns='Ahead-Behind,Branch Name,Last Commit,Description'
        end

        # bind " " expand-abbr or self-insert

        set -gx PATH $PATH ~/.config/emacs/bin"
        set -gx PATH $PATH ~/.emacs.d/bin"
        set -gx EDITOR "nvim"
      '';
    };
  };
}
