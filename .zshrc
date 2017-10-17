#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

alias ls='ls -Ah --group-directories-first --color=auto'
alias pingg='ping -c 3 8.8.8.8'
alias tpack='tar -zxvf'
alias pkgs='comm -23 <(pacman -Qeq | sort) <(pacman -Qgq base base-devel | sort)'
alias picin='feh -g 1366x768 -d -S filename'
alias wific='sudo wifi-menu'
#alias minecraft='java -jar /home/kirk/Games/Minecraft.jar'
alias ppingg='pping -c 10 8.8.8.8'
alias runsteam="LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so' /usr/bin/steam"
alias hearthstone="wine /home/kirk/.PlayOnLinux/wineprefix/hearthstone/drive_c/Program\ Files/Battle.net/Battle.net.exe"
alias nls="sudo arp-scan --interface=wlp3s0 --localnet"

function findexe() {
  for ARG in $(pacman -Qql $1); do
    [ ! -d $ARG ] && [ -x $ARG ] && echo $ARG;
  done
}

#
# User configuration sourced by interactive shells
#

# Colors
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
zprompt_theme='eriner'

export ANDROID_SDK_ROOT=/home/kirk/Android/Sdk/
export EDITOR=vim
export PATH="/usr/lib/ccache/bin/:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export GEM_HOME=$(ruby -e 'print Gem.user_dir')

export PATH="/home/kirk/.rvm/bin/:$PATH"

