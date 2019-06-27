# Project: [Vimwiki+Gollum Integration (Extended documentation)](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/docs/extended_readme.md)

## Special Notes
* This is the long form of this procedure. See [Vimwiki+Gollum Integration: README.md](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/README.md) for a quick install guide.

* This project works with Gollum v4.x/gollum-lib v4.x. I'll update the documents and installation examples when Gollum v5.x is released. Gollum v5.x has some big changes on the way. For this reason I am suspending further work on this project until the Gollum v5.x release. This project's support of Gollum v4.x is considered to be "complete enough" at this time. See [5.0 release notes](https://github.com/gollum/gollum/wiki/5.0-release-notes) for further information.

## Description:

This is a guide and tutorial, with tools and 'out of the box' examples, for integrating [Vimwiki](https://github.com/vimwiki/vimwiki) with [Gollum Wiki](https://github.com/gollum/gollum) on *Linux* systems. The aim of this project is to provide a fairly easy installation and setup for a working Vimwiki + Gollum workflow.

Most of this work is not my own. Rather I endeavor to document the process for integrating the various components that make a fairly complete wiki system for personal use. I've added some tools and a mock up wiki installation to get you started.


* This is a setup guide for integrating [Vimwiki](https://github.com/vimwiki/vimwiki) with [Gollum](https://github.com/gollum/gollum). See the [Features section](#Features_anchor).
* The intended result is for a **locally served vimwiki+gollum installation**.
* **Security** is not a consideration at this time. I may add information for setting up [omnigollum](https://github.com/arr2036/omnigollum) at a later date.
* Note: This project has **only been tested with github-mardown** format. I have not bothered with other markdown formats because vimwiki doesn't recognize formats other than vimwiki and (some close variation to) Github Flavored Markdown.
* The intention here is to use **out of the box components only**. All customization is done through configuration of the various components via their respective customization methods. No direct patching is allowed.
* An example Gollum/Vimwiki wiki directory (mockwiki in the sources of this project) is provided for tutorial purposes. This directory structure will be used to throughout this document.
* Note: this procedure is **only tested with ubuntu based systems** (specifically Linux Mint v18.1 Cinnamon)
* Specifics for file server setup for media, etc. are not discussed at this time. However please consider that git is definitely not an ideal place to keep binaries.
* Author: [Karl N. Redman](https://karlredman.github.io)

## Limitations / Bugs:
* See the [Limitations](#TODO_anchor) section at the bottom of this document

## Background:

Organizing a personal knowledge base is a lifelong interest of mine. The subject of knowledge bases in general is extremely complex and covers a very wide range of subtopics and requirements. For this reason no one has a complete answer and no single solution works for every use case. Generalized knowledge bases are pretty much as good as it gets. This project is in fact a prototype for a much larger project I have been designing for decades -that may never see the light of day.

Each of the components this project uses stands alone as an individual complex system with myriad options relative to configuration and implementation. This document attempts to describe how to integrate components with capabilities that I believe are important to a straightforward knowledge base workflow. Unfortunately, discovering the various components that work well and will play well with one another is not straightforward at all.

My requirements (relative to this project) boil down to the following:
* A file based wiki system (vimwiki)
* Ease of editing wiki files/pages (Vim with plugin support)
* The ability to create unlimited wiki domains (vimwiki)
* A distributed version control for the wiki files (git)
* Vim based editing, wiki indexing (vimwiki)
* Markdown based wiki files/pages (vimwiki markdown format mode)
    * github markdown seems to be the least common denominator for now
* Document format export capability for wiki files/pages (pandoc)
    * export to PDF, HTML, etc.
* A not-so-terrible web based user interface for:
    * Fairly robust searches for wiki files/pages
    * Basic editing capability
    * Diagram capability (plantuml works fine for me)
    * Multiple wiki and file browsing
    * capable of serving multiple markdown formats
        * asciidoc, mediawiki, etc.
        * Note: this is because I sometimes save files in the wiki with other formats for external wiki posts.

<a name=Features_anchor> </a>
## Features:
* All the features outlined on the [Gollum Wiki Home Page](https://github.com/gollum/gollum/wiki).
* Tutorial with a working example 'mockwiki' directory structure (drop in).
* Edit wiki pages through Vimwiki using [github mardown](https://guides.github.com/features/mastering-markdown/).
* Vimwiki extension is recognized in Gollum editor.
* Edit vimwiki pages through the Gollum Web Interface.
* TOC works in _Sidebar.ext and _Footer with the included monkypatched [config.rb](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/config.rb)
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
* A [shell script](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genSymlinks.sh) is provided to help with keeping links consistent between Gollum and Vimwiki.

<a name=UsefulReferences_anchor> </a>
## Useful References
* [Vimwiki Cheetsheet](http://thedarnedestthing.com/vimwiki%20cheatsheet)
* [git grep regex](https://git-scm.com/docs/git-grep)
* [This project's Gollum Search capabilities](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Search%20Examples.vimwiki))
* [Pandoc Tricks](https://github.com/jgm/pandoc/wiki/Pandoc-Tricks)
* [Pandoc User's Guide](http://pandoc.org/MANUAL.html)
    * **Note:** You will want the github-markdown "from" option for your conversions.
    * You may have to install gem github-markdown
* [Is there a command line utility for rendering GitHub flavored Markdown? - Stack Overflow](https://stackoverflow.com/questions/7694887/is-there-a-command-line-utility-for-rendering-github-flavored-markdown)
* [Mastering Markdown · GitHub Guides](https://guides.github.com/features/mastering-markdown/)

## Thank You!
* To all of the contributors of the various components and projects discussed in this document.
* Special thanks to the guy that wrote this post: Thanks for the clues!
    * [Adding Pandoc to Gollum - Martin Wolf's weblog](http://mwolf.net/2014/04/29/adding-pandoc-to-gollum/)

<a name=Dependencies_anchor> </a>
## Dependencies:
* A non-mobile computer system to run local web servers and host a git repository (possible clone)
* Some knowledge of Linux/Unix administration. If you have read this far you probably have the knowledge you need.
* Linux (only ubuntu derivatives are tested)
* You will likely have to accept installation for or install seperately dependencies that these dependencies depend on (i.e. Gollum depends on ruby v2+, etc.)
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
* [Gollum](https://github.com/gollum/gollum) (v4.x)
    * ...using Github's [Gollum Grit Adapter](https://github.com/gollum/grit_adapter) (installed by default for ubuntu systems)
```
[sudo] gem install gollum -v 4.1.2
```

## Special Note about internal link/tag consistency:

There is no easy way to synchronize the behavior for internal links and tags between Gollum v4.x and Vimwiki. The two systems, by way of their purpose and use cases, handle links from different perspectives. In an effort to provide the most consistent behavior between the two systems I've created a script ([genSymlinks.sh](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/genSymlinks.sh))that generates symlinks with a comprehensive list of restrictions. Without some major alteration of one or both systems it seems that symlinks are as good as it's going to get until the next release of Gollum. Please see the script for more detail. There are notes in the mockwiki that detail the reluctant decision making process that went into using symlinks to solve a very complicated problem.

If you follow the 'Example Installation / Tutorial' then running the genSymlinks.sh script should work ok for you on a linux based system.
* Use the script at **Your Own Risk**
* Please look at the code first before running it.
* I run exactly this script from cron several times per day.

* For **best results with Gollum v4.x use forward looking links as much as possible** (i.e. '\[\[PersonalWiki/diary/2017-07-31\]\]' as opposed to \[\[2017-07-31\]\])

------
## Setup instructions from here on:
* All path references assume the example 'mockwiki' directory structure that is part of this project.
    * For testing/tutorial purposes you may want to just download/clone this directory and copy the files to someplace convenient. This example assumes the $HOME directory.
* Linear progression of the instructions from here on is implied.

### Install [Dependencies](#Dependencies_anchor):
1. Installation instructions for each component is beyond the scope of this project. Since the aim of this project is to use unaltered components then merely following the basic installation instructions (links provided above) should suffice.
2. Verify the individual components work as intended

### Setting up an example Gollum Wiki installation for use with Vimwiki:

#### Clone Vimwiki-Gollum-Integration project (for Gollum v4.x)
```
git clone https://github.com/karlredman/Vimwiki-Gollum-Integration.git
```

#### setup vim .vimrc
* vimwiki setup (the first wiki listed will be the default for vimwiki). This example shows 5 wikis being managed by Vimwiki.
* I do not recommend including the root directory of your repository/wikis as a wiki. It'll just get overly messy.
* Important: Here we specify that vimwiki should use markdown syntax (as opposed to vimwiki syntax) and to use '.vimwiki' as the extension.
	* We set markdown mode so vimwiki internally processes content as close as possible to github markdown.
	* We specify '.vimwiki' as the extension to differentiate between wiki content and other files. This also serves to mark a clear seperation between files that are managed by vimwiki and everything else.
* The parameters are thus:
    * path: the path of the wiki
    * path_html: path to where vimwiki can export html files (i never use this)
    * syntax: either vimwiki or markdown formats are recognized. Only markdown format is recognized by both Vimwiki and Gollum
    * ext: the extension Vimwiki will use for wiki pages
    * many more options are possible (see vimwiki.vim) but that is beyond the scope of this project.
        * see [vimwiki.vim](https://github.com/vimwiki/vimwiki/blob/dev/plugin/vimwiki.vim): variables named 'vimwiki_defaults.*' are generally overridable.
* I prefer list type folding for vimwiki.
* Tabstops=4 (as spaces) is the de facto standard for markdown processors (i.e. stackoverthrow tabbed code blocks)

1. Add the following to your '.vimrc' configuration file
    * Adjust the 'path:' references in your '.vimrc' 'vimwiki_list' as needed.
```vim
let g:vimwiki_list = [
\ {'path': '~/mockwiki/Vimwiki-Gollum/', 'path_html': '~/public_html/vimwiki/Vimwiki-Personal', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/PersonalWiki/', 'path_html': '~/public_html/vimwiki/PersonalWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/HouseholdWiki/', 'path_html': '~/public_html/vimwiki/HouseholdWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ {'path': '~/mocwiki/AnotherWiki/', 'path_html': '~/public_html/vimwiki/AnotherWiki', 'syntax': 'markdown', 'ext': '.vimwiki'},
\ ]

"" set preferred settings
"let vimwiki_folding='syntax'
let g:vimwiki_folding='list'
autocmd FileType vimwiki setlocal tabstop=4 expandtab
```

#### Setup wiki directory structure and initialize the repository:
* For an explanation of why we setup index.vimwiki and diary.vimwiki files this way please see the [Gollum configuration section](#GollumConfig_anchor).
* The directory structure I use seperates several wikis all accessable from both Vimwiki and Gollum

1. Create an index file for Gollum in the root directory and name it index.vimwiki
    * Note: we'll set the Gollum index pages to 'index.vimwiki' in the [Gollum configuration section](#GollumConfig_anchor)
```markdown
# All wikis index page (Root Directory)

1. [[PersonalWiki/index|My Personal Wiki]]
    * [[PersonalWiki/diary/diary|Diary Index (vimwiki)]]
    * [[PersonalWiki/diary/index|Diary Index (gollum)]]

2. [[HouseholdWiki/index|My Household Wiki]]
    * [[HouseholdWiki/diary/diary|Diary Index (vimwiki)]]
    * [[HouseholdWiki/index/index|Diary Index (gollum)]]

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
    * The 'index.vimwiki' files are the index pages for each wiki for vimwiki and gollum
    * Note: Vimwiki will automatically create directories and index files for wikis that are specified in the .vimrc configuration. I recommend not doing this if you aren't familiar with vimwiki -It can get very tedious and confusing.
    * Add an administration directory for gollum configuration, tools and scripts (here I call it gollum_admin)
```text
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
├── favicon.ico         # optional (see below)
└── index.vimwiki
```

3. (Optional) Seed the index files:
* This is just for convenience with gollum for getting to the diary index pages.
    * Note: only Gollum needs a detailed path to the diary index files (to be created later). This is because Gollum's root is configured to be the base directory of your tree of wikis.
```markdown
# Personal Wiki Index

## Diary Indexes
* [[diary/diary|Diary Index (vimwiki)]]
* [[PersonalWiki/diary/index|Diary Index (gollum)]]

## The rest of your personal index goes below this line
```
4. (Optional) Drop in a 'favicon.ico' file:
* You can add a favicon.ico to the root directory if desired.
* Gollum supports this out of the box.

5. Initialize the directory for git/gollum:
* NOTE: Remember, any time you edit something in this directory you'll have to commit your changes/files to git before they will show up in gollum
```bash
cd [path]/mockwiki
git init
git add -A; git commit -am "adding files: first add"
```

## Setup Gollum:
### Install Gollum and/or make sure it's running:
* Please see the [Gollum Project page](https://github.com/gollum/gollum) for installation instructions.
* If you are using the example 'mockwiki' provided with this project then you can use that directory for testing.
* Start/Test your unconfigured Gollum like this:
    * Be sure to adjust the path to your wiki repository accordingly
```bash
command="gollum --port 4567 --config /home/karl/mockwiki/gollum_admin/config.rb --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
```

<a name=GollumConfig_anchor> </a>
### Setup the Gollum configuration file (Explanation):
* The quicky answer here is: use the configuration file that I include in this project under [mockwiki/gollum_admin](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/gollum_admin/config.rb).
* Unfortunately this configuration file, although short (code wise), should have a lot of explanation. There is a bunch of history relative to the evolution of Vimwiki and Gollum that I'm going to exclude or only touch on briefly. To make things worse, there is very little documentation about how all of this stuff in Gollum is "supposed to" fit together. I'll try to summarize this information as much as possible.

#### Getting Gollum to recognize the '.vimwiki' extension:
* This is necessary in order to seperate wiki files from other files within the wikis. It's entirely possible to configure Vimwiki to use the '.md' extension or something else that Gollum understands as markdown but that causes some complications here and there. It's best to keep the files managed by vimwiki separated IMHO.
* Specify a new format type, 'Vimwiki', that is associated with the extension specifier, ':vimwiki' with the regex '/vimwiki/'
    * This allows 'Vimwiki' to appear in the dropdown for the file types being edited through Gollum.
    * The unique format type / file extension is required for the Gollum 'file edit page'.
    * **Note:** there is a bug in Gollum that causes 'Mediawiki' to be selected in the dropdown when editing '.vimwiki' files.
* We specify the '.vimwiki' the extension for the following reasons:
    * Evolution: Vimwiki has had problems with processing non '.vimwiki' files in previous versions.
    * Best Practices: Seperate Vimwiki managed files from files of other tools is just a good idea.
    * Varying Standards: Markdown files have a wide range of extensions with various histories.
        * Staying with '.vimwiki' for Vimwiki retains the history for these types of files.
    * Legacy: Most people, including myself, started using Vimwiki with .vimwiki extensions a long time ago.
        * Renaming file extensions with mixed file types in a wiki could turn out to be very complicated.
* Specifying Pandoc as the markdown processor:
    * Ideally we would use Gollum's internal Markdown processor.
    * I wasn't able to figure out how to add '.vimwiki' as a new format type and still use Gollum's Markdown procesor. See: [How can I add an extension that uses the internal Gollum markdown processor? - Stack Overflow](https://stackoverflow.com/questions/45230393/how-can-i-add-an-extension-that-uses-the-internal-gollum-markdown-processor).
    * There is no other reason to use Pandoc within the scope of this project otherwise.
    * This is on my TODO list of things to fix 'someday'

#### Specify the Gollum landing page filename ('index' instead of 'Home'):
* Explanation of index files and gollum landing pages.
    * Gollom defaults to using 'Home.[recognized extension (ext)]' as an index page when serving pages for each directory.
    * Vimwiki defaults to using 'index.vimwiki' titled files for individual wikis but uses 'diary.vimwiki' for wiki diary directories.
    * Given that Vimwiki manages the wikis while Gollum only provides a pretty UI, we default to keeping our Vimwiki configuration to a minimum.
        * This is a 'best practices' thing for me.
    * While it is possible to configure Vimwiki to use 'index.vimwiki' for diary directory index files it's pointless. Vimwiki auto generated 'diary.vimwiki' files are not compatible with Gollum formatting. Therefore, we'll have to (later) add a script to generate Gollum formatted/readable diary indexes.

#### Add better search capibilities for Gollum (Grit_Adapter grep() override)
* The problem:
    * This is quite simple: Gollum's search capabilities 'out of the box' are severely limiting. It was **increadably frustrating** that Gollum searches only matchedd files where all words appeard, in order, in a single line.
    * The answer is very simple as well: eliminate shell escapes and allow ['git grep'](https://git-scm.com/docs/git-grep) to perform searches with --extended-regexp and --all-match
* A new problem????:
    * It is **very likely** that my "fix" is a **security risk** for buffer overflows and the like. I **have not** tested this fix for security concernes.
* Just a quick note on the simple fix.
    * I easily spent like 15 straight hours trying to understand how all of this stuff works just to fix this search thing. While I know alot more now about Gollum and how ruby fits together now, I really would rather have not had this problem in the first place. This bullet point is here for the sole purpose of venting my frustration at having to fix this in the first place and that it was all new in a language that I really don't know well. Also, am I daft or is there just no other information on the interwebs for making Gollum's search routine actually do it's job!?? Anyway, Bah! What a PITA!

## Project Overview (mixed diagram)

![image](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/docs/overview.png?raw=true)

<a name=TODO_anchor> </a>
## Project TODO:
* The TODO list for this project has moved to the [mockwiki](https://github.com/karlredman/Vimwiki-Gollum-Integration/blob/master/mockwiki/Vimwiki-Gollum/Project%20TODO%20List.vimwiki)

## Known Litations
* The enhanced search capibily is likey a **Security Risk**
* Spaces might be a problem in searches
* No files in the wiki repository can be named 'index.md'
* searches: filenames don't get matches with expressions or options (i.e. '-e thing', 'thing.*')
    * files are included if only words, separated by spaces, are used
* Following diary links from vimwiki intended for Gollum tries to create a new file -this is **BAD**
    * Won't fix
	* This is a fundamental difference between how Vimwiki and Gollum view the physical directory strucure.
