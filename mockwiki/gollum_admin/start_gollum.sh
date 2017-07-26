#!/bin/bash

# Configuration
## PlantUML
plantuml_installdir="$HOME/3rdparty/plantuml-server"
plantuml_port="8989"        # remember to upate gollum's config.rb for this port as well
## Gollum
gollum_plantuml_url="http://localhost:$plantuml_port/plantuml/png"
gollum_repodir="$HOME/mockwiki"
gollum_configfile="$gollum_repodir/gollum_admin/config.rb"
gollum_port="4567"


## start plantuml server
program="plantuml"
proclive=`ps -ax |grep -E -e 'bin/java.*maven.*plantuml' |grep -v 'grep'`
if [ "${proclive}" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $plantuml_installdir
    command="mvn jetty:run -Djetty.port=$plantuml_port"
    $command > /tmp/plantuml-server.log 2>&1 &
    echo "$!" > /tmp/plantuml-server.pid

    sleeptime=10
    echo "Sleeping for $sleeptime while plantuml starts..."
    sleep 10
fi



# start gollum
program="gollum"
proclive=`ps -ax |grep -E -e 'bin/ruby.*/bin/gollum' |grep -v 'grep'`
if [ "${proclive}" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $gollum_repodir
    command="gollum --port $gollum_port --config $gollum_configfile --plantuml-url $gollum_plantuml_url --emoji --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
    $command > /tmp/gollum-server.log 2>&1 &
    echo "$!" > /tmp/gollum-server.pid
fi


echo "start_gollum.sh: done."
