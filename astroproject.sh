#!/usr/bin/env bash

echo "
╭─────╮  Houston:
│ ● $(tput setaf 2)◡ $(tput sgr 0)●  Bienvenido, Astronauta! 🚀 
╰─────╯"

read -p "$(tput setaf 3)Name Project: $(tput sgr 0)" PROJECT_NAME

command git clone https://github.com/spectrasonic117/astro-template.git $PWD/$PROJECT_NAME
cd $PWD/$PROJECT_NAME

printf '
{
  "name": "'${PROJECT_NAME}'",
  "type": "module",
  "version": "0.0.1",
  "scripts": {
    "dev": "astro dev",
    "start": "astro dev",
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
    "prettier": "latest",
    "prettier-config-standard": "latest",
    "prettier-plugin-astro": "latest"
  }
}' > package.json

echo "$(tput setaf 3)Package.json added $(tput sgr 0)"
echo ""
echo "$(tput setaf 3)Installing Dependencies... $(tput sgr 0)"

command pnpm i


if [ -d .git ]; then
  echo "$(tput setaf 3)Removing .git directory... $(tput sgr 0)"
  command rm -rfv .git/
fi

echo "$(tput setaf 3)Creating git Repository... $(tput sgr 0)"
command git init

command rm -rf  ./install.sh

echo ""
echo "$(tput setaf 2)Prettier & ESLint Astro plugins installed $(tput sgr 0)"


echo "
╭─────╮  Houston:
│ ◠ $(tput setaf 2)◡ $(tput sgr 0)◠  Buena suerte, Astronauta! 🚀 
╰─────╯"