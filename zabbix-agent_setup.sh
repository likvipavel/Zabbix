#!/bin/bash

#Issue the following command to add the repository:
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-release-6.0-4.el7.noarch.rpm
    sudo yum clean all
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
    sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
fi

#Then issue the following command to install Zabbix agent 2:
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo yum install zabbix-agent2 zabbix-agent2-plugin-mongodb 
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install zabbix-agent2 zabbix-agent2-plugin-mongodb
fi
    sudo systemctl restart zabbix-agent2
    sudo systemctl enable zabbix-agent2 

#Congratulations, Zabbix agent 2 is now installed and ready to use.