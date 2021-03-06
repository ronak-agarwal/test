#!/bin/bash

master_ip=`echo $(look master_ip $HOME/nodes | cut -d ' ' -f 2-)`
minion_ip=`echo $(look minion_ip $HOME/nodes | cut -d ' ' -f 2-)`

echo "Erikube Setup"
echo $build

echo "Install wget."
yum install wget -y

url=$jenkins_url/$build
echo $url

wget $url
echo "Untar erikube installer"
tar xzf $build

echo "Setup boot node"
cd erikube-deployment/ansible/sh/
sh setup-node.sh

echo "Install ansible"
sh setup-ansible.sh

#Update below files with BOOT_IP, MASTER_IP, MINION_IP AND DNS_NAMESEREVER_IP

cd ../inventories/inventory-dev/

#vim hosts
sed -i s/10.10.10.6/$boot_ip/g hosts
sed -i s/10.10.10.40/$boot_ip/g hosts
sed -i s/10.10.10.10/$master_ip/g hosts
sed -i s/10.10.10.20/$minion_ip/g hosts

#vim group_vars/all
sed -i s/147.214.9.30/$dns_ns_ip/g group_vars/all
sed -i s/147.214.252.30//g group_vars/all

x=$boot_ip
oc1=${x%%.*}
x=${x#*.*}
oc2=${x%%.*}
x=${x#*.*}
oc3=${x%%.*}
x=${x#*.*}
oc4=${x%%.*}

cd group_vars
sed -i s/10.10.10/$oc1.$oc2.$oc3/g all
sed -i s/}.6/}.$oc4/g *
sed -i s/enp0s3/eth0/g *
sed -i s/enp0s8/eth0/g *

echo "Move ansible folder to jedi"
cd ../../../../
mv ansible/ /home/jedi/.
chown -R jedi:jedi /home/jedi/.

echo "####### Run ansible playbooks ######### "
cd /home/jedi/ansible/playbooks/
#ansible-playbook -i ../inventories/inventory-dev/ manage-jedi-ceph.yml 
#ansible-playbook -i ../inventories/inventory-dev/ manage-jedi-ext-ingress-lb.yml 
ansible-playbook -i ../inventories/inventory-dev/ manage-jedi-kube.yml 
#ansible-playbook -i ../inventories/inventory-dev/ manage-jedi-lb-certs.yml 
#ansible-playbook -i ../inventories/inventory-dev/ manage-jedi-pv.yml