# start plantuml server
cd /home/karl/3rdparty/plantuml-server
# command="mvn jetty:run -Djetty.port=8080"
command="mvn jetty:run"
$command > /tmp/plantuml-server.log 2>&1 &
echo "$!" > /tmp/plantuml-server.pid

# start gollum
cd /home/karl/Scratch/mockwiki
command="gollum --port 4567 --config /home/karl/Scratch/mockwiki/gollum_admin/config.rb --live-preview --allow-uploads=page --collapse-tree"
$command > /tmp/gollum-server.log 2>&1 &
echo "$!" > /tmp/gollum-server.pid
