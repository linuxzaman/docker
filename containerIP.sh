#!/bin/bash
docker inspect $(docker ps -aq)|grep -E 'Hostname|IPAddress'|grep -Ev 'HostnamePath|SecondaryIPAddresses'|sed -e 's/"//g' -e 's/Hostname://g' -e 's/IPAddress://g' -e 's/[[:space:]]//g' -e 's/,//g'|uniq|awk 'NR%2==0 {print $0"    "p;} NR%2 {p=$0;}'|sort
