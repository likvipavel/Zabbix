#!/bin/bash

#MANDATORY_ARGUMENTS: $1 - OS (ubuntu or rhel), $2 - proxy mode (active or passive), $3 - name of zabbix server, $4 - name of proxy server

#Let's start by adding the Zabbix 6.0 repository to our system.
if [ -n $1 ] & [ -n $2 ] & [ -n $3 ]& [ -n $4 ]; then
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/ x86_64/zabbix-release-6.0-1.el8.noarch.rpm
    sudo dnf clean all
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/ main/z/zabbix-release/zabbix-release_6.0-1+ubuntu20.04_all.deb
    sudo dpkg -i zabbix-release_6.0-1+ubuntu20.04_all.deb
    sudo apt update
fi

#Now, install Zabbix proxy by executing the following command.
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo dnf install zabbix-proxy-sqlite3
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install zabbix-proxy-sqlite3
fi

#Tip
#---On RHEL-based servers, don't forget to set Security-Enhanced Linux (SELinux) to permissive or allow Zabbix proxy in SELinux for production.
#---For lab environments it is fine to set SELinux to permissive, but in production I would recommend leaving it enabled. For Ubuntu systems, 
#---in a lab environment, we can disable AppArmor.

#Now, edit the Zabbix proxy configuration by executing the following command:
#---Let's start by setting the proxy mode on the passive proxy. The mode will be 1 on this proxy. On the active proxy, this will be 0:
if [ $2 == "active" ]; then
    sudo sed -i 's/ProxyMode=/ProxyMode=0/g' /etc/zabbix/zabbix_proxy.conf
elif [ $2 == "passive" ]; then
    sudo sed -i 's/ProxyMode=/ProxyMode=1/g' /etc/zabbix/zabbix_proxy.conf
fi

#Change the following line to your Zabbix server address:
    sudo sed -i 's/Server=/Server='{$3}'/g' /etc/zabbix/zabbix_proxy.conf
#Important note
#---When working with a Zabbix server in High Availability (HA), make sure to add the Zabbix server IP addresses here for every single node in your
#---cluster. The proxy will only be sending data to the active node. Keep in mind that HA nodes are delimited by a semi-colon (;) instead of a comma (,).

#Change the following line to your proxy hostname:
    sudo sed -i 's/Hostname=/Hostname='{$4}'/g' /etc/zabbix/zabbix_proxy.conf
  
#As we'll be using the sqlite version of the proxy for the example, change the DBName parameter to the following:
    sudo sed -i 's/DBName=/DBName=\/tmp\/zabbix_proxy.db/g' /etc/zabbix/zabbix_proxy.conf

#You can now enable Zabbix proxy and start it with the following two commands:
    sudo systemctl enable zabbix-proxy
    sudo systemctl start zabbix-proxy

#You might want to check that the Zabbix proxy logs will restart, with the following command:
#---tail -f /var/log/zabbix/zabbix_proxy.log
else echo 'You need to type four arguments'
fi