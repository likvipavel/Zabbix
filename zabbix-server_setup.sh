#!/bin/bash

#MANDATORY_ARGUMENTS: $1 - OS (ubuntu or rhel), $2 - db_password
if [ -z $1 ] & [ -z $2 ]; then 
#Let's start by adding the Zabbix 6.0 repository to our system.
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-1.el8.noarch.rpm
    yum clean all
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb
    sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
    sudo apt update
fi

#Now that the repository is added, let's add the MariaDB repository on our server:
    wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
    chmod +x mariadb_repo_setup
    sudo ./mariadb_repo_setup

#Then install and enable it using the following commands:
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo yum install mariadb-server
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install mariadb-server=1:10.6.7-2ubuntu1 -y
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
fi

#After installing MariaDB, make sure to secure your installation with the following command:
    sudo /usr/bin/mariadb-secure-installation
#---Make sure to answer the questions with yes (Y) and configure a root password that's secure.
#---Run through the secure installation setup and make sure to save your password somewhere. It's highly recommended to use a password vault.

#Now, let's install our Zabbix server with MySQL support.
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo yum install zabbix-server-mysql zabbix-sql-scripts -y
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install zabbix-server-mysql zabbix-sql-scripts -y
fi

#With the Zabbix server installed, we are ready to create our Zabbix database. Log in to MariaDB with the following:
#---Enter the password you set up during the secure installation and create the Zabbix database with the following commands. Do not forget to change password in the second command:  
    mysql -u root -p$2  <<SQL_QUERY
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '${2}';
grant all privileges on zabbix.* to zabbix@localhost identified by '${2}';
flush privileges;
SQL_QUERY

#Now we need to import our Zabbix database scheme to our newly created Zabbix database:
    sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -u zabbix -p$2 zabbix
#---Important Note
#---At this point, it might look like you are stuck and the system is not responding. Do not worry though as it will just take a while to import the SQL scheme.

#We are now done with the preparations for our MariaDB side and are ready to move on to the next step, which will be configuring the Zabbix server:
#---The Zabbix server is configured using the Zabbix server config file. This file is located in /etc/zabbix/. Let's open this file with our favorite editor; I'll be using Vim throughout the book:

    #vim /etc/zabbix/zabbix_server.conf
#---Now, make sure the following lines in the file match your database name, database user username, and database user password:
    sed -i '$a DBPassword='${2}''  /etc/zabbix/zabbix_server.conf
#---Before starting the Zabbix server, you should configure SELinux or AppArmor to allow the use of the Zabbix server. If this is a test machine, you can use a permissive stance for SELinux or disable AppArmor, but it is recommended to not do this in production.
    
#All done; we are now ready to start our Zabbix server:
    sudo systemctl enable zabbix-server
    sudo systemctl start zabbix-server
#---Check whether everything is starting up as expected with the following:
    # systemctl status zabbix-server
#---Alternatively, monitor the log file, which provides a detailed description of the Zabbix startup process:
    # tail -f /var/log/zabbix/zabbix_server.log
#---Most of the messages in this file are fine and can be ignored safely, but make sure to read well and see if there are any issues with your Zabbix server starting.

######-Setting up the Zabbix frontend-########

#Let's jump right in and install the frontend. Issue the following command to get started.

#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo yum install zabbix-web-mysql zabbix-apache-conf -y
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo apt install zabbix-frontend-php zabbix-apache-conf -y
fi
#---Don't forget to allow ports 80 and 443 in your firewall if you are using one. Without this, you won't be able to connect to the frontend.

#Restart the Zabbix components and make sure they start up when the server is booted with the following.
#---For RHEL-based systems:
if [ $1 == "rhel" ]; then
    sudo systemctl enable httpd php-fpm
    sudo systemctl restart zabbix-server httpd php-fpm
#---For Ubuntu systems:
elif [ $1 == "ubuntu" ]; then
    sudo systemctl enable apache2
    sudo systemctl restart zabbix-server apache2
    fi
#We should now be able to navigate to our Zabbix frontend without any issues and start the final steps to set up the Zabbix frontend.
#---Let's go to our browser and navigate to our server's IP. It should look like this:
#---http://<your_server_ip>/zabbix 
else echo 'You need to type two arguments'
fi