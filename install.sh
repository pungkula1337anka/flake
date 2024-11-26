#!/usr/bin/env bash
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
ENDCOLOR="\e[0m"

# Function to display the duck moving below the ASCII art
function move_duck {
    duck="
      _
   __(.)<
   \\_)_)
"
    cols=$(tput cols) # Get terminal width
    colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$MAGENTA" "$CYAN") # Array of colors
    for ((i=0; i<$cols; i++)); do
        clear
        # Display the ASCII art at the top
        echo -e "$YELLOW
██████╗ ██╗   ██╗███╗   ██╗ ██████╗ ██╗  ██╗██╗   ██╗██╗      █████╗ 
██╔══██╗██║   ██║████╗  ██║██╔════╝ ██║ ██╔╝██║   ██║██║     ██╔══██╗
██████╔╝██║   ██║██╔██╗ ██║██║  ███╗█████╔╝ ██║   ██║██║     ███████║
██╔═══╝ ██║   ██║██║╚██╗██║██║   ██║██╔═██╗ ██║   ██║██║     ██╔══██║
██║     ╚██████╔╝██║ ╚████║╚██████╔╝██║  ██╗╚██████╔╝███████╗██║  ██║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
$ENDCOLOR"
        echo -e "$BLUE https://github.com/pungkula1337anka $ENDCOLOR"
        echo
        # Display the moving duck below the art
        color=${colors[$((i % ${#colors[@]}))]} # Cycle through colors
        printf "%${i}s\n" "$(echo -e "${color}${duck}${ENDCOLOR}")"
        sleep 0.1
    done
}

# Typing animation for text
function type_text {
    text="$1"
    delay=${2:-0.05}
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo
}

# Main script
clear
type_text "$YELLOW
██████╗ ██╗   ██╗███╗   ██╗ ██████╗ ██╗  ██╗██╗   ██╗██╗      █████╗ 
██╔══██╗██║   ██║████╗  ██║██╔════╝ ██║ ██╔╝██║   ██║██║     ██╔══██╗
██████╔╝██║   ██║██╔██╗ ██║██║  ███╗█████╔╝ ██║   ██║██║     ███████║
██╔═══╝ ██║   ██║██║╚██╗██║██║   ██║██╔═██╗ ██║   ██║██║     ██╔══██║
██║     ╚██████╔╝██║ ╚████║╚██████╔╝██║  ██╗╚██████╔╝███████╗██║  ██║
╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝
$ENDCOLOR" 0.01
type_text "$BLUE   https://github.com/pungkula1337anka $ENDCOLOR" 0.02
type_text "$RED TO MAKE SURE EVERYTHING RUNS CORRECTLY $ENDCOLOR" 0.02
type_text "$GREEN RUN AS ROOT 'sudo bash install.sh' $ENDCOLOR" 0.02

# Animate the duck
move_duck

echo
type_text "Type your desired $GREEN username $ENDCOLOR" 0.02
read user
echo
type_text "$GREEN Moments.... $ENDCOLOR" 0.02
sleep 1
cp -r .config ~/
type_text "Your username is $GREEN \"$user\" $ENDCOLOR" 0.02
read -p " Are you sure? " -n 1 -r
echo

type_text "For $GREEN Hyprland type y $ENDCOLOR $YELLOW Gnome type n $ENDCOLOR" 0.02
read -p " (y)Hyprland (n)Gnome " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    type_text "            👋 $GREEN $user on Hyprland $ENDCOLOR          " 0.02
elif [[ $REPLY =~ ^[Nn]$ ]]; then
    type_text "            👋 $GREEN $user on Gnome $ENDCOLOR          " 0.02
fi

