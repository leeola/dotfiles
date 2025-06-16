function __dev_complete --description "Completion for dev command"
    echo "go"
end

complete -c dev -f -a "(__dev_complete)"