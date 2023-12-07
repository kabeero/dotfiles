if status is-interactive
    alias ls="exa"
    alias l="ls"
    alias ll="ls -l"
    alias l1="ls -1"
    alias vim="nvim"
    alias vimdiff="nvim -d"
    alias diffk="kitty +kitten diff"
    alias jless="jless -r"

    set -g EDITOR nvim

    set -U GOPATH {$HOME}/Code/go
    set -U GOBIN {$GOPATH}/bin

    # pip --user paths
    #set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
    #set -Ux SCIPY_PIL_IMAGE_VIEWER sxiv

    # gentoo
    echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"

    # macos
    #echo -e "\033[0;32m"(date +%c)"\x1b[0m"

    # asdf
    source {$HOME}/.asdf/asdf.fish

    # brew
    # eval "$(/opt/homebrew/bin/brew shellenv)"

    starship init fish | source
    zoxide init fish | source

    fish_add_path {$HOME}/.cargo/bin
    fish_add_path {$HOME}/.asdf/bin
    fish_add_path {$HOME}/go/bin

    pfetch
end

# jump to directory
function d

    set apps fzf

    for a in $apps
        if ! command -v $a >/dev/null
            echo "❗ Please install $a"
            return
        end
    end

    set flags +s -e

    if test $status -gt 0
        cd $(dirname $(echo $1 | fzf $flags))
    else
        cd $(dirname $(fzf $flags))
    end

end

# edit file
function e

    set apps fzf nvim

    for a in $apps
        if ! command -v $a >/dev/null
            echo "❗ Please install $a"
            return
        end
    end

    set flags +s -e

    if test $status -gt 0
        nvim $(echo $1 | fzf $flags)
    else
        nvim $(fzf $flags)
    end

end
