# ╭───────────╮
# │   kitty   │
# ╰───────────╯

{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      adjust_line_height = "120%";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      strip_trailing_spaces = "smart";
      focus_follows_mouse = true;
      sync_to_monitor = true;
      enable_audio_bell = false;
      remember_window_size = false;
      initial_window_width = 960;
      initial_window_height = 720;
      enabled_layouts = "Tall, Fat, Vertical, Horizontal, Stack, Grid";
      window_border_width = 0;
      window_margin_width = "3.0";
      window_padding_width = "6.0";
      inactive_text_alpha = "0.7";
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 2;
      tab_bar_edge = "top";
      tab_bar_style = "separator";
      tab_powerline_style = "round";
      tab_separator = "\"\"";
      tab_title_template = "\" 󰮋 \"";
      active_tab_title_template = "\" 󰇈 \"";
      active_tab_font_style = "normal";
      tab_bar_background = "none";
      dynamic_background_opacity = true;
      dim_opacity = "0.75";
      selection_background = "#aaaaff";
    };
    keybindings = {
      "kitty_mod+c" = "copy_or_interrupt";
      "kitty_mod+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_selection";
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+i" = "set_tab_title";
      "kitty_mod+l" = "next_layout";
      "kitty_mod+/" = "last_used_layout";
      "kitty_mod+m" = "goto_layout stack";
      "kitty_mod+s" = "goto_layout vertical";
      "kitty_mod+p>u" = "kitten hints";
      "kitty_mod+p>c>l" = "kitten hints --program @ --type line";
      "kitty_mod+p>c>h" = "kitten hints --program @ --type hash";
      "kitty_mod+p>c>p" = "kitten hints --program @ --type path";
      "kitty_mod+p>c>u" = "kitten hints --program @";
      "kitty_mod+a>m" = "set_background_opacity +0.05";
      "kitty_mod+a>l" = "set_background_opacity -0.05";
    };
  };
}
