#!/usr/bin/bash

# Tmux Installation
sudo apt-get update 
sudo apt-get install -y tmux

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Tmux.conf 
echo "
# Tmux Options
set -g status off 
set -g mouse on

# Tmux Plugin Manager

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Mouse Mode
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @scroll-speed-num-lines-per-scroll 1

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
" > ~/.tmux.conf

# Install plugins 
~/.tmux/plugins/tpm/scripts/install_plugins.sh
