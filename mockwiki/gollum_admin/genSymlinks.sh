#!/bin/bash

####################################################
# Description:
#
# USE AT YOUR OWN RISK!!
#
# This script attempts to fix the problem of merging link/tag behavior between
# Gollum and Vimwiki. This script generates symlinks for subdirectories of
# your repository for each toplevel subdirectory of the repository. In other
# words: we add symlinks back to all wikis for each subdirectory under the
# repository root (see mockwiki for examples). I know this is ineffecient -it 
# was meant as a quick one-off.
#
# Symlinks are added when the following criteria is met:
# * The absolute path of the directory is **not** in the excludelist array.
# * The absolute path of the directory is not a top level repo directory.
#	* (Recomemded) this can be overridden by setting skiptoplevels=false
# * The directory doesn't appear to be an upload directory created by Gollum.
#	* Directories appear to be upload directories if:
#		* A filename+.vimwik of the same name exists in the parent directory
#			* where there is a full match
#			* OR where spaces have been substituted with dashes
# 			```
#			# match example (will not get symlinks):
#			directory: this-is-a-file-that-has-an-uplode-directory/
#			file: ../this is a file that has an uplode directory.vimwiki
# 			```
#		* They are not a subdirectory of 'diary' file.
#			* However upload directories within the diary directories do
#				have symlinks applied.
# * The directory isn't hidden (i.e. starts with a dot).
# * The directory isn't the repo directory.
# * The parent directory wasn't already skipped already
####################################################

###########
# configuration defaults
repodir="$HOME/mockwiki"
excludelist=($repodir "$repodir/gollum_admin")
skiptoplevels=false         # !!!! set to true to skip toplevel directories
diary_dir_name="diary"
extension="vimwiki"
###########

# TODO:
# manage command line arguments
## stuff goes here
## handle excludelist
#excludelist+=("$repodir/uploads" "$repodir/testfiles")

function create_symlink () {
    target=$1
    link=$2
	echo "linking: ln -sfn -t ${target} ${link}"
	ln -sfn -t "${target}" "${link}"
}

function create_symlinks () {
    declare -a wikilist=("${!1}")
    declare target=$2

    for l in "${!wikilist[@]}"; do
        # skip things in the exclude list
        for e in ${!excludelist[@]}; do
            if [ "${wikilist[$l]}" == "${excludelist[$e]}" ]; then
                echo "skipping link to excluded ${wikilist[$l]}"
                continue 2;
            fi
        done
        create_symlink "${target}" "${wikilist[$l]}"
    done
}


# go to the repository
pushd $repodir > /dev/null 2>&1

dirlist=()
while IFS=  read -r -d $'\0'; do
    dirlist+=("$REPLY")
done < <(find $repodir -not -path '*/\.*' -type d -print0)

# get a list of toplevel directories
topdirs=()
while IFS=  read -r -d $'\0'; do
    topdirs+=("$REPLY")
done < <(find $repodir -maxdepth 1 -not -path '*/\.*' -type d -print0)

# keep track of skipped upload directories and don't venture into them
skippedlist=()

# for each wiki in the list
for i in ${!dirlist[@]}; do

    # skip the repodir
    if [ "${dirlist[$i]}" == "$repodir" ]; then
        echo "skipping repodir ${dirlist[$i]}"
        continue;
    fi

    # skip directories that match the exclude list
    for e in ${!excludelist[@]}; do
        if [ "${dirlist[$i]}" == "${excludelist[$e]}" ]; then
            echo "skipping excluded ${dirlist[$i]}"
            continue 2;
        fi
    done

	# skip toplevel directories if the options is set to do so
	if [ $skiptoplevels == true ]; then
		for w in ${!topdirs[@]}; do
			if [ "${topdirs[$w]}" == "${dirlist[$i]}" ]; then
				echo "skipping topdir ${dirlist[$i]}"
				continue 2;
			fi
		done
	fi

    # establish the potential file name and it's parent directory
    directory=$(basename "${dirlist[$i]}")
    parentdir=$(dirname "${dirlist[$i]}")

    # skip dirs where the parent directory was skipped
    for s in ${!skippedlist[@]}; do
        #if [ "${skippedlist[$s]}" == "$dirlist[$i]" ]; then
        if [ "${skippedlist[$s]}" == "$parentdir" ]; then
            echo "skipping subdir under upload dir  ${dirlist[$i]}"

            # add this dir to the skipped list also
            skippedlist+=(${dirlist[$i]})
            continue 2
        fi
    done


    #########################
    ## handle diary directories and subdirectories (which use a dash in the
    ## name even for uploaded files directories)

    # if it's a diary directory just make the links
    if [ "$directory" == "diary" ];then
        echo "created diary level links at ${dirlist[$i]}"
        create_symlinks  topdirs[@] "${dirlist[$i]}"
        continue
    fi

    # skip diary dirs that are for file uploads
    if [ "$(basename $parentdir)" == "diary" ];then
        hasupload=$(find "$parentdir" -type f -name "$directory.vimwiki")
        if [ "$hasupload" != "" ]; then
            echo "skiping $hasupload"
            skippedlist+=(${dirlist[$i]})
            continue
        fi

        # create links
        echo "creating links at ${dirlist[$i]}"
        create_symlinks  topdirs[@] "${dirlist[$i]}"
        continue
    fi
    #########################

    #########################
    # we'll skip normal directories that have uploads

    # Attempt to accomidate for files that have a '-' in the name via masking
    #
    # example:
    # dashed="Demo-Page---Kitchen-Sink"
    # spaced="Demo Page - Kitchen Sink.vimwiki"

    # find all files in the immediate parent dir
    parentlist=()
    while IFS=  read -r -d $'\0'; do
        parentlist+=("$REPLY")
    done < <(find $parentdir -maxdepth 1 -not -path '*/\.*' -type f -name "*.vimwiki" -print0)

    for f in ${!parentlist[@]}; do
        # substitute spaces with dashes and try to match the file
        curfile=$(basename "${parentlist[$f]}" ".vimwiki")
        masked=$(echo $curfile | grep ' ' | sed 's/ /-/g')

        if [ "$masked" == "$directory" ]; then
            echo "skipping upload directory: ${dirlist[$i]}"
            skippedlist+=(${dirlist[$i]})
            continue 2;
        fi
    done
    #########################

    echo "creating links at ${dirlist[$i]}"
    create_symlinks  topdirs[@] "${dirlist[$i]}"

done

## TODO: add git add and commit calls here

# return to where we started
popd > /dev/null 2>&1
