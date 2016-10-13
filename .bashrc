# === Prompt ====
PS1="[\A \u@\h \w]$ "


# === Aliases ====
alias sudo="sudo "
alias ls="ls --color"
alias caps="xmodmap ~/.Xmodmap"

# --- IPA Tools ---
alias vptool='/home/tkrizek/Projects/labtool/vptool'
alias ipatool='/home/tkrizek/git/freeipa-tools/ipatool'
alias dev-syncvm='/home/tkrizek/git/freeipa-tools/dev-syncvm.sh'

# --- SSH (multiple configs)
alias compile-ssh-config='echo -n > ~/.ssh/config && cat ~/.ssh/*.config > ~/.ssh/config'
alias ssh='compile-ssh-config && ssh'
alias scp='compile-ssh-config && scp'
alias mosh='compile-ssh-config && mosh'

# --- Programs ---
alias emacs='/usr/bin/emacs -nw'


# === Functions ===
dev-scp() {
    scp $1 $2:/usr/lib/python2.7/site-packages/$1
}


# === Console editor ===
export VISUAL="/usr/bin/emacs -nw"
export EDITOR="$VISUAL"


# === Variables ===
# --- ABC virtual lab ---
export ABC="abc.idm.lab.eng.brq.redhat.com"


# === Color Scheme ===
eval `dircolors /home/tkrizek/git/gnome-terminal-colors-solarized/dircolors`
