# ╭──────────╮
# │   yazi   │
# ╰──────────╯

{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      exiftool
      fd
      ffmpegthumbnailer
      file
      fzf
      glow
      imagemagick
      jq
      mediainfo
      p7zip
      poppler-utils
      ripgrep
      zoxide
    ];

    initLua = ./init.lua;

    plugins = {
      glow = pkgs.yaziPlugins.glow;
      mount = pkgs.yaziPlugins.mount;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
    };
  };

  stylix.targets.yazi.enable = false;

  xdg.configFile = {
    "yazi/yazi.toml".source = ./yazi.toml;
    "yazi/keymap.toml".source = ./keymap.toml;
    "yazi/theme-dark.toml".source = ./theme-dark.toml;
    "yazi/theme-light.toml".source = ./theme-light.toml;
  };
}
