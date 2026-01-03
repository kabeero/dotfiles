{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
  home.username = "mkgz";
  home.homeDirectory = "/home/mkgz";

  home.packages = with pkgs; [
    git
    bzip2
    libffi
    ncurses
    openssl
    readline
    zlib
    (import "${config.home.homeDirectory}/.config/nixpkgs/hypr-i3-move/default.nix" { inherit pkgs; })
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.wlsunset = {
    longitude = -117.83;
    latitude = 33.68;
    enable = true;
  };

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
          l   = "log --color --stat";
          ll  = "log --color --stat -p";
          lg  = "log --graph --format=\"%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)\"";
          lgg = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
          pu  = "push";
          pl  = "pull";
          s   = "status";
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
