# === Prompt ====
PS1="[\A \u@\h \w]$ "


# === Aliases ====
alias sudo="sudo "
alias ls="ls --color"
alias caps="xmodmap ~/.Xmodmap"
alias CAPS="xdotool key Caps_Lock"

# --- IPA Tools ---
alias dev-vm='/home/tkrizek/Projects/labtool/vptool'
alias ipatool='/home/tkrizek/git/freeipa-tools/ipatool'
alias dev-syncvm='/home/tkrizek/git/freeipa-tools/dev-syncvm.sh'
alias dev-ci-lab-pssh="pssh -p 10 -t 0 -O 'StrictHostKeyChecking no' -h ~/dev/vm-ci-hosts"

# --- SSH (multiple configs)
alias compile-ssh-config='echo -n > ~/.ssh/config && cat ~/.ssh/*.config > ~/.ssh/config'
alias ssh='compile-ssh-config && ssh'
alias scp='compile-ssh-config && scp'
alias mosh='compile-ssh-config && mosh'
alias pssh='pssh -p 10 -t 0 -O "StrictHostKeyChecking no"'

# --- Programs ---
alias emacs='/usr/bin/emacs -nw'


# === Functions ===
dev-scp() {
    scp $1 $2:/usr/lib/python2.7/site-packages/$1
}

dev-pep8() {
    git diff HEAD~${1:-1} -U0 | pep8 --diff
}


# === Console editor ===
export VISUAL="/usr/bin/emacs -nw"
export EDITOR="$VISUAL"


# === Variables ===
# --- ABC virtual lab ---
export ABC="abc.idm.lab.eng.brq.redhat.com"


# === Color Scheme ===
eval `dircolors /home/tkrizek/git/gnome-terminal-colors-solarized/dircolors`
