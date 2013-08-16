

set PATH ~/.bin ~/.n/bin $PATH
set -x N_PREFIX ~/.n

# This set of stty code has all been commented out due to
# the fact that stty has issues with Fish. Instead, i run
# stty in bash_profile before calling fish, which resolves
# the issue
# stty ixany
# stty ixoff -ixon
# stty -ixon; screen -e \^Ss

