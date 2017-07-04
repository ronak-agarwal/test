#!/bin/bash
echo "Node Type - "
echo $nodetype

openstack stack delete TOSCA-$nodetype -y