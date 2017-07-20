#!/bin/bash

kill -2 `cat /tmp/plantuml-server.pid`
kill -2 `cat /tmp/gollum-server.pid`
