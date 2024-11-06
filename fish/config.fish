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
    alias diffk="kitty +kitten diff"
    alias jless="jless -r"
    alias sio="sioyek"

    set -Ux EDITOR nvim

    set -Ux GOPATH {$HOME}/Code/go
    set -Ux GOBIN {$GOPATH}/bin

    # pip --user paths
    #set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
    #set -Ux SCIPY_PIL_IMAGE_VIEWER sxiv

    # iex shell history
    set -Ux ERL_AFLAGS "-kernel shell_history enabled"

    pfetch

    # gentoo
    echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"

    # macos
    #echo -e "\033[0;32m"(date +%c)"\x1b[0m"

    source {$HOME}/.asdf/asdf.fish
    zellij setup --generate-completion fish | source

    # brew
    # source /opt/homebrew/opt/asdf/libexec/asdf.fish
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    starship init fish | source
    # zoxide init fish | source

    fish_add_path {$HOME}/.asdf/bin
    fish_add_path {$HOME}/.cargo/bin
    fish_add_path {$HOME}/.yarn/bin
    fish_add_path {$GOBIN}

    eval (ssh-agent -c) >/dev/null
    ssh-add -q
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

function z
    zellij ls -s | sort | awk '{printf "\033[32m%15s\033[0m\n", $1}'
    alias z="zellij"
end

function dockerls
    docker ps --format "table {{.Image}}\t{{.Ports}}\t{{.Names}}"
end
