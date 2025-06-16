function __dev_complete --description "Completion for dev command"
    if test -d "$DOTFILES/dev_envs"
        ls $DOTFILES/dev_envs/
    end
end

complete -c dev -f -a "(__dev_complete)"