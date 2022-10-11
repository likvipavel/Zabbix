#!/bin/bash


#If we go to the CLI of our monitored server, we can now execute the following to install Zabbix sender:
#---RHEL-based systems:
    sudo yum -y install zabbix-sender
#---Ubuntu systems:
    apt install zabbix-sender

#After installation, we can use Zabbix sender to send some information to our server:
    zabbix_sender -z 10.16.16.152 -s "my-agent-name" -k trap -o "Let's test this trapper"

#Now we should be able to see whether our monitored host has sent out the Zabbix trap and the Zabbix server has received this trap for processing.