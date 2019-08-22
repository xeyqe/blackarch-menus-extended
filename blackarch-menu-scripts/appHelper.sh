#! /bin/bash
# 
# THIS PROGRAM WILL: Open the terminal, execute a command, and keep the terminal open.
# The intention is that you call this script from a menu launcher and include an argument in your command. (SEE BELOW)
#
# Darrin Goodman (http://www.hilltopyodeler.com/blog) > hilltopyodeler@gmail.com
# Credit is due to 13u11fr09 through his/her thread at http://ubuntuforums.org/archive/index.php/t-296628.html
# Go to the link above for more ideas and philosophies on this subject.
#
# This script should be called from your panel/menu launcher using a command structure
# that will launch your terminal emulator, then call on this shell script, and then provide
# an argument that is taken in by this script ("$1" or $@); this argument tells the script 
# which command to run (for instance: nmap --help).
# SYNTAX: [command] [path/to/helperScript.sh] [argument]
# 
# PLEASE NOTE THAT:
#	- "USER" SHOULD BE CHANGED TO YOUR OWN USERNAME BELOW
#	- CHANGE "nmap --help" TO WHATEVER IS SPECIFIC TO YOUR NEEDS.
#	- MAKE SURE THAT helperScript.sh IS EXECUTABLE (chmod 755 helperScript.sh)
#
# The command you should use in your panel/menu launcher is as follows.
#   For gnome-terminal, use: gnome-terminal -x /home/USER/helperScript.sh nmap --help
#   For xterm, use: xterm -e /home/USER/helperScript.sh nmap --help
#   For Terminator, use: terminator -x /home/USER/helperScript.sh nmap --help
# [-x] and [-e] are the flags for "execute".
#	Note: for some reason, "terminator -x" will launch some things in Terminator,
#	but not others; not sure why at this time.
# 
# The reference below to /bin/bash tells the terminal to keep a bash shell open and running.
$@
/bin/bash
