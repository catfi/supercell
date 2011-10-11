#!/bin/bash

### change database hostname in module file
#./set_xml.py ../lib/node/world-server/WorldServerModule.module database_hostname $ZILLIANS_MANAGEMENT_SERVER
#./set_xml.py ../lib/node/auth-server/AuthServerModule.module database_hostname $ZILLIANS_MANAGEMENT_SERVER

help ()
{
	echo "usage: $0 [options]"
	echo ""
	echo "[options]"
	echo "  -h			show this help"
	echo "  -g [game_ids]		game id list, for example: \"0 1 2\""
	echo "  -a {mt | fermi} 	which architecture kernel module to load"
	echo "  -m [ms_host] 		Management server host address"
	echo ""
	exit 0
}

while getopts "hg:a:m:" opt; do
	case $opt in
		h)
			help
			;;
		g)
			ZILLIANS_GAME_IDS=$OPTARG
			;;
		a)	
			if [[ $OPTARG != "mt" && $OPTARG != "fermi" ]]; then
				echo "Unknow options: $OPTARG"
				exit 1
			fi
			ZILLIANS_ARCH=$OPTARG
			;;
		m)
			ZILLIANS_MANAGEMENT_SERVER=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

if test ! $ZILLIANS_ARCH; then
	echo "Missing -a options"
	help
	exit 1
fi

if test ! $ZILLIANS_GAME_IDS; then
	echo "Misssing -g options"
	help
	exit 1
fi

if test ! $ZILLIANS_MANAGEMENT_SERVER; then 
	echo "Misssing -m options"
	help
	exit 1
fi

if [ $ZILLIANS_ARCH == "mt" ]; then
	WS_COMPONENT_ID="com.zillians.module.world-server.kernel-mt.WorldServerKernelMultiThread"
elif [ $ZILLIANS_ARCH == "fermi" ]; then
	WS_COMPONENT_ID="com.zillians.module.world-server.kernel-fermi.WorldServerKernelFermi"
fi

WORLD_SERVER_ID="c72942c6-c212-11df-ae55-001d92648328" 
WORLD_GATEWAY_ID="fa8b1c82-c214-11df-be30-001d92648328"
AUTH_GATEWAY_ID="3e03f268-c215-11df-a50f-001d92648328"
AUTH_SERVER_ID="38420176-c215-11df-bc93-001d92648328"
LOGGER_SERVER_ID="3b72f111-b7f7-4353-a76c-75785e11157c"

# load server/gateway module
./ManagementShell.py load -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --module-path ../lib/node/world-server/$ZILLIANS_ARCH --node-type 2
./ManagementShell.py load -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_GATEWAY_ID --module-path ../lib/node/world-gw/ --node-type 3
./ManagementShell.py load -n $ZILLIANS_MANAGEMENT_SERVER -t $AUTH_GATEWAY_ID --module-path ../lib/node/auth-gw/ --node-type 1
./ManagementShell.py load -n $ZILLIANS_MANAGEMENT_SERVER -t $AUTH_SERVER_ID --module-path ../lib/node/auth-server/ --node-type 0
./ManagementShell.py load -n $ZILLIANS_MANAGEMENT_SERVER -t $LOGGER_SERVER_ID --module-path ../lib/node/logger-server/ --node-type 4

# start processors on world server
./ManagementShell.py start -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --processor $ZILLIANS_ARCH --component-id $WS_COMPONENT_ID
./ManagementShell.py start -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --processor "database" --component-id $WS_COMPONENT_ID
./ManagementShell.py start -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --processor "external"
./ManagementShell.py start -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --processor "logger" --node-id $LOGGER_SERVER_ID

# bind aa
./ManagementShell.py bind -n $ZILLIANS_MANAGEMENT_SERVER -s $AUTH_GATEWAY_ID -t $AUTH_SERVER_ID --relation 1
# bind ww
./ManagementShell.py bind -n $ZILLIANS_MANAGEMENT_SERVER -s $WORLD_GATEWAY_ID -t $WORLD_SERVER_ID --relation 0 --mem-size 512000008 --module-type "$ZILLIANS_ARCH"

# bind wa
./ManagementShell.py bind -n $ZILLIANS_MANAGEMENT_SERVER -s $WORLD_GATEWAY_ID -t $AUTH_SERVER_ID --relation 2
# register ww
./ManagementShell.py register -n $ZILLIANS_MANAGEMENT_SERVER -s $WORLD_GATEWAY_ID -t $WORLD_SERVER_ID --relation 0 --game-id $ZILLIANS_GAME_IDS
# register wa
./ManagementShell.py register -n $ZILLIANS_MANAGEMENT_SERVER -s $WORLD_GATEWAY_ID -t $AUTH_SERVER_ID --relation 2 --max-session 30000 --game-id $ZILLIANS_GAME_IDS

# start game module
./ManagementShell.py start -n $ZILLIANS_MANAGEMENT_SERVER -t $WORLD_SERVER_ID --module-type $ZILLIANS_ARCH --game-id $ZILLIANS_GAME_IDS

