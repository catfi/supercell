#!/bin/sh

### change database hostname in module file
./set_xml.py ../lib/node/world-server/WorldServerModule.module database_hostname localhost
./set_xml.py ../lib/node/auth-server/AuthServerModule.module database_hostname localhost

./ManagementShell.py load -n localhost -t c72942c6-c212-11df-ae55-001d92648328 --module-path ../lib/node/world-server/ --node-type 2
./ManagementShell.py load -n localhost -t fa8b1c82-c214-11df-be30-001d92648328 --module-path ../lib/node/world-gw/ --node-type 3
./ManagementShell.py load -n localhost -t 3e03f268-c215-11df-a50f-001d92648328 --module-path ../lib/node/auth-gw/ --node-type 1
./ManagementShell.py load -n localhost -t 38420176-c215-11df-bc93-001d92648328 --module-path ../lib/node/auth-server/ --node-type 0
./ManagementShell.py bind -n localhost -s 3e03f268-c215-11df-a50f-001d92648328 -t 38420176-c215-11df-bc93-001d92648328 --relation 1
./ManagementShell.py bind -n localhost -s fa8b1c82-c214-11df-be30-001d92648328 -t c72942c6-c212-11df-ae55-001d92648328 --relation 0 --mem-size 51200008
./ManagementShell.py bind -n localhost -s fa8b1c82-c214-11df-be30-001d92648328 -t 38420176-c215-11df-bc93-001d92648328 --relation 2 --max-session 30000
