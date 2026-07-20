# ╭──────────╮
# │   fish   │
# ╰──────────╯

{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      gitclean = "git fetch -p && git branch -vv | grep ': gone]' | awk '{print}' | xargs git branch -D $argv;";
      dotdot = {
        regex = "^\\.\\.+$";
        function = "multicd";
      };
    };
    shellAliases = {
      ls = "eza";
      l = "ls";
      l1 = "ls -1";
      ll = "ls -l --icons --git";
      r = "ranger";
      y = "yazi";
      v = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      cdr = "cd (git rev-parse --show-cdup)";
      cdllm = "cd (mktemp -d -t llm.XXXXXXXX); type -q opencode && opencode";
      diffk = "kitty +kitten diff";
      glow = "glow -p";
      gu = "gitui";
      jless = "jless -r";
      sio = "sioyek";
      tfia = "terraform init ; terraform apply";
      tfmt = "terraform fmt -recursive";
    };
    functions = {
      d = ''
        set apps bat fzf
        for a in $apps
            if ! command -v $a >/dev/null
                echo "❗ Please install $a"
                return
            end
        end
        set flags -e -1 --preview='bat --color always -p {}' --bind shift-up:preview-page-up,shift-down:preview-page-down
        set chosen ""
        if test (count $argv) -gt 0
            set chosen (fzf $flags -q $argv[1])
        else
            set chosen (fzf $flags)
        end
        if set -q chosen && test -n "$chosen"
            cd (dirname $chosen)
        end
      '';

      e = ''
        set apps bat fzf nvim
        for a in $apps
            if ! command -v $a >/dev/null
                echo "❗ Please install $a"
                return
            end
        end
        set flags -e -1 --preview='bat --color always -p {}' --bind shift-up:preview-page-up,shift-down:preview-page-down
        set chosen ""
        if test (count $argv) -gt 0
            set chosen (fzf $flags -q $argv[1])
        else
            set chosen (fzf $flags)
        end
        if set -q chosen && test -n "$chosen"
            nvim $chosen
        end
      '';

      z = ''
        zellij ls -s | sort | awk '{printf "\033[32m%15s\033[0m\n", $1}'
        alias z="zellij"
      '';

      dockerls = ''
        docker ps --format "table {{.Image}}\t{{.Ports}}\t{{.Names}}"
      '';

      multicd = ''
        echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
      '';

      fish_hybrid_key_bindings = ''
        for mode in default insert visual
            fish_default_key_bindings -M $mode
        end
        fish_vi_key_bindings --no-erase
      '';

      ytarchive = ''
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-subs \
          --embed-metadata \
          --convert-subs 'srt' \
          --download-archive $argv[1].txt https://www.youtube.com/$argv[1]/videos; 
      '';

      ytarchivevideo = ''
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-metadata \
          --convert-subs 'srt' \
          --download-archive $argv[1] $argv[2]; 
      '';

      ytd = ''
        yt-dlp -f bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best -o '%(upload_date)s - %(channel)s - %(id)s - %(title)s.%(ext)s' \
          --sponsorblock-mark "all" \
          --geo-bypass \
          --sub-langs 'all' \
          --embed-subs \
          --embed-metadata \
          --convert-subs 'srt' \
          $argv
      '';

    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -gx EDITOR nvim
      set -Ux GOPATH {$HOME}/code/go
      set -Ux GOBIN {$GOPATH}/bin
      set -Ux AWS_CLI_AUTO_PROMPT on-partial
      set -Ux ERL_AFLAGS "-kernel shell_history enabled"
      set -Ux MISE_PREFER_OFFLINE true
      set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin
      pfetch
      echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"
      zellij setup --generate-completion fish | source
      fish_add_path {$HOME}/.asdf/bin
      fish_add_path {$HOME}/.cargo/bin
      fish_add_path {$HOME}/.yarn/bin
      fish_add_path {$HOME}/.local/bin
      fish_add_path {$GOBIN}
      mise activate fish | source
      starship init fish | source
      zoxide init --cmd c fish | source
      eval (ssh-agent -c) >/dev/null
      ssh-add -q
      set -g fish_key_bindings fish_hybrid_key_bindings
    '';
    plugins = [ ];
  };
}
