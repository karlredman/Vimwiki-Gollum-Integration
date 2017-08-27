#!/bin/bash

# starts the plantuml and gollum servers in the background
# not suitable as a service script

#setup include path
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
    DIR="$PWD"
fi

# include config
. "$DIR/config.sh"


########### End of configuration section

## start plantuml server
### does not report if it fails -see the log
program="plantuml"
proclive=`ps -ax |grep -E -e 'bin/java.*maven.*plantuml' |grep -v 'grep'`
if [ "${proclive}" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $plantuml_installdir
    command="nohup mvn jetty:run -Djetty.port=$plantuml_port"
    $command > /tmp/$program-$server_type-server.log 2>&1 &
    echo "$!" > /tmp/$program-$server_type-server.pid

    echo "Sleeping for $waitstart_plantuml while PlantUML starts..."
    sleep $waitstart_plantuml
fi

# start gollum server
### does not report if it fails -see the log...
program="gollum"
proclive=`ps -ax |grep -E -e 'bin/ruby.*/bin/gollum' |grep -v 'grep'`
if [ "${proclive}" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $repodir
    command="nohup gollum --port $gollum_port --config $gollum_configfile --plantuml-url $gollum_plantuml_url --emoji --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
    $command > /tmp/$program-$server_type-server.log 2>&1 &
    echo "$!" > /tmp/$program-$server_type-server.pid
fi


echo "start_gollum.sh: done."
