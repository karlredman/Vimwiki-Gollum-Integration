# Project: [Vimwiki+Gollum Integration](https://github.com/karlredman/Vimwiki-Gollum-Integration)
Author: [Karl N. Redman](https://karlredman.github.io/)

## Description:

This is a guide and tutorial, with tools and 'out of the box' examples, for integrating [Vimwiki](https://github.com/vimwiki/vimwiki) with [Gollum Wiki](https://github.com/gollum/gollum) on *Linux* systems. The aim of this project is to provide a fairly easy installation and setup for a working Vimwiki + Gollum workflow. 

Most of this work is not my own. Rather I endeavor to document the process for integrating the various components that make a fairly complete wiki system for personal use. I've added some tools and a mock up wiki installation to get you started.


## Features:
* All the features outlined on the [Gollum Wiki Home Page](https://github.com/gollum/gollum/wiki).
	* Exception: Mathematics expression images are currently buggy.
* Tutorial with a working example 'mockwiki' directory structure (drop in).
* Edit wiki pages through Vimwiki using [github mardown](https://guides.github.com/features/mastering-markdown/).
* Edit wiki pages through the Gollum Web Interface.
* Regex Searches of Wiki content through the Gollum Web Interface.
	* Enables [git grep](https://git-scm.com/docs/git-grep) on the backend.
	* Requires [Gollum's Grit Git Adapter](https://github.com/gollum/gollum/wiki/Git-adapters) (default adapter for Linux)
    * [ ] See the [search documentation]() for specific information about the improved search capabilities.
* [PlantUML Server](https://github.com/plantuml/plantuml-server) integration with Gollum.
    * Supports inline markdown (i.e [Class Diagrams](http://plantuml.com/class-diagram))
    * GitHub !includeurl format supported (see [git - How to integrate UML diagrams into GitLab or GitHub - Stack Overflow](https://stackoverflow.com/questions/32203610/how-to-integrate-uml-diagrams-into-gitlab-or-github?rq=1))
* File uploads to the Vimwiki/Gollum repository from the Gollum web interface.
* Custom startup/shutdown scripts
* Cron script for automatically updating Gollum readable diary indexes.
* [ ] [Extended documentation]() to support the entire integration process.


## Example Installation

1. Install dependencies and their respective dependencies:
* [Vim v8.0+](http://www.vim.org/)
	* Suggested link: [Vim 8.0 Released! How to install it in Ubuntu 16.04 - Tips on Ubuntu](http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/)
* [Git Version Control System](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
```bash
sudo apt-get install git
```
* [Vimwiki](https://github.com/vimwiki/vimwiki) vim plugin
* [Pandoc](http://pandoc.org/installing.html)
```bash
sudo apt-get install pandoc
```
* [Gollum](https://github.com/gollum/gollum)
    * ...using Github's [Gollum Grit Adapter](https://github.com/gollum/grit_adapter) (installed by default for ubuntu systems)
* [PlantUML Server](https://github.com/gollum/gollum/wiki/Custom-PlantUML-Server)
	* The startup script expects this to be installed at $HOME/3rdparty/plantuml-server
	* see [Install local PlantUML server](https://github.com/gollum/gollum/wiki/Custom-PlantUML-Server#install-local-plantuml-server) for installation instructions.
	* The [startup script](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/start_gollum.sh) from this project starts plantuml server for you

2. Add the following to your '.vimrc' configuration file:
    * Adjust the 'path:' references in your '.vimrc' 'vimwiki_list' as needed.
	* Note: if you are already a Vimwiki user then you'll want to comment out your vimwiki section in your .vimrc for this example.
```vim
let g:vimwiki_list = [
\ {'path': '~/mockwiki/Vimwiki-Gollum/', 'path_html': '~/public_html/vimwiki/Vimwiki-Personal', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mockwiki/PersonalWiki/', 'path_html': '~/public_html/vimwiki/PersonalWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mockwiki/HouseholdWiki/', 'path_html': '~/public_html/vimwiki/HouseholdWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mockwiki/AnotherWiki/', 'path_html': '~/public_html/vimwiki/AnotherWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ ]

"" set preferred settings
"let vimwiki_folding='syntax'
let g:vimwiki_folding='list'
autocmd FileType vimwiki setlocal tabstop=4 expandtab
```

3. Setup wiki directory structure and initialize the repository:
	1. Clone this project:
	```bash
	git clone git@github.com:karlredman/Vimwiki-Gollum-Integration.git
	```
	2. Copy the mockwiki directory structure to your home directory:
	```bash
	cp -r [path to]/Vimwiki-Gollum-Integration/mockwiki ~/
	```
	3. Initialize the mockwiki as a git repository and check in the files
	```bash
	cd ~/mockwiki
	git init
	git add -A
	git commit -am "initializing wiki directory structure"
	```

4. Edit the startup script as needed
```bash
vim ~/mockwiki/gollum_admin/start_gollum.sh
```

5. Start Gollum
```bash
[sudo] ~/mockwiki/gollum_admin/start_gollum.sh
```

6. Start using the wiki: [http://http://127.0.0.1:4567/](http://http://127.0.0.1:4567/)

7. Check out additional [demo pages on your system](http://127.0.0.1:4567/Vimwiki-Gollum/index)
8. Try the searches suggested on the [search documentation]() page for the example wiki.
9. Use Vimwiki to edit files in your wiki.
	* [Vimwiki Cheetsheet](http://thedarnedestthing.com/vimwiki%20cheatsheet)
```bash
vim -c VimwikiIndex
```
11. Customize as needed.
