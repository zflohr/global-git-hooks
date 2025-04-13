# This module contains functions for printing notifications during
# different stages of global git hooks.

########################################################################
# Print a colorized message to stdout or stderr.
# 
# Screen operations are performed by manipulating the terminfo database
# via terminal-independent ncurses routines.
#
# Arguments:
#   1: An integer, which indicates to which data stream to send the
#      message: zero for stdout, non-zero for stderr.
#   2: The foreground color for the message. The color may be a name or
#      an integer. If an integer, it will be the argument to the
#      "setaf" terminal capability. 
#   3: A message to print.
#
# Outputs:
#   Writes $3 to stdout if $1 is zero.
#   Writes $3 to stderr if $1 is non-zero.
#
# Returns:
#   0
########################################################################
print_message() {
    local -r MESSAGE="\n${3}"
    local -i foreground_color=7
    case "${2}" in
        'black')
            foreground_color=0
        ;;
        'red')
            foreground_color=1
        ;;
        'green')
            foreground_color=2
        ;;
        'yellow')
            foreground_color=3
        ;;
        'blue')
            foreground_color=4
        ;;
        'magenta')
            foreground_color=5
        ;;
        'cyan')
            foreground_color=6
        ;;
        'white')
            foreground_color=7
        ;;
        'gold')
            foreground_color=11
        ;;
        [[:digit:]]*)
            foreground_color=${2}
        ;;
    esac
    tput sgr0 2> /dev/null                          # Turn off all attributes
    (( ${1} )) && tput rev 2> /dev/null             # Turn on reverse video mode
    tput bold 2> /dev/null                          # Turn on bold mode
    tput setaf ${foreground_color} 2> /dev/null     # Set foreground color
    (( ${1} )) && echo -e "${MESSAGE}" >&2 || echo -e "${MESSAGE}"
    tput sgr0 2> /dev/null                          # Turn off all attributes
    return 0
}

print_hook_type_progress() {
    case "${2}" in
        'start')
            print_message 0 "blue" "Running global ${1} hook..."
        ;;
        'end')
            print_message 0 "blue" "Global ${1} hook completed."
        ;;
    esac
}
