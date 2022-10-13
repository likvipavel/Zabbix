#!/bin/bash

#MANDATORY_ARGUMENTS: $1 - OS (ubuntu or rhel), $2 - db_password

#Setting up database monitoring
#Databases are a black hole to a lot of engineers; there's data being written to them and there's something being done with this data. But what if you want to know more about the health of your database? That's where Zabbix database monitoring comes in – we can use it to monitor the health of our database.
#Getting ready
#We'll be monitoring our Zabbix database, for convenience. This means that all we are going to need is our installed Zabbix server with our database on it. We'll be using MariaDB in this example, so if you have a PostgreSQL setup, make sure to install a MariaDB instance on a Linux host.
#How to do it…
#Before getting started with the item configuration, we'll have to do some stuff on the CLI side of the server:

#Let's start by installing the required modules on our server.
if [ -n $1 ] & [ -n $2 ]; then
#---RHEL-based systems:
if [ $1 == "rhel" ]; then
    dnf install unixODBC mariadb-connector-odbc
#---Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    apt install odbc-mariadb unixodbc unixodbc-dev odbcinst
fi

#Now let's verify whether our Open Database Connectivity (ODBC) configuration files exist:
    odbcinst -j
#---Your output should look as follows:
#unixODBC 2.3.7
#DRIVERS............: /etc/odbcinst.ini
#SYSTEM DATA SOURCES: /etc/odbc.ini
#FILE DATA SOURCES..: /etc/ODBCDataSources
#USER DATA SOURCES..: /root/.odbc.ini
#SQLULEN Size.......: 8
#SQLLEN Size........: 8
#SQLSETPOSIROW Size.: 8

#If the output is correct, we can go to the Linux CLI and continue by editing odbc.ini to connect to our database:
#---Now fill in your Zabbix database information. It will look like this:
    vim /etc/odbc.ini << EOF
[book]
Description = MySQL book test database
Driver = MariaDB Unicode
Server = 127.0.0.1
Port = 3306
Database = zabbix
Password = '{$2}'
Username = zabbix
EOF

#Now let's test whether our connection is working as expected by executing this:
    sudo -u zabbix isql -v book
#---You should get a message saying Connected; if you don't, then check your configuration files and try again.

#Now let's move to the Zabbix frontend to configure our first database check. Navigate to Configuration | Hosts and click the host called lar-book-centos, or it might still be called Zabbix server. Now go to Items; we want to create a new item here by clicking the Create item button.
#Tip: If you haven't already, a great way to keep your Zabbix structured is to keep all hostnames in Zabbix equal to the real server hostname. Rename your default Zabbix server host in the frontend to what you've actually called your server.
fi