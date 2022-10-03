Issue the following command to add the repository:

For RHEL-based systems:

rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/8/x86_64/zabbix-release-6.0-1.el8.noarch.rpm

For Ubuntu systems:

wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu22.04_all.deb

sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb

    Then issue the following command to install Zabbix agent 2:

For RHEL-based systems:

dnf -y install zabbix-agent2

For Ubuntu systems:

sudo apt install zabbix-agent2 zabbix-agent2-plugin-mongodb

# systemctl restart zabbix-agent2
# systemctl enable zabbix-agent2 

Congratulations, Zabbix agent 2 is now installed and ready to use.