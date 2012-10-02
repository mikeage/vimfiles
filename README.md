vimfiles
========

My .vim directory.

Note that since I use pathogen (and it's stored under bundle/), you'll want to add 

    runtime bundle/vim-pathogen/autoload/pathogen.vim
    call pathogen#infect()

to your .vimrc

Also, as most of the plugins are git submodules, after cloning, make sure to run

    git submodule init
    git submodule update

Enjoy!
