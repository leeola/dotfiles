# A pipe friendly `bc` but make it work with helix/etc.
function bcp
    read input
    echo "$input" | bc | string trim
end

