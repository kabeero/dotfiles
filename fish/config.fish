if status is-interactive
    alias ls="eza"
    alias l="ls"
    alias l1="ls -1"
    alias ll="ls -l --icons --git"
    alias r="ranger"
    alias y="yazi"
    alias v="nvim"
    alias vim="nvim"
    alias vimdiff="nvim -d"
    alias cdr="cd (git rev-parse --show-cdup)"
    alias diffk="kitty +kitten diff"
    alias glow="glow -p"
    alias gu="gitui"
    alias jless="jless -r"
    alias sio="sioyek"
    alias tfia="terraform init ; terraform apply"
    alias tfmt="terraform fmt -recursive"

    abbr gitclean "git fetch -p && git branch -vv | grep ': gone]' | awk '{print}' | xargs git branch -D $argv;"

    set -Ux EDITOR nvim

    set -Ux GOPATH {$HOME}/code/go
    set -Ux GOBIN {$GOPATH}/bin

    set -Ux AWS_CLI_AUTO_PROMPT on-partial

    # pip --user paths
    #set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
    #set -Ux SCIPY_PIL_IMAGE_VIEWER sxiv

    # iex shell history
    set -Ux ERL_AFLAGS "-kernel shell_history enabled"

    # krew k8s pkg
    set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

    pfetch

    # gentoo
    echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"

    # macos
    #echo -e "\033[0;32m"(date +%c)"\x1b[0m"

    # source {$HOME}/.asdf/asdf.fish
    zellij setup --generate-completion fish | source

    # brew
    # source /opt/homebrew/opt/asdf/libexec/asdf.fish
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    fish_add_path {$HOME}/.asdf/bin
    fish_add_path {$HOME}/.cargo/bin
    fish_add_path {$HOME}/.yarn/bin
    fish_add_path {$GOBIN}

    starship init fish | source
    # zoxide init fish | source
    mise activate fish | source

    eval (ssh-agent -c) >/dev/null
    ssh-add -q

    ## hybrid: set below
    ## vi style
    # fish_vi_key_bindings
    ## emacs style
    # fish_default_key_bindings
end

# jump to directory
function d

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
end

# edit file
function e

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
end

# zellij
function z
    zellij ls -s | sort | awk '{printf "\033[32m%15s\033[0m\n", $1}'
    alias z="zellij"
end

# zellij tab rename: update the zellij tab name with the current process name or pwd
if status is-interactive
    if type -q zellij
        # # pre-exec programs: we will lose context when they execute so capture them before
        # function zellij_tab_name_update_exe --on-event fish_preexec
        #     if set -q ZELLIJ
        #         set -l cmd_line (string split " " -- $argv)
        #         set -l process_name $cmd_line[1]
        #         if test -n "$process_name" \
        #                 -a "$process_name" != cd \
        #                 -a "$process_name" != exit \
        #                 -a (string match -q --invert --regex ".*vim.*|v" "$process_name")
        #             command nohup zellij action rename-tab $process_name >/dev/null 2>&1
        #         end
        #     end
        # end
        # post-exec folders: we want to get the path after cd'ing
        function zellij_tab_name_update_post --on-event fish_postexec
            if set -q ZELLIJ
                set -l cmd_line (string split " " -- $argv)
                set -l process_name $cmd_line[1]
                if test -n "$process_name" \
                        -a "$process_name" = cd
                    set -l deep_dir (string split "/" -- $PWD)
                    set -l tab_name (string shorten --max 8 --left $deep_dir[-1])
                    command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
                end
            end
        end
    end
end

function dockerls
    docker ps --format "table {{.Image}}\t{{.Ports}}\t{{.Names}}"
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

function fish_hybrid_key_bindings --description \
    "Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
end
set -g fish_key_bindings fish_hybrid_key_bindings

# uv
fish_add_path "/Users/mkgz/.local/bin"
