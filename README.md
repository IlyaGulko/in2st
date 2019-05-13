# in2st

[![Status Badge](https://img.shields.io/badge/state-work%20in%20progress-yellowgreen.svg)](https://github.com/IlyaGulko/initial-install/#work-in-progress)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/584677dab7224d1caa35cbcd8e01745d)](https://www.codacy.com/app/IlyaGulko/in2st?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=IlyaGulko/in2st&amp;utm_campaign=Badge_Grade)

>  This tool is ~~garbage~~ in early stage of development.

## What's the point

This script is supposed to automate installation of *default* list of programs and applying some configurations.

## Usage

      $ wget https://raw.githubusercontent.com/IlyaGulko/in2st/master/in2st.sh
      $ in2st.sh [--help] <string>

## List of Installables

* git
* python3 | pip3
* docker
* ansible
* terraform
* golang
* packer
* vim | vimrc

## List of Actions

* installed
* help

## Work in Progress

* ***CRITICAL:***

  *  export PATH variable without exiting script  

* **code:**

  * *installed* action 
  * versioning
  * handling errorrs
  * trapping Ctrl-C
  * options to determine version of each product

    * add vars file
    * add commands to configure vars

* add compatibility with other distros
