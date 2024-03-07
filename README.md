Archives as I've switched from vim to neovim. See my nvim.lua in my "dotfiles" repo for the continuation

vimfiles
========

My .vim directory.

Note that since I use pathogen (and it's stored under bundle/), you'll want to add 

    runtime bundle/vim-pathogen/autoload/pathogen.vim
    call pathogen#infect()

to your .vimrc

Because of the use of submodules, the initial clone should be done via:

    git clone --recursive ...

Enjoy
