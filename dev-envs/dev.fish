function dev --description "Launch development environment" --argument env_name
    if test -z "$env_name"
        echo "Available environments:"
        echo "  go"
        return 1
    end

    switch $env_name
        case go
            nix develop $DOTFILES/dev-envs#go -c fish
        case "*"
            echo "Environment '$env_name' not found"
            echo "Available environments:"
            echo "  go"
            return 1
    end
end
