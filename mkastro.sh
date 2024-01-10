#!/usr/bin/env bash

# Scirpt para crear un proyecto de astro basado en los proyectos que yo utilizo ^^

# === Colors ===
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RES="$(tput sgr 0)"
BOLD="$(tput bold)"
UNDERLINE="$(tput smul)"
ITALIC="$(tput sitm)"
INVERT="$(tput smso)"

BBLACK="$(tput setab 0)"
BRED="$(tput setab 1)"
BGREEN="$(tput setab 2)"
BYELLOW="$(tput setab 3)"
BBLUE="$(tput setab 4)"
BMAGENTA="$(tput setab 5)"
BCYAN="$(tput setab 6)"
BWHITE="$(tput setab 7)"
BRES="$(tput sgr 0)"

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

echo "
╭─────╮  Houston:
│ ● $(tput setaf 2)◡ $(tput sgr 0)●  Bienvenido, Astronauta 🚀 
╰─────╯
"

if [ -z "$1" ]; then
  read -p "$(tput bold)$(tput setab 6)$(tput setaf 0) Name Project:$(tput sgr 0) " PROJECT_NAME
else
  PROJECT_NAME="$1"
fi

command git clone https://github.com/spectrasonic117/astro-template.git -q $PWD/$PROJECT_NAME

cd $PWD/$PROJECT_NAME

printf '{
  "name": "'${PROJECT_NAME}'",
  "type": "module",
  "version": "0.0.1",
  "scripts": {
    "dev": "astro dev --open",
    "start": "astro dev --open",
    "build": "astro check && astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
  "dependencies": {
    "@astrojs/check": "latest",
    "astro": "latest",
    "typescript": "latest"
  },
    "devDependencies": {
    "@typescript-eslint/parser": "latest",
    "eslint": "latest",
    "eslint-plugin-astro": "latest",
    "eslint-plugin-jsx-a11y": "latest",
    "normalize.css": "latest",
    "prettier": "latest",
    "prettier-config-standard": "latest",
    "prettier-plugin-astro": "latest",
    "sass": "latest"
  }
}' > package.json

# echo "
# ╭─────╮  Houston:
# │ ♡ $(tput setaf 2)◡ $(tput sgr 0)♡  $(tput setaf 2)package.json creado! $(tput sgr 0)✅
# ╰─────╯
# "
sleep 1


echo "
╭─────╮  Houston:
│ ● $(tput setaf 2)◡ $(tput sgr 0)●  $(tput setaf 2)Selecciona gestor $(tput sgr 0)
╰─────╯  $(tput setaf 2)de paquetes 📦 $(tput sgr 0) $(tput setaf 6)
"
options=("bun" "npm" "pnpm")
select_option "${options[@]}"
choice=$?
PKGMANAGER="${options[$choice]}"

command ${PKGMANAGER} install

echo "
╭─────╮  Houston:
│ ᗒ $(tput setaf 2)ᗜ $(tput sgr 0)ᗕ  $(tput setaf 2)Dependencias Instaladas! $(tput sgr 0)📦
╰─────╯
"
sleep 1

if [ -d .git ]; then
  echo "$(tput setaf 3)Removing .git directory... $(tput sgr 0)"
  command rm -rf .git/
  echo "
╭─────╮  Houston:
│ ¬ $(tput setaf 1)⌒ $(tput sgr 0)¬  $(tput setaf 1)Antiguo .git Removido! $(tput sgr 0)❌
╰─────╯
"
sleep 1
fi

command git init -q
echo "
╭─────╮  Houston:
│ ● $(tput setaf 2)◡ $(tput sgr 0)●  $(tput setaf 2)Repositorio Creado $(tput sgr 0)📦 
╰─────╯
"
sleep 1

command rm -rf ./install.sh

sleep 1

# PROJECT_NAME=TESTING
echo "

╭─────╮  Houston:
│ ◠ $(tput setaf 2)◡ $(tput sgr 0)◠  $(tput setaf 2)Proyecto $(tput setab 2)$(tput setaf 0) $PROJECT_NAME $(tput sgr 0) $(tput setaf 2)Creado$(tput sgr 0) ✅
╰─────╯  Buena suerte, Astronauta 🚀

"