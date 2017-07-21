# Project: [Vimwiki+Gollum Integration](https://github.com/karlredman/Vimwiki-Gollum-Integration)
* Description:
	* This document describes how to configure the various components to integrate Vimwiki and Gollum (and respective tools).
	* This is a work in process (WIP) and will be the prototype for a larger/different system that I am designing. The main goal here is to document the integration of Gollum with vimwiki. The end result will be a complete wiki system that is accessible/usable from web browsers, mobile devices, and the terminal.
	* This is *NOT* a secure installation -hence no instructions beyond local server setup at this time.
* Workflow:
	* Basically, I use vimwiki 99% of the time for editing my personal knowledge base, howto's, etc. 
	* My interest in using Gollum is mainly for easy searching and presentation via browser.


* Dependencies (install these their respective project instructions)
    * [Vimwiki](https://github.com/vimwiki/vimwiki)
    * [Pandoc](http://pandoc.org/installing.html)
    * [Gollum](https://github.com/gollum/gollum)
	* [PlantUML Server](https://github.com/gollum/gollum/wiki/Custom-PlantUML-Server)
		* Optional: highly recommended
    * [vim-instan-markdown vim plugin (InstantMarkdownPreview](https://github.com/suan/vim-instant-markdown)
		* Optional: useful for quick edits

## Setting up a new vimwiki

### setup vim .vimrc
* vimwiki setup (the first wiki listed will be the default for vimwiki)
* I do not recommend including the root directory of your repository/wikis as a wiki. It'll just get overly messy.
```
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

* InstantmarkdownPreview setup (optional but recommended)
```
"" vim-instant-markdow settings
let g:instant_markdown_slow = 1             " stops realtime updates
let g:instant_markdown_autostart = 0        " don't start automatically
" use :InstantMarkdownPreview when g:instant_markdown_autostart is set to 0

"" provide service to *.vimwiki files
autocmd BufNewFile,BufReadPost *.vimwiki set filetype=markdown
```

### Setup wiki directory structure

1. Create an index file for Gollum in the root directory and name it index.vimwiki
* Note: it's entirely possible to change the vimwiki diary landing filename. However, vimwiki formats the diary.vimwiki files in a way that gollum can't process it.
```
# All wikis index page (Root Directory)

1. [[PersonalWiki/index|My Personal Wiki]]
    * [[PersonalWiki/diary/diary|Diary Index (vimwiki)]]
    * [[PersonalWiki/diary/index|Diary Index (gollum)]]

2. [[HouseholdWiki/index|My Household Wiki]]
    * [[HouseholdWiki/diary/diary|Diary Index (vimwiki)]]
    * [[HouseholdWiki/diary/index|Diary Index (gollum)]]

3. [[CompanyA/index|Wiki for CompanyA]]
    * [[CompanyA/diary/diary|Diary Index (vimwiki)]]
    * [[CompanyA/diary/index|Diary Index (gollum)]]

4. [[AnotherWikiA/index|Wiki for AnotherWiki A]]
    * [[AnotherWikiA/diary/diary|Diary Index (vimwiki)]]
    * [[AnotherWikiA/diary/index|Diary Index (gollum)]]

5. [[AnotherWikiB/index|Wiki for AnotherWiki B]]
    * [[AnotherWikiB/diary/diary|Diary Index (vimwiki)]]
    * [[AnotherWikiB/diary/index|Diary Index (gollum)]]
```

2. create a directory structure like the following
    * The index.vimwiki files are the index pages for each wiki for vimwiki and gollum
    * Add an administration directory for tools and scripts (here I call it gollum_admin)
```
mockwiki
├── AnotherWikiA
│   └── index.vimwiki
├── AnotherWikiB
│   └── index.vimwiki
├── CompanyA
│   └── index.vimwiki
├── HouseholdWiki
│   └── index.vimwiki
├── PersonalWiki
│   └── index.vimwiki
└── index.vimwiki
```

3. Seed the index files. This is just for convenience with gollum for getting to the diary index pages.
```
# Personal Wiki Index

## Diary Indexes
* [[diary/diary|Diary Index (vimwiki)]]
* [[PersonalWiki/diary/index|Diary Index (gollum)]]

```

4. Initialize the directory for git/gollum
```
cd [path]/mockwiki
git init
```

## Setup Gollum
* Install
	* Please see the [Gollum Project page](https://github.com/gollum/gollum) for installation instructions
* Setup Configuration file
	* For the setup outlined here use the configuration file included in the sources for this project under mockwiki/gollum_admin/
* Start Gollum

## TODO:
* [ ] Basic integration for gollum and vimwiki
* [ ] Configure gollum editor to set correct extension when editing
* [ ] Workflow documentation
* [ ] Dropbox integration
* [ ] Mobile device integration
* [ ] Authentication Setup
* [ ] Page Templates
	* [ ] Header
	* [ ] Footer
	* [ ] Sidebar
* [ ] Search system replacement
* [ ] Online vim editor replacement

