# start plantuml server
#cd /home/karl/3rdparty/plantuml-server
cd $HOME/3rdparty/plantuml-server
# command="mvn jetty:run -Djetty.port=8989"
command="mvn jetty:run"
$command > /tmp/plantuml-server.log 2>&1 &
echo "$!" > /tmp/plantuml-server.pid

# start gollum
cd $HOME/mockwiki
command="gollum --port 4567 --config $HOME/mockwiki/gollum_admin/config.rb --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
#cd /home/karl/mockwiki
#command="gollum --port 4567 --config /home/karl/mockwiki/gollum_admin/config.rb --mathjax --live-preview --allow-uploads=page --collapse-tree --adapter grit"
$command > /tmp/gollum-server.log 2>&1 &
echo "$!" > /tmp/gollum-server.pid
