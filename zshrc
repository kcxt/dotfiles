# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format '%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%p%s'
zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' gain-privileges 1
zstyle :compinstall filename '/home/caleb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory
#setopt appendhistory autocd
#unsetopt extendedglob nomatch notify

export TERM=xterm-256color
export EDITOR=$(which xed)

alias cfz="$EDITOR $HOME/.zshrc"
alias ls="ls --color=auto -h -k -s"

alias x="chmod +x"
alias sz="source ~/.zshrc"

alias vim=nvim

alias history="history 0" #Get all history not just last 5 commands

# End of lines configured by zsh-newuser-install
source $HOME/Documents/Software/powerlevel10k/powerlevel10k.zsh-theme
#source ~/powerlevel10k/.purepower

# This is important, it makes keybinds work...
bindkey -e

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Enable autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Created by `userpath` on 2019-10-29 14:18:59
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


################
### MY STUFF ###
################

# YUCK
export PATH="$PATH:/snap/bin"

# ccache must be before /usr/bin so that we get cache hits
export PATH="/usr/lib/ccache/bin:$PATH"

export EDITOR=$(which nvim) 


## POSTMARKETOS

# Enable autocomplete for pmbootrstrap commands
autoload bashcompinit
bashcompinit
eval "$(register-python-argcomplete pmbootstrap)"

alias marm="make O=.output/ ARCH=arm CROSS_COMPILE=/usr/bin/arm-none-eabi- -j13"

local PMENV=$HOME/pmos/tools/pmenv
[[ -f $PMENV ]] && source $PMENV


## Sailfish crap

export PLATFORM_SDK_ROOT="/srv/mer"
export ANDROID_ROOT="$HOME/sfos/hadk"
alias sfossdk="$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot"


## Android crap

# makekernelflash: create a flashable AnyKernel3 zip
# takes path to ak3 source and kernel image
# $1: kernel image.gz-dtb
# $2: the directory with the root of the zip file
# $3: Target zip file
makekernelflash() {
	echo $0: Copying $(basename $1) to $2
	cp $1 $2/Image.gz-dtb
	OUT=$3
	echo $0: Creating $OUT
	pushd $2 > /dev/null
	zip -r9 $OUT * -x .git README.md
	popd > /dev/null
}

# Start polkit and keyring before sway
alias w="[[ ! -f /tmp/sway-started ]] && source .swayinit; sway"
alias g="if [[ -z '$DISPLAY' && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then; MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session; fi"
