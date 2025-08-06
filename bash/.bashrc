# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

alias safe-reboot='sudo akmods && sudo dracut --force && echo "NVIDIA module rebuilt. Ready to reboot!" && sudo reboot'
alias ssh_amarel="ssh nh385@amarel.rutgers.edu"

function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

# to allow KDE Connect to work over tailscale
#export KDECONNECT_USE_TCP=true

# Force GTK apps to use X11 in this KDE-on-X11 session
#export GDK_BACKEND=x11



# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
source $HOME/miniconda3/etc/profile.d/conda.sh

export PATH="$HOME/.local/bin:$PATH"
