

set PATH ~/.bin ~/.n/bin $PATH
set -x N_PREFIX ~/.n

# This set of stty code has all been commented out due to
# the fact that stty has issues with Fish. Instead, i run
# stty in bash_profile before calling fish, which resolves
# the issue
# stty ixany
# stty ixoff -ixon
# stty -ixon; screen -e \^Ss

# Fish Greeting
set fish_greeting "
  _  __         _ _             
 | |/ /        | (_)            
 | ' / ___   __| |_ _ __   __ _ 
 |  < / _ \ / _` | | '_ \ / _` |
 | . \ (_) | (_| | | | | | (_| |
 |_|\_\___/ \__,_|_|_| |_|\__, |
                           __/ |
      Make something!     |___/ 
"
