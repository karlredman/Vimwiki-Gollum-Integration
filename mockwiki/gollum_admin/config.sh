# configuration

## toggles

### All scripts: production (true) vs testing (false)
use_mockwiki=true

### skip toplevel dirs (see genSymlinks.sh -recommended false)
skiptoplevels=false

### create .timetrap-sheet in wiki and sub-wiki directories via genSymlinks.sh
### * Be sure to set ENV[TIMETRAP_CONFIG_FILE=$HOME/mockwiki/timetrap/timetrap.yml
### * Be sure to edit timetrap.yml as needed
update_timetrap=true

## Runtime directories
production_dir="$HOME/Documents/Heorot"
testing_dir="$HOME/mockwiki"

repodir=
### configure runtime dirs
if [ "$use_mockwiki" = true ];then
    repodir="$testing_dir"
else
    repodir="$production_dir"
fi

### runtime files
gollum_configfile="$repodir/gollum_admin/config.rb"

## genSymlinks.sh specific
### exclude these **standard** repo dirs from adding diary indexes and symlinks
excludelist=($repodir "$repodir/gollum_admin" "$repodir/timetrap" "$repodir/timetrap/scripts" "$repodir/timetrap/formatters" "$repodir/timetrap/auto_sheets")

### exclude these **production** repo dirs from adding diary indexes and symlinks
excludelist+=("$repodir/uploads" "$repodir/testfiles" "$repodir/R-Systems/files" )

## filenames and extensions
extension="vimwiki"
diary_dir_name="diary"
diaryname="diary.$extension"
targetindex="index.$extension"

## PlantUML
### install dir and port
plantuml_installdir="$HOME/3rdparty/plantuml-server"
plantuml_port="8989"

### how long to wait for the plantuml server to start
waitstart_plantuml=10

### convenience variable
gollum_plantuml_url="http://localhost:$plantuml_port/plantuml/png"

## Gollum
gollum_port="4567"

### development runtime conveniece

#### log file distinction
server_type="production"

#### set logfile and port if testing
if [ $use_mockwiki = true ]; then
    server_type="testing"
    gollum_port="4568"
fi
