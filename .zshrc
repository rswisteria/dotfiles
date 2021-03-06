# -*- sh-shell: zsh; -*-

[[ "$MY_ZSHENV" = MY_ZSHENV ]] && . ~/.zshenv

bindkey -e

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

setopt extended_glob
setopt noautoremoveslash
setopt correct
setopt list_packed
setopt nolistbeep

setopt auto_param_keys
setopt auto_param_slash
setopt complete_aliases
setopt numeric_glob_sort

setopt equals
setopt magic_equal_subst

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_space
setopt share_history
setopt extended_history

autoload -U compinit && compinit

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

case "${OSTYPE}" in
freebsd*|darwin*)
    if [ $(which ls | grep gnubin) ]
    then
        ls=coreutils
    else
        ls=bsdls
    fi
    ;;
linux*)
    ls=coreutils
    ;;
esac

# 環境に合わせて出来るだけ好みのls出力にする
# http://qiita.com/kawaz/items/a44f42bd5099efaab431
if [ "$ls" = "bsdls" ]; then
   alias ls='ls -G -w'
elif ls -d -N >/dev/null 2>&1; then
  # 最近の gnubin/ls が勝手にファイル名をクオート出力してくるのを抑止
  alias ls='ls --color --time-style +%Y-%m-%d\ %H:%M:%S.%3N -N'
elif ls -d --time-style +%Y-%m-%d\ %H:%M:%S.%3N >/dev/null 2>&1; then
  # デフォの時間表示は見難いのでISOぽくする(full-iso,long-iso,isoは帯に短し襷に長しなのでカスタム)
  alias ls='ls --color --time-style +%Y-%m-%d\ %H:%M:%S.%3N'
elif ls -d --color >/dev/null 2>&1; then
  # せめて色だけでも…
  alias ls='ls --color'
fi

autoload colors && colors

foobar () {
case ${UID} in
0)
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac
}

fpath=(
    $HOME/local/zsh/completions(N-/)
    $HOME/local/zsh/functions(N-/)
    $fpath
)

case ${UID} in
0)
    PROMPT="%{${fg[blue]}%}%n%{${reset_color}%} %{${fg[blue]}%}#%{${reset_color}%} "
    PROMPT2="%B%{${fg[blue]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    RPROMPT="%{${fg[blue]}%}[%/]%{${reset_color}%}"
    ;;
*)
    PROMPT="%n %{${fg[blue]}%}%%%{${reset_color}%} "
    PROMPT2="%B%{${fg[blue]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    RPROMPT="%{${fg[blue]}%}[%/]%{${reset_color}%}"
    ;;
esac

case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

case "${TERM}" in
xterm|xterm-color)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

if [ -f /Applications/MacVim.app/Contents/MacOS/Vim ]
then
  alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
fi

alias Emacs=$(which emacs)
alias emacs="emacs -nw"
alias あ=ag
alias s=ls
alias be="bundle exec"
alias tmxu=tmux
alias tumx=tmux
alias Tree=$(which tree)

tree(){
    Tree -C $* | less -R
}


jqless(){ cat ${1:--} | jq ${2:-.} -C | less -R }

if which xsel > /dev/null
then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi

export RAILS_ENV=development
export MICRO_TRUECOLOR=1

export PHAN_BIN=$HOME/.composer/vendor/bin/phan

# iTerm2 shell integration
[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && . "${HOME}/.iterm2_shell_integration.zsh"

[[ -e "${HOME}/pixiv/dev-script/init_nodenv" ]] && eval "$("${HOME}/pixiv/dev-script/init_nodenv" -)"

[[ -e "$HOME/local/dotfiles/ttcopy/ttcp_activate.sh" ]] && . "$HOME/local/dotfiles/ttcopy/ttcp_activate.sh"

#PERL_MB_OPT="--install_base \"/Users/megurine/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/Users/megurine/perl5"; export PERL_MM_OPT;

phptags(){
    ctags -e --php-types=c+i+d+f $(git ls-files '*.php')
}

vld () {
    php -dvld.active=1 -dvld.execute=0 "$@" 2>&1
}
