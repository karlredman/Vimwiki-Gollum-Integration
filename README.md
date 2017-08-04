# Project: [Vimwiki+Gollum Integration](https://github.com/karlredman/Vimwiki-Gollum-Integration)
Author: [Karl N. Redman](https://karlredman.github.io/)

## Description:

This is a guide and tutorial, with tools and 'out of the box' examples, for integrating [Vimwiki](https://github.com/vimwiki/vimwiki) with [Gollum Wiki](https://github.com/gollum/gollum) on *Linux* systems. The aim of this project is to provide a fairly easy installation and setup for a working Vimwiki + Gollum workflow.

Most of this work is not my own. Rather I endeavor to document the process for integrating the various components that make a fairly complete wiki system for personal use. I've added some tools and a mock up wiki installation to get you started.

**Note:** This is a short version of the documentation. Please see the [Extended documentation](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/docs/extended_readme.md) for more in depth information.


## Features:
* All the features outlined on the [Gollum Wiki Home Page](https://github.com/gollum/gollum/wiki).
* Tutorial with a working example 'mockwiki' directory structure (drop in).
* Edit wiki pages through Vimwiki using [github mardown](https://guides.github.com/features/mastering-markdown/).
* Edit wiki pages through the Gollum Web Interface.
* Regex Searches of Wiki content through the Gollum Web Interface.
	* Enables [git grep](https://git-scm.com/docs/git-grep) on the backend.
	* Requires [Gollum's Grit Git Adapter](https://github.com/gollum/gollum/wiki/Git-adapters) (default adapter for Linux)
    * See the [search documentation]((https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Search%20Examples.vimwiki)) for specific information about the improved search capabilities.
* [PlantUML Server](https://github.com/plantuml/plantuml-server) integration with Gollum.
    * Supports inline markdown (i.e [Class Diagrams](http://plantuml.com/class-diagram))
    * GitHub !includeurl format supported (see [git - How to integrate UML diagrams into GitLab or GitHub - Stack Overflow](https://stackoverflow.com/questions/32203610/how-to-integrate-uml-diagrams-into-gitlab-or-github?rq=1))
* File uploads to the Vimwiki/Gollum repository from the Gollum web interface.
* Custom startup/shutdown scripts
* Cron script for automatically updating Gollum readable diary indexes.
* [Extended documentation](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/docs/extended_readme.md) to support the entire integration process.
* A [shell script](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genSymlinks.sh) is provided to help with keeping links consistant between Gollum and Vimwiki.

## Special Note about internal link/tag consistency:

There is no easy way to synchronize the behavior for internal links and tags between Gollum and Vimwiki. The two systems, by way of their purpose and use cases, handle links from different perspectives. In an effort to provide the most consistent behavior between the two systems I've created a script ([genSymlinks.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genSymlinks.sh))that generates symlinks with comprehensive list of restrictions. Without some major alteration of one or both systems it seems that symlinks is as good as it's going to get. Please see the script for more detail. There are notes in the mockwiki that detail the reluctant decision making process that went into using symlinks to solve a very complicated problem. 

If you follow the 'Example Installation / Tutorial' then running the genSymlinks.sh script should work ok for you on a linux based system. 
* Use the script at **Your Own Risk**
* Please look at the code first before running it.
* I run exactly this script from cron several times per day.

* For **best results use forward looking links as much as possible** (i.e. '\[\[PersonalWiki/diary/2017-07-31\]\]' as opposed to \[\[2017-07-31\]\])

## Example Installation / Tutorial

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
* [Gollum](https://github.com/gollum/gollum) (only v4.1.1 is tested at this time)
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

6. Start using the wiki: [http://127.0.0.1:4567/](http://http://127.0.0.1:4567/)
    * The index page for mockwiki will show links for the wiki repository

8. Check out additional [demo pages on your system (http://127.0.0.1:4567/Vimwiki-Gollum/index)](http://127.0.0.1:4567/Vimwiki-Gollum/index)
    * Explore the 'Vimwiki-Gollum' wiki for information pertaining to this project

9. Try the searches suggested on the [search documentation](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Search%20Examples.vimwiki) page for the example wiki.


10. Use Vimwiki to edit files in your wiki.
	* [Vimwiki Cheetsheet](http://thedarnedestthing.com/vimwiki%20cheatsheet)
```bash
vim -c VimwikiIndex
```
11. Customize as needed.
* Gollum + PlantUML Server start and stop scripts (under mockwiki/gollum_admin)
    * configure [start_gollum.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/start_gollum.sh) for the path of your wiki repository, ports for Gollum and PlantUML, etc.
    * [stop_gollum.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/stop_gollum.sh) just stops the servers based on the behavior from the start script.
* The [Gollum config file](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/config.rb) is under mockwiki/gollum_admin
* [GenGollumDiaryIndexes.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genGollumDiaryIndexes.sh)
    * This is a cron safe script that generates vimwiki diary indexes (diary.vimwiki files) and then reformats them for Gollum -saving the results in an index.vimwiki for each [wikiname]/diary directory. This is necessary in order to be least intrusive for vimwiki operations while providing useful links through Gollum. Also, Vimwiki's formatting for the diary index doesn't work out of the box for Gollum.
    * I run the script once per day via cron. Generally that's all I need. Also, the script adds a 'Today' link on the diary index page for Gollum whether the file has been created or not. This way we also don't interfere with vimwiki if a diary index (diary.vimwiki) is regenerated.
    * Examples of the before and after:
        * Before: [diary.vimwiki](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Vimwiki-Gollum/diary/diary.vimwiki)
        * After: [index.vimwiki](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Vimwiki-Gollum/diary/index.vimwiki)
    * Cron Setup: 
        * You need to have your git credentials for your local repository setup for this to work properly.
        * The script will need to be run under your user account.
        ```
        crontab -e
        ```
        * I run the script at 1:05am every night because of daylight savings switches:
        ```
        5 1 * * * /home/karl/mockwiki/gollum_admin/genGollumDiaryIndexes.sh > /tmp/wtf 2<&1
        ```
* In order **to keep link and tag behavior consistent** between Gollum and Vimwiki **use forward looking links** along with my [genSymlinks.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genSymlinks.sh) script to create (**eep! use at your own risk!**) symlinks in (mostly) appropriate subdirectories of your repository. Obviously you'll have to commit the symlinks on your own because the script doesn't muck with git at all.
