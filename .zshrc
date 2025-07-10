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
unsetopt extendedglob nomatch notify

if [ "$TERM" = "alacritty" ]; then
	export TERM=xterm-256color
fi

alias cfz="$EDITOR $HOME/.zshrc"
alias ls="ls --color=auto -h -k -s"

alias x="chmod +x"
alias sz="source ~/.zshrc"

alias history="history 0" #Get all history not just last 5 commands

# End of lines configured by zsh-newuser-install
if [ -f "$HOME/git/powerlevel10k/powerlevel10k.zsh-theme" ]; then
	source $HOME/git/powerlevel10k/powerlevel10k.zsh-theme
else
	source /usr/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
fi

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

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/home/cas/.local/share/gem/ruby/3.3.0/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

################
### MY STUFF ###
################

unlock_keyring() {
	echo -n 'Login password: ' >&2
	local _UNLOCK_PASSWORD
	read -s _UNLOCK_PASSWORD || return
	eval $(echo -n "${_UNLOCK_PASSWORD}" \
		| gnome-keyring-daemon --replace --unlock --components=pkcs11,secrets,ssh \
		| sed -e 's/^/export /')
	unset _UNLOCK_PASSWORD
	echo '' >&2
}

# ccache must be before /usr/bin so that we get cache hits
export PATH="/usr/lib/ccache/bin:$PATH"
#export PATH="/usr/lib/icecream/bin:$PATH"
#export CCACHE_PREFIX=icecc
#export ICECC_VERSION="$HOME/.config/icecc-aarch64-cc12b090d50df81f30c87fed74a68449.tar.gz"
#export PATH="/usr/lib/icecream/libexec/icecc/bin/:$PATH"

alias ik="import-key.sh"

# crosstools
export PATH=$PATH:$HOME/bin/crosstools/bin
export PATH=$PATH:$HOME/bin/arm-926ejs-eabi/bin
export PATH="$PATH:$HOME/bin/gcc-arm-none-eabi-10-2020-q4-major/bin"
export PATH="$PATH:$HOME/git/aarch64-linux-android-4.9/bin"

export EDITOR=$(which hx)

export VCPKG_DISABLE_METRICS=1

function b64() {
	echo -e "$(echo $1 | base64 -d)\n"
}

function hex() {
	val=$1
	# That is, assign pad to the second argument
	# "$2" if it is set, otherwise assign it to
	# the literal "2" - the default is to pad
	# to 2 characters
	pad=${2:-2}
	printf "0x%0${pad}x\n" $val
}

function bin() {
	val=$1
	pad=${2:-8}
	bin=$(echo "obase=2;${val}" | bc)
	printf "0b%0${pad}s\n" $val | tr ' ' '0'
}

# Pull environment from an application
function yoinkenv() {
	APP=${1:-phosh}
	echo "Yoinking environment from $APP"
	eval $(sudo cat /proc/`pidof $APP`/environ | tr '\0' '\n' | grep -v '^TERM=' | awk '{ print "export \"" $0 "\"" }')
}

## UBPORTS
local UBENV=$HOME/ubports/enchilada/documentation/ubenv
[[ -f $UBENV ]] && source $UBENV
## POSTMARKETOS

# Enable autocomplete for pmbootrstrap commands
autoload bashcompinit
bashcompinit
alias pmbootstrap="pmbootstrap --details-to-stdout"
eval "$(register-python-argcomplete pmbootstrap)"
alias pmb="pmbootstrap"
alias pmbt="~/pmos/pmb2/pmbootstrap.py -c $HOME/.config/pmbootstrap-test.cfg"
alias pmbc="pmbootstrap -c $HOME/.config/pmbootstrap-clean.cfg"
alias pmbg="~/git/pmbootstrap-glibc/pmbootstrap.py -c $HOME/.config/pmbootstrap-glibc.cfg"


alias mandroid="make CC=/usr/bin/clang O=.output/ ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- -j16"

local HOST_ARCH=$(uname -m)
local PMTOOLS=$HOME/pmos/tools/
[[ -f "$PMTOOLS"/pmenv ]] && source $PMTOOLS/pmenv
[[ -f "$PMTOOLS"/automation.sh ]] && source $PMTOOLS/automation.sh

