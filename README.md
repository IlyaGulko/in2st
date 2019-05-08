# in2st

[![Status Badge](https://img.shields.io/badge/state-work%20in%20progress-yellowgreen.svg)](https://github.com/IlyaGulko/initial-install/#work-in-progress)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7cddfd3a3d4449388c31c0b1b395f5e4)](https://www.codacy.com/app/IlyaGulko/initial-install?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=IlyaGulko/initial-install&amp;utm_campaign=Badge_Grade) 


>  This tool is ~~garbage~~ in early stage of development.


## What's the point?

This script is supposed to automate installation of *default* list of programs and applying some configurations.


## List of Installables

  *  git
  *  python3 | pip3
  *  docker
  *  ansible
  *  terraform
  *  golang
  *  packer
  *  vim | vimrc


## List of Actions

  * installed
  * help


## Work in Progress

  *  ***CRITICAL:***
     *  export PATH variable without exiting script  
 
  *  **code:**
     * *installed* action 
     * handling errorrs
     * trapping Ctrl-C
     * options to determine version of each product
        * add vars file
        * add commands to configure vars