#!/bin/bash

# This is not very robust.

kill -15 `cat /tmp/plantuml-server.pid` > /dev/null 2<&1
sleep 2
proclive=`ps -ax |grep -E -e 'bin/java.*maven.*plantuml' |grep -v 'grep'`
if [ "${proclive}" ]; then
   id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that plantuml is still running with PID $id!"
fi


kill -15 `cat /tmp/gollum-server.pid` > /dev/null 2<&1
sleep 2
proclive=`ps -ax |grep -E -e 'bin/ruby.*/bin/gollum' |grep -v 'grep'`
if [ "${proclive}" ]; then
     id=`echo $proclive | awk '{print $1}'`
     echo "NOTICE: it appears that gollum is still running with PID $id!"
fi

echo "stop_gollum.sh: done."
