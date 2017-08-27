#!/bin/bash

# starts the plantuml and gollum servers in the background
# not suitable as a service script

# Configuration
## PlantUML
plantuml_installdir="$HOME/3rdparty/plantuml-server"
plantuml_port="8989"        # remember to upate gollum's config.rb for this port as well
## Gollum
gollum_plantuml_url="http://localhost:$plantuml_port/plantuml/png"
gollum_repodir="$HOME/mockwiki"
gollum_configfile="$gollum_repodir/gollum_admin/config.rb"
gollum_port="4567"

waitstart_plantuml=10       # how long to wait for the plantuml server to start

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
    command="mvn jetty:run -Djetty.port=$plantuml_port"
    $command > /tmp/$program-server.log 2>&1 &
    echo "$!" > /tmp/$program-server.pid

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
    cd $gollum_repodir
    command="gollum --port $gollum_port --config $gollum_configfile --plantuml-url $gollum_plantuml_url --emoji --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
    $command > /tmp/$program-server.log 2>&1 &
    echo "$!" > /tmp/$program-server.pid
fi


echo "start_gollum.sh: done."
