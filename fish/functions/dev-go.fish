function dev-go --description "Launch Go development environment"
    cd $DOTFILES/dev_envs/go && nix develop
end