#!/usr/bin/expect

# Use this script to fill password in shell prompts
# call this script the first argument should be the password, the second one the password to prompt to fill and the third the command to be run

set timeout 20

set cmd [lrange $argv 2 end]
set prompt [lindex $argv 1]
set password [lindex $argv 0]

eval spawn $cmd
expect $prompt
send "$password\r";
interact
