# dotfiles and desktop config

## Setup

- window manager: [plasma (kde5)](https://wiki.gentoo.org/wiki/KDE) with [i3wm](https://i3wm.org/docs/userguide.html)
- login manager: sddm
- compsition manager: compton
- terminal: [urxvt](https://wiki.archlinux.org/index.php/Rxvt-unicode)
- fonts: dina, google droid sans, adobe source code sans/serif
- background changers: feh / nitrogen
- audio: [pulseaudio](https://wiki.archlinux.org/index.php/PulseAudio) and [mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon/Tips_and_tricks#Local_(with_separate_mpd_user))
- init: [systemd](https://access.redhat.com/articles/systemd-cheat-sheet)

## Misc Commands

```markdown
$ xset m 1/4 1

$ systemctl suspend

$ journalctl -xfu sshd
```

## References

UI: based on this post / github

https://www.reddit.com/r/unixporn/comments/64mihc/i3_kde_plasma_a_match_made_in_heaven/

https://i3wm.org/docs/userguide.html

second link will get mpd to show as a volume slider in pavucontrol

https://wiki.archlinux.org/index.php/PulseAudio

https://wiki.archlinux.org/index.php/PulseAudio#Music_Player_Daemon_(MPD)


gentoo kernel config

https://wiki.gentoo.org/wiki/Power_management/Processor

https://wiki.gentoo.org/wiki/AMDGPU
