#!/usr/bin/env bash

# Scirpt para crear un proyecto de astro basado en los proyectos que yo utilizo!

echo "
╭─────╮  Houston:
│ ● $(tput setaf 2)◡ $(tput sgr 0)●  Bienvenido, Astronauta 🚀 
╰─────╯
"

read -p "$(tput bold)$(tput setab 3)$(tput setaf 0) Name Project:$(tput sgr 0) " PROJECT_NAME

command git clone https://github.com/spectrasonic117/astro-template.git -q $PWD/$PROJECT_NAME
cd $PWD/$PROJECT_NAME

printf '
{
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

echo "
╭─────╮  Houston:
│ ♡ $(tput setaf 2)◡ $(tput sgr 0)♡  $(tput setaf 2)package.json creado! $(tput sgr 0)✅
╰─────╯
"
sleep 1

command pnpm i

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