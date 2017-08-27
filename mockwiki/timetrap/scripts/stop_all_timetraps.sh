#!/bin/bash
# get names of sheets from `t now`
x=$(t now 2>/dev/null| sed 's/\:.*$//' | sed 's/^.//');

# TODO: this version doesn't handle multiline notes
# change the program to use `t list`

# go somewhere there is now timesheet
pushd /

for i in ${x[@]};
do
    # `switch to sheet`
    t s $i;
    # `punch out`
    t o;

    echo killing: $i
done
popd
