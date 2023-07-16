if status is-interactive
    alias ls="exa"
    alias l="ls"
    alias ll="ls -l"
    alias l1="ls -1"
    alias vim="nvim"
    alias vimdiff="nvim -d"
    alias diffk='kitty +kitten diff'

    set -U GOPATH {$HOME}/Code/go/bin

    # pip --user paths
    #set -Ux PYTHONPATH (python -c "import site; print(site.USER_SITE)")
    #set -Ux SCIPY_PIL_IMAGE_VIEWER sxiv

    pfetch
    # gentoo
    echo -e "\x1b[38;2;0;112;248m"(date +%c)"\x1b[0m"

    # macos
    #echo -e "\033[0;32m"(date +%c)"\x1b[0m"

    # asdf
    source {$HOME}/.asdf/asdf.fish

    starship init fish | source
    zoxide init fish | source

    fish_add_path {$HOME}/.cargo/bin
    fish_add_path {$HOME}/.asdf/bin
    fish_add_path {$HOME}/go/bin
end
