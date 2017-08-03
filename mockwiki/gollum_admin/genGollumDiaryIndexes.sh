#!/bin/bash
# This program formats a vimwiki diary.vimwiki file so that it is compatible
# for gollum to dispaly. The results are saved as an index.vimwiki file under
# the vimwiki/gollum repository [wikiname]/diary directory structure.
# The formatting is done in the awk script: Removes spaces at the beginning
# of lines, Adds a date indicator to the diary description/name, and fixes
# the tag/link so that gollum can find the diary entry.
#
# yes, this could/should be written in perl or python or something but I
# wanted to provide a shell script for those who rather have one.
#
# Usage:
# Execute this script from cron once per day or as needed from
# command line.
#
# Configuration:
# Edit repodir the location of your wiki repository.
#
# Cron:
# Note: you will have to have your credentials setup properly for git and run this
# under your user account for it to work properly.
# > crontab -e
# Here's a cron example (1:05 am every day because of daylight savings switches)
#5 1 * * * /home/karl/mockwiki/gollum_admin/genGollumDiaryIndexes.sh > /tmp/wtf 2<&1
#
# Author: [Karl N. Redman](https://github.com/karlredman)

# configuration
repodir="$HOME/mockwiki"
diaryname="diary.vimwiki"
targetindex="index.vimwiki"

# go to the repository
pushd $repodir > /dev/null 2>&1

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

		# check in the diary.vimwiki
    git add ${filelist[$i]} > /dev/null 2>&1
    git commit -m "Vimwiki generated index" ${filelist[$i]} > /dev/null 2>&1

    ### save the diary parent (wiki) directory name as $wikiname
    D1=$(dirname "${filelist[$i]}")
    D2=$(dirname $D1)
    wikiname=$(basename $D2)

	# to be included in diary.index for a placeholder for today's diary entry
    today=$(date +"%Y-%m-%d")

	# reformat the file in one pass
    # Anything after # Diary... remove beginning whitespace, add the wikiname
	# to the file path, and add the file name (date) to the description field
    file_content=`awk -v wikiname=$wikiname -v today=$today '
    {
        if(!match($0,/^\# Diary/))
        {
            if($0 ~ /\[\[/)
            {
                # attempted comment
                split($0, arr, /\[\[/, seps);
                split(arr[2], arr, /\]\]/, seps);
                split(arr[1], arr, /\|/, seps)

                printf("*    [[%s/diary/%s | [%s] %s]]\n", wikiname, arr[1], arr[1], arr[2])
            }
            else
            {
                print;
            }
        }
        else
        {
            print;
            printf("*    [[%s/diary/%s | [%s] Today Placeholder]]\n", wikiname, today, today);
        }
    }' ${filelist[$i]}`

    # some sed magic to remove whitespace at beginning of lines with links and set the proper link path
		# the awk script above replaces this -with some better formating
    # file_content=`sed -e '/\# Diary/,$s/^[ \t]*//' ${filelist[$i]} | sed -e '/\# Diary/,$s/\* \[\[/*\ \[\['${wikiname}'\/diary\//g'`

    # always add today as a placeholder to the index
		# the awk script above replaces this -with some better formating
    #file_content=`echo "$file_content" | sed '/\# Diary/a \\\n\* [['${wikiname}'\/diary\/'$today'\|Today Placeholder]]'`

    # write the content the index file
    index_file=$(dirname ${filelist[i]})/index.vimwiki
    echo "$file_content" > $index_file

    # Checking in the index.vimwiki
    git add $index_file > /dev/null 2>&1
    git commit -m "gollum generated index" $index_file > /dev/null 2>&1
done

# return to where we started
popd > /dev/null 2>&1
