#!/bin/bash

#Issue the following command to add the repository:
if [ -n $1 ]; then
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

#TIPS: Using a Zabbix agent in active mode
#
#    Now let's check out how to configure the Zabbix agent with active checks. We need to change some values on the monitored Linux server host side:
#
#    Start by executing the following command:
#
#    vim /etc/zabbix/zabbix_agent2.conf
#    Now let's edit the following value to change this host to an active agent:
#
#    ServerActive=127.0.0.1
#    Change the value for ServerActive to the IP of the Zabbix server that will monitor this passive agent and also change the value of Hostname to lar-book-agent:
#
#    Hostname=lar-book-agent
#
#    Important note
#
#    Keep in mind that if you are working with multiple Zabbix servers or Zabbix proxies, for example when you are running Zabbix server in high availability, that you need to fill in all the Zabbix servers' or Zabbix proxies' their IP addresses at the ServerActive parameter. High Availability (HA) nodes are delimited by a semicolon (;) and different Zabbix environment IPs by a comma (,).
#    Now restart the Zabbix agent 2 process:
#
#    systemctl restart zabbix-agent2
#    Then move to the frontend of your Zabbix server and let's add another host with a template to do active checks instead of passive ones.