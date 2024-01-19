#!/usr/bin/env bash

# ███╗   ███╗██╗  ██╗     █████╗ ███████╗████████╗██████╗  ██████╗
# ████╗ ████║██║ ██╔╝    ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗
# ██╔████╔██║█████╔╝     ███████║███████╗   ██║   ██████╔╝██║   ██║
# ██║╚██╔╝██║██╔═██╗     ██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║
# ██║ ╚═╝ ██║██║  ██╗    ██║  ██║███████║   ██║   ██║  ██║╚██████╔╝
# ╚═╝     ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝


# Script by Spectrasonic

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

function tail_install {
	echo "
  
╭─────╮  Houston:
│ ● ${CYAN}ᗜ ${RESET}●  Instalando ${CYAN}Tailwind CSS for ${YELLOW}${PKGMANAGER} ${RESET}🚀 
╰─────╯
"
}

echo "
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  Bienvenido, Astronauta 🚀 
╰─────╯
"

if [ -z "$1" ]; then
  read -p "${BCYAN}${BLACK} Name Project:${RESET} " PROJECT_NAME
else
  PROJECT_NAME="$1"
fi

git clone https://github.com/spectrasonic117/astro-template.git -q $PWD/$PROJECT_NAME

cd $PWD/$PROJECT_NAME

printf '{
  "name": "'${PROJECT_NAME}'",
  "type": "module",
  "version": "0.0.0",
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
# │ ♡ ${GREEN}◡ ${RESET}♡  ${GREEN}package.json creado! ${GREEN}✅
# ╰─────╯
# "
sleep 1


echo "
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  ${GREEN}Selecciona gestor ${RESET}
╰─────╯  ${GREEN}de paquetes 📦 ${RESET} ${CYAN}
"
options=("bun" "npm" "pnpm")
select_option "${options[@]}"
choice=$?
PKGMANAGER="${options[$choice]}"

command ${PKGMANAGER} install

echo "
╭─────╮  Houston:
│ ᗒ ${GREEN}ᗜ ${RESET}ᗕ  ${GREEN}Dependencias Instaladas! ${RESET}📦
╰─────╯
"
sleep 1

if [ -d .git ]; then
#   echo "${YELLOW}Removing .git directory... ${RESET}"
  command rm -rf .git/
  echo "
╭─────╮  Houston:
│ ● ${RED}⌒ ${RESET}●  ${RED}Antiguo .git Removido! ${RESET}❌
╰─────╯
"
sleep 1
fi

command git init -q
echo "
╭─────╮  Houston:
│ ● ${GREEN}◡ ${RESET}●  ${GREEN}Repositorio Creado ${RESET}📦 
╰─────╯
"
sleep 1

command rm -rf ./install.sh

sleep 1

#  ----- Install Tailwind CSS -----

case $2 in
  "tailwind")
	case $PKGMANAGER in
	  "bun")
	  command bun astro add tailwind
    echo "${CYAN}TailwindCSS ${GREEN}Instalado"
		;;
	  "npm")
	  command npx astro add tailwind
    echo "${CYAN}TailwindCSS ${GREEN}Instalado"
		;;
	  "pnpm")
	  command pnpx astro add tailwind
    echo "${CYAN}TailwindCSS ${GREEN}Instalado"
		;;
	  *)
		echo "${BLUE}${BOLD}use: ${GREEN}${PKGMANAGER} astro add tailwind ${BLUE}to install Framework"
		continue
	esac
	;;

  *)
  	echo "${BRED}${BLACK}Opcion no valida" 
	echo "${BLUE}${BOLD}use: ${GREEN}${PKGMANAGER} astro add tailwind ${BLUE}to install Framework"
  	continue ;;
esac

case $3 in
  "preact")
    case $PKGMANAGER in 
      "bun")
        command bun astro add preact
        echo "${CYAN}Preact ${GREEN}Instalado${RESET}"
        ;;
      "npm")
        command npm astro add preact
        echo "${CYAN}Preact ${GREEN}Instalado${RESET}"
        ;;
      "pnpm")
        command pnpm astro add preact
        echo "${CYAN}Preact ${GREEN}Instalado${RESET}"
        ;;
      *)
        continue
    esac
    ;;

  "react")
    case $PKGMANAGER in 
      "bun")
        command bun astro add react
        echo "${BLUE}React ${GREEN}Instalado${RESET}"
        ;;
      "npm")
        command npm astro add react
        echo "${BLUE}React ${GREEN}Instalado${RESET}"
        ;;
      "pnpm")
        command pnpm astro add react
        echo "${BLUE}React ${GREEN}Instalado${RESET}"
        ;;
      *)
        continue
    esac
    ;;

  "svelte")
    case $PKGMANAGER in 
      "bun")
        command bun astro add svelte
        echo "${SVELTE}Svelte ${GREEN}Instalado${RESET}"
        ;;
      "npm")
        command npm astro add svelte
        echo "${SVELTE}Svelte ${GREEN}Instalado${RESET}"
        ;;
      "pnpm")
        command pnpm astro add svelte
        echo "${SVELTE}Svelte ${GREEN}Instalado${RESET}"
        ;;
      *)
        continue
    esac 
    ;;

  "vue")
    case $PKGMANAGER in 
      "bun")
        command bun astro add vue
        echo "${VUE}Vue ${GREEN}Instalado${RESET}"
        ;;
      "npm")
        command npm astro add vue
        echo "${VUE}Vue ${GREEN}Instalado${RESET}"
        ;;
      "pnpm")
        command pnpm astroadd vue
        echo "${VUE}Vue ${GREEN}Instalado${RESET}"
        ;;
      *)
        continue
    esac
    ;;

  *)
    echo "${BOLD}${RED}JS Framework no set ${RESET}"
esac


# PROJECT_NAME=TESTING
echo "
╭─────╮  Houston:
│ ◠ ${GREEN}◡ ${RESET}◠  ${GREEN}Proyecto ${BGREEN}${BLACK} ${PROJECT_NAME} ${RESET} ${GREEN}Creado${GREEN}${RESET} ✅
╰─────╯  ${BLUE}Buena suerte, Astronauta${RESET} 🚀

"
