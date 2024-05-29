# A helper to generate numbers with separators and padding.
# Args:
# - start incl
# - end incl
# - pad_count
# - sep chars
function nums
    set start (math $argv[1])
    set end (math $argv[2])
    set pad_count (math (test -n "$argv[3]"; and echo "$argv[3]"; or echo "1"))
    set sep (test "$argv[4]"; and echo "$argv[4]"; or echo ",")
    for i in (seq $start $end)
        printf "%0*d" $pad_count $i
        test "$i" != "$end"; and echo -n $sep
    end
end
