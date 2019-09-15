{ config, pkgs, lib, ... }:

with lib;

let
  shabka_cfg = config.shabka.git;
  hm_cfg = config.programs.git;
in {
  config = mkIf shabka_cfg.enable {

    shabka.git = {
      userName = "Wael M. Nasreddine";
      userEmail = "wael.nasreddine@gmail.com";
      gpgSigningKey = "me@yl.codes";
    };

    home.packages = with pkgs; [
      (gitAndTools.git-appraise or shabka.external.nixpkgs.release-unstable.gitAndTools.git-appraise)
      gitAndTools.tig
    ];

    programs.git.aliases = {
      # list files which have changed since REVIEW_BASE
      # (REVIEW_BASE defaults to 'master' in my zshrc)
      files     = "\"!git diff --name-only \$(git merge-base HEAD \\\"\${REVIEW_BASE:-master}\\\")\"";

      # Same as above, but with a diff stat instead of just names
      # (better for interactive use)
      stat      = "\"!git diff --stat \$(git merge-base HEAD \\\"\${REVIEW_BASE:-master}\\\")\"";

      # Open all files changed since REVIEW_BASE in Vim tabs
      # Then, run fugitive's :Gdiff in each tab, and finally
      review    = "\"!nvim -p $(git files) +\\\"tabdo Gdiff \${REVIEW_BASE:-master}\\\"\"";

      # Same as the above, except specify names of files as arguments,
      # instead of opening all files:
      # git reviewone foo.js bar.js
      reviewone = "\"!nvim -p +\\\"tabdo Gdiff \${REVIEW_BASE:-master}\\\"\"";
    };

    programs.git.extraConfig = {
      core = {
        whitespace = "trailing-space,space-before-tab,-indent-with-non-tab,cr-at-eol";
      };

      diff = {
        tool = "vimdiff";
      };

      difftool = {
        prompt = false;
      };

      help = {
        autocorrect = 30;
      };

      http = {
        cookiefile = "~/.gitcookies";
      };

      "http \"https://gopkg.in\"" = {
        followRedirects = true;
      };

      merge = {
        log  = true;
        tool = "vimdiff";
      };

      mergetool = {
        prompt = true;
      };

      "mergetool \"vimdiff\"" = optionalAttrs config.shabka.neovim.enable {
        cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      "protocol \"keybase\"" = {
        allow = "always";
      };

      push = {
        default = "current";
      };

      sendemail = {
        smtpserver       = "${pkgs.msmtp}/bin/msmtp";
        smtpserveroption = "--account=personal";
      };

      status = {
        submodule = 1;
      };

      "url \"https://github\"" = {
        insteadOf = "git://github";
      };
    };
  };
}
