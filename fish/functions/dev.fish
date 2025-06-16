function dev --description "Launch development environment" --argument env_name
    if test -z "$env_name"
        echo "Available environments:"
        ls $DOTFILES/dev_envs/
        return 1
    end
    
    set env_path "$DOTFILES/dev_envs/$env_name"
    if test -d "$env_path"
        cd "$env_path" && nix develop
    else
        echo "Environment '$env_name' not found in $DOTFILES/dev_envs/"
        return 1
    end
end