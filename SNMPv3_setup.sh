#!/bin/bash

#MANDATORY_ARGUMENTS: $1 - OS (ubuntu or rhel), $2 - my_authpass, $3 - my_privpass
#Monitoring via SNMP polling is easy and very powerful. We will start by configuring SNMPv3 on our monitored Linux host:

#Let's start by issuing the following commands to install SNMP on our host.
if [ -z $1 ] & [ -z $2 ] & [ -z $3 ]; then 
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo yum install net-snmp net-snmp-utils -y
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install snmp snmpd libsnmp-dev -y

#Now, let's create the new SNMPv3 user that we will use to monitor our host. Please note that we'll be using insecure passwords, but make sure to use secure passwords for your production environments. Issue the following command:
    net-snmp-create-v3-user -ro -a $2 -x $3 -A SHA -X AES snmpv3user
#---This will create an SNMPv3 user with the username snmpv3user, the authentication password my_authpass, and the privilege password my_ privpass.

#Make sure to edit the SNMP configuration file to allow us to read all SNMP objects:
    #vim /etc/snmp/snmpd.conf
#---And add the following line at the rest of the view systemview lines:
    sudo sed -i '$a view systemview included .1'  /etc/snmp/snmpd.conf
  

#Now start and enable the snmpd daemon to allow us to start monitoring this server:
    sudo systemctl enable snmpd
    sudo systemctl restart snmpd

#This is all we need to do on the Linux host side; we can now go to the Zabbix frontend to configure our host.
#Go to Configuration | Hosts in your Zabbix frontend and click Create host in the top-right corner.
else echo 'You need to type two arguments'
fi