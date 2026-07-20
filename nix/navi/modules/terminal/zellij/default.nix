# ╭────────────╮
# │   zellij   │
# ╰────────────╯

{ config, pkgs, colors, ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  xdg.configFile."zellij/plugins/zjstatus.wasm".source = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  xdg.configFile."zellij/layouts/default.swap.kdl".source = ./layout.swap.kdl;
  # inject + interpolate, so we can specify colors dynamically
  # > https://nix-community.github.io/stylix/styling.html
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
        pane size=2 borderless=true {
          plugin location="file:$HOME/.config/zellij/plugins/zjstatus.wasm" {

            color_bg "#${colors.base00}"
            color_fg "#${colors.base06}"
            color_black "#${colors.base00}"
            color_gray1 "#${colors.base01}"
            color_gray2 "#${colors.base02}"
            color_gray3 "#${colors.base03}"
            color_gray4 "#${colors.base04}"
            color_gray5 "#${colors.base05}"
            color_gray6 "#${colors.base06}"
            color_white "#${colors.base07}"
            color_red "#${colors.base08}"
            color_orange "#${colors.base09}"
            color_yellow "#${colors.base0A}"
            color_green "#${colors.base0B}"
            color_blue "#${colors.base0C}"
            color_cyan "#${colors.base0D}"
            color_magenta "#${colors.base0E}"
            color_maroon "#${colors.base0F}"

            hide_frame_for_single_pane "false"

            // style: pill
            // format_left   "#[fg=$bg,bg=none]#[fg=$maroon,bg=$bg,bold] {session}#[fg=$bg,bg=none]◗ {tabs}"

            // style: plain
            format_left   " #[fg=$maroon,bg=none,bold] {session}  {tabs}"

            format_right  "{mode} {datetime}"

            // format_space  ""

            // palette
            // format_left  "#[bg=#${colors.base00}]00;#[bg=#${colors.base01}]01;#[bg=#${colors.base02}]02;#[bg=#${colors.base03}]03;#[bg=#${colors.base04}]04;#[bg=#${colors.base05}]05;#[bg=#${colors.base06}]06;#[bg=#${colors.base07}]07;#[bg=#${colors.base08}]08;#[bg=#${colors.base09}]09;#[bg=#${colors.base0A}]0A;#[bg=#${colors.base0B}]0B;#[bg=#${colors.base0C}]0C;#[bg=#${colors.base0D}]0D;#[bg=#${colors.base0E}]0E;#[bg=#${colors.base0F}]0F; {tabs}"
            // format_left  "#[bg=$fg]fg;#[bg=none]bg;#[bg=$black]black;#[bg=$gray1]gray1;#[bg=$gray2]gray2;#[bg=$gray3]gray3;#[bg=$gray4]gray4;#[bg=$gray5]gray5;#[bg=$red]red;#[bg=$orange]orange;#[bg=$yellow]yellow;#[bg=$green]green;#[bg=$cyan]cyan;#[bg=$blue]blue;#[bg=$magenta]magenta;#[bg=$maroon]maroon;#[bg=$white]white;"

            mode_normal        ""
            mode_locked        "#[fg=$maroon,bg=none]#[bg=$maroon,fg=$gray1,bold]{name}#[fg=$maroon,bg=none]◗"
            mode_pane          "#[fg=$gray5,bg=none]#[bg=$gray5,fg=$gray1,bold]{name}#[fg=$gray5,bg=none]◗"
            mode_tab           "#[fg=$gray5,bg=none]#[bg=$gray5,fg=$gray1,bold]{name}#[fg=$gray5,bg=none]◗"
            mode_scroll        "#[fg=$red,bg=none]#[bg=$red,fg=$gray1,bold]{name}#[fg=$red,bg=none]◗"
            mode_enter_search  "#[fg=$yellow,bg=none]#[bg=$yellow,fg=$gray1,bold]{name}#[fg=$yellow,bg=none]◗"
            mode_search        "#[fg=$yellow,bg=none]#[bg=$yellow,fg=$gray1,bold]{name}#[fg=$yellow,bg=none]◗"
            mode_resize        "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_rename_tab    "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_rename_pane   "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_move          "#[fg=$orange,bg=none]#[bg=$orange,fg=$gray1,bold]{name}#[fg=$orange,bg=none]◗"
            mode_session       "#[fg=$green,bg=none]#[bg=$green,fg=$gray1,bold]{name}#[fg=$green,bg=none]◗"
            mode_prompt        "#[fg=$magenta,bg=none]#[bg=$magenta,fg=$gray1,bold]{name}#[fg=$magenta,bg=none]◗"
            mode_tmux          "#[fg=$cyan,bg=none]#[bg=$cyan,fg=$gray1,bold]{name}#[fg=$cyan,bg=none]◗"
            mode_default_to_mode "tmux" // if not listed above, which color to use

            // style: pill
            // tab_normal              "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none]◗"
            // tab_normal_fullscreen   "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none]◗"
            // tab_normal_sync         "#[fg=$bg,bg=none]#[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none]◗"

            // style: plain
            tab_normal              "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none] "
            tab_normal_fullscreen   "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none] "
            tab_normal_sync         "#[fg=$bg,bg=none] #[fg=$gray5,bg=none,bold]{index} #[fg=$gray3,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none] "

            // formatting for the current active tab
            // style: pill
            tab_active              "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{floating_indicator}#[fg=$bg,bg=none]◗"
            tab_active_fullscreen   "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{fullscreen_indicator}#[fg=$bg,bg=none]◗"
            tab_active_sync         "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{sync_indicator}#[fg=$bg,bg=none]◗"

            // style: plain
            // tab_active              "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{floating_indicator} "
            // tab_active_fullscreen   "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{fullscreen_indicator} "
            // tab_active_sync         "#[fg=$cyan,bg=none]#[fg=$gray1,bg=$cyan,bold]{index} #[fg=$cyan,bg=none,bold] {name}{sync_indicator} "

            // separator between the tabs
            tab_separator           " "

            // indicators
            tab_sync_indicator       " "
            tab_fullscreen_indicator " 󰊓"
            tab_floating_indicator   " 󰹙"

            command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
            command_git_branch_format      "#[fg=blue] {stdout} "
            command_git_branch_interval    "10"
            command_git_branch_rendermode  "static"

            datetime          "#[fg=$gray3,bold] {format} "
            datetime_format   "%H:%M"
            datetime_timezone "America/Los_Angeles"
          }
        }
        children
      }
    }
  '';
}
