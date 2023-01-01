# https://ittavern.com/getting-started-with-tmux/
set -g default-command /bin/zsh
set -g prefix C-a

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind-key -n M-h select-pane -L
bind-key -n M-j select-pane -D
bind-key -n M-k select-pane -U
bind-key -n M-l select-pane -R

bind-key -n M-s split-window -v
bind-key -n M-S split-window -h 
