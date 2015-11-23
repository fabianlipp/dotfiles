# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true
test -s ~/.ls.bash && . ~/.ls.bash
test -s ~/.bashrc.private && . ~/.bashrc.private || true

if [ $EUID -eq 0 ]; then
        PROMPT_USER_COL=31
else
        PROMPT_USER_COL=32
fi
PS1='\[\033[01;${PROMPT_USER_COL}m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]> '

if [ $TERM = screen ]; then
	SCREENTITLE='\[\ek\e\\\]'
elif [ $TERM = xterm -o $TERM = "xterm-256color" ]; then
	# Aeussere eckige Klammer \[ und \], weil Zeilen in der Shell sonst nicht mehr
	# richtig bearbeitet werden koennen
	SCREENTITLE='\[\033]0;\w - \u@\h\007\]'
else
	SCREENTITLE=""
fi

#if test \( "$TERM" = "xterm" -o $TERM = "xterm-256color" \
		    #-o "${TERM#screen}" != "$TERM" \) \
		    #-a -z "$EMACS" -a -z "$MC_SID" -a -n "$DISPLAY" \
		    #-a ! -r $HOME/.bash.expert
#then
	#PS1="$(ppwd \l)${SCREENTITLE}${PS1}"
#else
	PS1="${SCREENTITLE}${PS1}"
#fi


MINLINESUSELESS=30
function dict() {
	RESULT=$(w3m -dump "http://pocket.dict.cc?s=\"$*\"" | sed -r -e '/^([ ]{5,}.*)$/d' -e '1,2d' -e '/^$/d' -e '/^\[/d')
	if [ $(echo "$RESULT" | wc -l) -gt $MINLINESUSELESS ]; then
		echo "$RESULT" | less
	else
		echo "$RESULT"
	fi
}

function leo() {
	RESULT=$(w3m -dump "http://pda.leo.org/?search=\"$*\"" | sed -n -e :a -e '1,9!{P;N;D;};N;ba' | sed -e '1,14d')
	if [ $(echo "$RESULT" | wc -l) -gt $MINLINESUSELESS ]; then
		echo "$RESULT" | less
	else
		echo "$RESULT"
	fi
}

function doi2bib() {
	if [[ $* == http://* ]]; then
		URL="$*"
	else
		URL="http://dx.doi.org/$*"
	fi
	curl -LH "Accept: application/x-bibtex" $URL
	echo
}

function formatjson() {
	if [ $# -gt 0 ]; then
		cat $1 | python -m json.tool | pygmentize -l javascript -O bg=dark
	else
		python -m json.tool | pygmentize -l javascript -O bg=dark
	fi
}
#function formatjson="python -m json.tool | pygmentize -l javascript -O bg=dark"


eval "$(dircolors ~/.dircolors)"

alias svnkdiff='svn diff --diff-cmd kdiff3'
alias svnoodiff='svn diff --diff-cmd oodiff'
alias svn='colorsvn'
alias gitka='gitk --all &'
alias gittree='git log --all --graph --decorate --oneline'
alias lolistener='soffice "--accept=socket,host=localhost,port=2002;urp;"'

alias gvimlatex="gvim --servername latex"
complete -f -o default -X '!*.tex' gvimlatex

alias lualatexmk='latexmk -pdflatex="lualatex --halt-on-error --synctex=1 %O %S"'
complete -f -o default -X '!*.tex' lualatex lualatexmk

export FIGNORE=".svn:.DS_Store"

# kpdf-Alias nur, falls kpdf nicht vorhanden
if [ ! -e /opt/kde3/bin/kpdf ]; then
	alias kpdf="okular"
fi

# Special bin directory for my EeePC
if [[ $(hostname) == *eeepc* ]]; then
	export PATH="/home/fabian/bin/eeepc:$PATH"
fi

# Zeige Man-Pages farbig an
man() {
	# Farben aus OpenSUSE-Forum
	#export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
	#export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
	#export LESS_TERMCAP_me=$'\E[0m' # end mode
	#export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
	#export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
	#export LESS_TERMCAP_ue=$'\E[0m' # end underline
	#export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
	env \
		LESS_TERMCAP_mb=$'\E[01;31m' \
		LESS_TERMCAP_md=$'\E[01;31m' \
		LESS_TERMCAP_me=$'\E[0m' \
		LESS_TERMCAP_se=$'\E[0m' \
		LESS_TERMCAP_so=$'\E[38;5;246m' \
		LESS_TERMCAP_ue=$'\E[0m' \
		LESS_TERMCAP_us=$'\E[04;32m' \
		GROFF_NO_SGR=yes \
		man "$@"
}

# Settings for bash
HISTCONTROL=ignoreboth
HISTSIZE=1000


