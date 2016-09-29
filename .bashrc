alias ls='ls -Ah --group-directories-first --color=auto'
alias pingg='ping -c 3 8.8.8.8'
alias tpack='tar -zxvf'
alias mvup='mv * .[^.]* ..'
alias pkgs='comm -23 <(pacman -Qeq | sort) <(pacman -Qgq base base-devel | sort)'
alias picin='feh -g 1366x768 -d -S filename'
alias wific='sudo wifi-menu'
alias lync='sky & disown & exit'
alias minecraft='java -jar /home/kirk/Games/Minecraft.jar'
alias ssh='TERM=linux ssh'
alias ppingg='pping -c 10 8.8.8.8'

export EDITOR="vim"

export ANDROID_HOME=/opt/android-sdk

PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

source /usr/share/doc/pkgfile/command-not-found.bash


#!/bin/sh
# Base16 Bespin - Shell color setup script
# Jan T. Sott

if [ "${TERM%%-*}" = 'linux' ]; then
    # This script doesn't support linux console (use 'vconsole' template instead)
    return 2>/dev/null || exit 0
fi

