#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t foo); then

tmux new-session -d -s foo -n zsh

# Create windows
tmux new-window -t foo:1 -n editor
tmux new-window -t foo:2 -n servers
tmux new-window -t foo:3 -n workers
tmux new-window -t foo:4 -n tests
tmux new-window -t foo:5 -n console

# Setup one app
tmux send-keys -t foo:0 'cd ~/dev/foo' C-m
tmux send-keys -t foo:1 'cd foo && vim .' C-m
tmux send-keys -t foo:2 'cd foo && rails s' C-m
tmux send-keys -t foo:3 'cd foo && ./script/resque.sh' C-m
tmux send-keys -t foo:4 'cd foo && spork' C-m
tmux send-keys -t foo:5 'cd foo && rails c' C-m

# Setup second app
tmux new-window -t foo:6 -n 'bar editor'
tmux splitw -t foo:servers
tmux splitw -t foo:workers
tmux splitw -t foo:console
tmux send-keys -t foo:6 'cd ~/dev/bar && vim .' C-m

tmux select-layout -t foo:servers even-horizontal
tmux select-window -t foo:servers
tmux select-pane -t right
tmux send-keys 'cd ~/dev/bar && rails s -p 3001' C-m

tmux select-layout -t foo:workers even-horizontal
tmux select-window -t foo:workers
tmux select-pane -t right
tmux send-keys 'cd ~/dev/bar && ./script/resque.sh' C-m

tmux select-layout -t foo:console even-horizontal
tmux select-window -t foo:console
tmux select-pane -t right
tmux send-keys 'cd ~/dev/bar && rails c' C-m


tmux select-window -t foo:1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t foo
else
    tmux -u switch-client -t foo
fi
