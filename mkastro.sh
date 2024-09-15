#!/usr/bin/env bash

# ███╗   ███╗██╗  ██╗     █████╗ ███████╗████████╗██████╗  ██████╗
# ████╗ ████║██║ ██╔╝    ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗
# ██╔████╔██║█████╔╝     ███████║███████╗   ██║   ██████╔╝██║   ██║
# ██║╚██╔╝██║██╔═██╗     ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║
# ██║ ╚═╝ ██║██║  ██╗    ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝
# ╚═╝     ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝
# Script developed by Spectrasonic
# This Script use biome as linter and formatter

# === Colors ===
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr 0)"
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
BRESET="$(tput sgr 0)"

SVELTE="$(tput setaf 202)"
VUE="$(tput setaf 85)"

DEPENDENCIES="@astrojs/check astro typescript css.normalizer sass @biomejs/biome"

function select_option {

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

	for opt; do printf "\n"; done

	local lastrow=`get_cursor_row`
	local startrow=$(($lastrow - $#))

	trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
	cursor_blink_off

	local selected=0
	while true; do
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

		case `key_input` in
			enter) break;;
			up)    ((selected--));
				   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
			down)  ((selected++));
				   if [ $selected -ge $# ]; then selected=0; fi;;
		esac
	done

	cursor_to $lastrow
	printf "\n"
	cursor_blink_on

	return $selected
}

echo "
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  Bienvenido, Astronauta 🚀 
╰─────╯  ${CYAN}${USER}${RESET} ${GREEN}Listo para crear un nuevo proyecto${RESET} 🛠️
"

if [ -z "$1" ]; then
  read -p "${BCYAN}${BLACK} Name Project:${RESET} " PROJECT_NAME
elif [ -d "$1" ]; then
  echo "${RED}El proyecto ya existe."
  exit 1
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo "${RED}Usage:"
  echo "${GREEN}mkastro ${BLUE}<project-name> <tailwind|unocss> <preact|react|svelte|vue>${RESET}"
  exit 1
else
  PROJECT_NAME="$1"
fi

git clone -b astrobiome https://github.com/spectrasonic117/astro-template.git -q $PWD/$PROJECT_NAME
cd $PWD/$PROJECT_NAME

printf '{
  "name": "'${PROJECT_NAME}'",
  "type": "module",
  "version": "1.0.0",
  "scripts": {
	"dev": "astro dev --open",
	"start": "astro dev --open",
	"build": "astro check && astro build",
	"preview": "astro preview",
	"astro": "astro",
	"lint": "biome lint --write .",
    "lint:fix": "biome check --write .",
	"format": "biome format --write ./src"
  }
}' > package.json
sleep 1


echo "╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  ${GREEN}Selecciona gestor ${RESET}
╰─────╯  ${GREEN}de paquetes 📦 ${RESET} ${CYAN}
"
options=("pnpm" "npm" "bun")
select_option "${options[@]}"
choice=$?
PKGMANAGER="${options[$choice]}"

case $PKGMANAGER in
  "pnpm")
	command pnpm i -D ${DEPENDENCIES}
	;;
  "npm")
	command npm i -D ${DEPENDENCIES}
	;;
  "bun")
	command bun add ${DEPENDENCIES}
	;;
esac

echo "${RESET}╭─────╮  Houston:
│ ᗒ ${GREEN}ᗜ ${RESET}ᗕ  ${GREEN}Dependencias Instaladas! ${RESET}📦
╰─────╯${RESET}"
sleep 1

if [ -d .git ]; then
  command rm -rf .git/
fi

command git init -q

#  ----- Install Tailwind CSS -----

if [ -z "$2" ]; then
  echo "${RESET}
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  ${GREEN}Selecciona Framework ${RESET}
╰─────╯  ${GREEN}de CSS 📦 ${RESET} ${CYAN}
"

  options=("vanilla" "tailwind" "unocss")
  select_option "${options[@]}"
  choice=$?
  CSSFRAMEWORK="${options[$choice]}"

  if [ "${CSSFRAMEWORK}" == "vanilla" ]; then
    echo ""
  else
    command $PKGMANAGER install $CSSFRAMEWORK
    echo "${CYAN}${CSSFRAMEWORK} ${GREEN}Instalado${RESET}"
  fi

else
  case $2 in
    "tailwind")
      command $PKGMANAGER astro add tailwindcss
      ;;
    "unocss")
      command $PKGMANAGER install unocss
      ;;
    *)
      echo "${BRED}${BLACK}Opcion no valida" 
      echo "${BLUE}${BOLD}use: ${GREEN}${PKGMANAGER} astro add tailwind ${BLUE}to install Framework"
      continue 
      ;;
  esac
fi

#  ----- Install JavaScript Framework -----

if [ -z "$3" ]; then
  echo "${RESET}
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  ${GREEN}Selecciona Framework ${RESET}
╰─────╯  ${GREEN}de Javascript 📦 ${RESET} ${CYAN}
"
  options=("vanilla" "preact" "react" "svelte" "vue")
  select_option "${options[@]}"
  choice=$?
  JSFRAMEWORK="${options[$choice]}"

  if [ "$JSFRAMEWORK" == "vanilla" ]; then
    echo "" 
  else
    command ${PKGMANAGER} astro add ${JSFRAMEWORK}
    echo "${CYAN}${JSFRAMEWORK} ${GREEN}Instalado${RESET}"
  fi

else
  case $3 in
    "preact")
      command ${PKGMANAGER} astro add preact
      echo "${CYAN}Preact ${GREEN}Instalado${RESET}"
      ;;

    "react")
      command ${PKGMANAGER} astro add react
      echo "${CYAN}React ${GREEN}Instalado${RESET}"
      ;;

    "svelte")
      command ${PKGMANAGER} astro add svelte
      echo "${CYAN}Svelte ${GREEN}Instalado${RESET}"
      ;;

    "vue")
      command ${PKGMANAGER} astro add vue
      echo "${CYAN}Vue ${GREEN}Instalado${RESET}"
      ;;
    *)
      echo "${BOLD}${RED}JS Framework no set ${RESET}"
  esac
fi

# PROJECT_NAME=TESTING
echo "${RESET}
╭─────╮  Houston:
│ ◠ ${GREEN}◡ ${RESET}◠  ${GREEN}Proyecto ${BGREEN}${BLACK} ${PROJECT_NAME} ${RESET} ${GREEN}Creado${GREEN}${RESET} ✅
╰─────╯  ${BLUE}Buena Suerte, Astronauta${RESET} 🚀

"