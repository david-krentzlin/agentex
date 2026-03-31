# Catppuccin Mocha (black background) for tmux

set-option -g status-position "bottom"
set-option -g status-style bg=#1e1e2e,fg=#cdd6f4
set-option -g status-left '#[bg=#1e1e2e,fg=#cdd6f4,bold]#{?client_prefix,,  tmux  }#[bg=#89b4fa,fg=#000000,bold]#{?client_prefix,  tmux  ,}'
set-option -g status-right '#[bg=#1e1e2e,fg=#bac2de] #S '
set-option -g window-status-format '#[bg=#1e1e2e,fg=#a6adc8] #I:#W '
set-option -g window-status-current-format '#[bg=#89b4fa,fg=#000000,bold] #I:#W#{?window_zoomed_flag,  zoom , }'
set-option -g pane-border-style fg=#45475a
set-option -g pane-active-border-style fg=#89b4fa
set-option -g message-style bg=#1e1e2e,fg=#cdd6f4
