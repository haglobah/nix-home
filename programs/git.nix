{ config, lib, pkgs, ...}:
{
  config = {
    programs.git = {
      enable = true;
      userEmail = "bah@posteo.de";
      userName = "Beat Hagenlocher";
      includes = [
        {
          condition = "gitdir:~/ag/";
          contents = {user.email = "beat.hagenlocher@active-group.de";};
        }
      ];
      ignores = [
        ".envrc"
        ".direnv/"

        ".calva"

        # Emacs
        "*~"
        "\\#*\\#"
        ".\\#*"
        ".dir-locals.el"
      ];
      extraConfig = {
        color.ui = "auto";
        core.sshCommand = "ssh -i ~/.ssh/id_rsa -i ~/.ssh/id_ed25519 2> /dev/null";
        init.defaultBranch = "main";
        checkout.defaultRemote = "origin";
        rerere.enabled = true;
        branch.sort = "-committerdate";
        url = {
          "https://github.com/" = {insteadOf = "gh:";};
          "git@github.com:" = {insteadOf = "gs:";};
          "git@github.com:haglobah/" = {insteadOf = "my:";};
          "https://gitlab.com/" = {insteadOf = "gl:";};
          "ssh://git@gitlab.active-group.de:1022/ag/" = {insteadOf = "ag:";};
          "git@github.com:active-group/" = {insteadOf = "agh:";};
        };
      };
    };
  };
}