## Sailfish crap

export PLATFORM_SDK_ROOT="/srv/mer"
export ANDROID_ROOT="$HOME/sfos/hadk"
alias sfossdk="$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot"


habuild () 
{ 
    source $HOME/.hadk.env;
    if [ -d "$ANDROID_ROOT/external" ]; then
        cd "$ANDROID_ROOT";
        source build/envsetup.sh;
        breakfast $DEVICE;
        export CCACHE_DISABLE=1;
        export TEMPORARY_DISABLE_PATH_RESTRICTIONS=true;
		export ALLOW_MISSING_DEPENDENCIES=true;
    fi
}

## ESP-12

export PATH="$PATH:/home/cas/esp/xtensa-lx106-elf/bin"
export IDF_PATH=~/esp/ESP8266_RTOS_SDK

## Pico SDK

export PICO_SDK_PATH="/usr/share/pico-sdk"

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

export PATH=$HOME/bin/arm-linux-androideabi-4.9/bin:$PATH
export PATH=$HOME/bin/aarch64-linux-android-4.9/bin:$PATH

# Start polkit and keyring before sway
alias w="$HOME/bin/swayinit"
alias c='git --git-dir=$HOME/.gitdotfiles/ --work-tree=$HOME'
alias rg="rg --vimgrep" # Always search hidden files with ripgrep
alias i="tmux attach -d -t weechat"
alias u='picocom $(rrst pty)'
alias xxd="xxd -a -R always"
alias less="less -R"
# USE HELIX
alias vim="hx"
alias pastebin="curl -F\"file=@-\" https://0x0.st"

ircloop() {
	while true; do
		while (tmux list-clients | grep -q weechat); do
			sleep 1	
		done
		tmux attach -d -t weechat || tmux
		sleep 3
	done
}


alias lion="ssh -t lion tmux attach -t weechat"

# Lei q alias
alias leiq="lei q -I https://lore.kernel.org/all/ --threads --dedupe=mid -jobs=,2"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

VSCODE_SUGGEST=1
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Common directories
alias aports="cd ~/.local/var/pmbootstrap/cache_git/aports_upstream"
alias pma="cd ~/.local/var/pmbootstrap/cache/git/pmaports"
alias ca="cd ~/.local/var/pmbootstrap-test/cache_git/caports"
alias k="cd ~/pmos/enchilada/kernel"
alias pmb="cd ~/pmos/pmbootstrap"

alias g="git"
alias ga="git add"
alias gas="git absorb"
alias gad="git add .;"
alias gap="git add --patch"
alias gs="git s"
alias gls="git ls"

alias gcp="git cherry-pick"
alias gcm="git c" # invoke git alias
alias gca="git commit --amend"
alias gcf="git commit --no-gpg-sign --fixup"
alias gf="git fixup"
alias grb="git rebase"
alias grbi="git rebase -i"
alias grsth="git reset --hard"
alias grst="git reset --soft"

# git-temp aliases
alias gt="git temp"
alias gtr="git temp restore"

# Stash stuff
alias gsp="git sp" # Stash push
alias gsa="git sa" # Stash apply
alias gpo="git pop" # Stash pop
alias gpop="git pop;" # Stash pop head
alias gsl="git stash list"
alias gsc="git stash clear"

alias paccept="b4 shazam -s -k -S -l"

gco() {
	if [ -e "$(git rev-parse --git-path CHERRY_PICK_HEAD)" ]; then
		git cherry-pick --continue
	else
		git rebase --continue
	fi
}
gab() {
	if [ -e "$(git rev-parse --git-path CHERRY_PICK_HEAD)" ]; then
		git cherry-pick --abort
	else
		git rebase --abort
	fi
}

# restic
alias restic-lion="restic -r sftp:noah:/mnt/raid/Documents/Caleb/Backups/restic-lion"

# par - format paragraphs in nvim
export PARINIT='Tbgq B=.,?_A_a Q=_s>|'

PATH="/home/cas/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/cas/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/cas/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/cas/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/cas/perl5"; export PERL_MM_OPT;

[[ -n "$ASCIINEMA_REC" ]] || tore

eval "$(zoxide init --cmd cd zsh)"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
