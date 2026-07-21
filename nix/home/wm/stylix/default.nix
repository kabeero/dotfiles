# ╭────────────╮
# │   stylix   │
# ╰────────────╯

{ config, pkgs, ... }:

{
  stylix.targets.btop.colors.enable = true;
  stylix.targets.kitty.colors.enable = true;
  stylix.targets.kitty.enable = true;
  stylix.targets.waybar.addCss = false;
}
