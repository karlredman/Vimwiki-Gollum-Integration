#!/bin/bash

# configuration
repodir="$HOME/mockwiki"
diaryname="diary.vimwiki"
targetindex="index.vimwiki"

# go to the repository
pushd $repodir

# get list of files (accepting spaces in file names for no reason)
filelist=()
while IFS=  read -r -d $'\0'; do
    filelist+=("$REPLY")
done < <(find $repodir -name "$diaryname" -print0)

## for each file that matches diary/$diaryname
for i in ${!filelist[@]}; do

    # First, let's update the vimwiki diary indexes
    # NOTE: for large wikis this may take a long time (as in several minutes)
    # comment out if needed
    # TODO: we need a better way to do this I think
    vim -e -c VimwikiDiaryGenerateLinks ${filelist[$i]} -c wq
    git add ${filelist[$i]} > /dev/null 2>&1
    git commit -m "gollum generated index" ${filelist[$i]} > /dev/null 2>&1

    ### save the diary parent (wiki) directory name as $wikiname
    D1=$(dirname "${filelist[$i]}")
    D2=$(dirname $D1)
    wikiname=$(basename $D2)

    # TODO: add the date to the entry text

    # remove space at the beginning of lines after # Diary in the file
    # some sed magic to remove whitespace at beginning of line and set the proper link
    file_content=`sed -e '/Diary/,$s/^[ \t]*//' ${filelist[$i]} | sed -e '/Diary/,$s/\* \[\[/*\ \[\['${wikiname}'\/diary\//g'`


    # always add today as a placeholder to the index
    today=$(date +"%Y-%m-%d")
    file_content=`echo "$file_content" | sed '/\# Diary/a \\\n\* [['${wikiname}'\/diary\/'$today'\|Today Placeholder]]'`

    # write the content the index file
    index_file=$(dirname ${filelist[i]})/index.vimwiki
    echo "$file_content" > $index_file

    # Now for the scary part. Checking in the file
    git add $index_file > /dev/null 2>&1
    git commit -m "gollum generated index" $index_file > /dev/null 2>&1
done

# return to where we started
popd
