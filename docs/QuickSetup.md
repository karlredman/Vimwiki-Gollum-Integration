# Project: [Vimwiki+Gollum Integration](https://github.com/karlredman/Vimwiki-Gollum-Integration) [(Quick Setup Guide)](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/docs/QuickSetup.md)
## Description:
* This is a quick start guide that walks you through setting up Vimwiki so that it works with Gollum and vice versa.
* I'll try to not use many words.
* [ ] For information about improved search capabilities see the [search document]()
* Author: [Karl N. Redman](https://karlredman.github.io/)

1. Install dependencies and their respective dependencies:
* [Vim v8.0+](http://www.vim.org/)
* [Git Version Control System](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Vimwiki](https://github.com/vimwiki/vimwiki) vim plugin
* [Pandoc](http://pandoc.org/installing.html)
* [Gollum](http://www.vim.org/)
    * ...using Github's [Gollum Grit Adapter](https://github.com/gollum/grit_adapter) (installed by default for ubuntu systems)
* [PlantUML Server](https://github.com/plantuml/plantuml-server)

2. Add the following to your '.vimrc' configuration file:
    * Adjust the 'path:' references in your '.vimrc' 'vimwiki_list' as needed.
```vim
let g:vimwiki_list = [
\ {'path': '~/mocwiki/PersonalWiki/', 'path_html': '~/public_html/vimwiki/PersonalWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/HouseholdWiki/', 'path_html': '~/public_html/vimwiki/HouseholdWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/CompanyA', 'path_html': '~/public_html/vimwiki/CompanyA', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/AnotherWikiA', 'path_html': '~/public_html/vimwiki/AnotherWikiA', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/AnotherWikiB', 'path_html': '~/public_html/vimwiki/AnotherWikiB', 'syntax': 'markdown', 'ext': '.vimwiki'},
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

6. [Start using the wiki](http://http://127.0.0.1:4567/)

7. check out additional [demo pages](http://127.0.0.1:4567/PersonalWiki/index)
