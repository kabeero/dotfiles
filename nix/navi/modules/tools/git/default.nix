# ╭─────────╮
# │   git   │
# ╰─────────╯

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        useConfigOnly = true;
        name = "M K Gharzai";
        email = "kabeer@gharzai.net";
      };
      alias = {
        l = "log --color --stat";
        ll = "log --color --stat -p";
        lg = "log --graph --format=\"%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)\"";
        lgg = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
        pu = "push";
        pl = "pull";
        s = "status";
      };
      branch.sort = "-committerdate";
      core = {
        pager = "delta --dark";
        editor = "nvim";
      };
      delta = {
        side-by-side = true;
        line-numbers = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      init.defaultBranch = "main";
      log.date = "iso-local";
      merge = {
        tool = "difftastic";
        conflictstyle = "zdiff3";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followtags = true;
      };
      rerere.enabled = true;
    };
  };
}
