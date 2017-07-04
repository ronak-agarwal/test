#!/bin/bash
echo "Node Type - "
echo $nodetype

### 1.  Openstack CLI to create NODE
openstack stack create --template hots/node-hot.yaml TOSCA-$nodetype

sleep 10

while [ -z "${node_pvt_ip}" ] || [ "${node_pvt_ip}" == "None" ]; do
	node_pvt_ip=`echo $(openstack stack show TOSCA-$nodetype -c outputs -f json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["outputs"][0]["output_value"]' )`
	echo $node_pvt_ip
done

### 2. set IP address of node in master_ip / minion_ip as env variables

if [ "$nodetype" = "master" ]; then
	rm $HOME/nodes	
	echo "master_ip "$node_pvt_ip >> $HOME/nodes
elif [ "$nodetype" = "minion" ]; then 	
	echo "minion_ip "$node_pvt_ip >> $HOME/nodes
else
   echo "Unknown parameter"	
fi	

