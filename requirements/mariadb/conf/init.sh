#!/bin/bash

# set -e 
# chown -R mysql:mysql /var/lib/mysql
# mkdir -p /var/run/mysqld
# chown mysql:mysql /var/run/mysqld
# chmod 777 /var/run/mysqld

# ###########################################################################
# ## Try to connect [max_attempts_connection] before to message error and stop 
# echo "Bonjour"
# try_connection=0;
# max_attempts_connection=4;
# service mysql start
# echo "STARTED"
# until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "" ; do
# 	try_connection=$((try_connection + 1))trying
# 	if [ "$try_connection" -ge "$max_attempts_connection" ] ; then
# 		echo "Enable to connect MariaDB root. Make sure have the right password. The issues could also due to a bad container setting, check if listening port is available and if setting files are correctly shared. If everythings are correct, you can try to increse [max_attempts_connection] (l.10) in ./mariadb/conf/init.sh file"
# 		exit 1
# 	fi
# 	sleep 7
# done
# echo "AUREVOIR"


# ###############################################################################
# ##-- Create data base with user root
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# ###############################################################################
# ##--Create admin user and guest using docker secret files

# if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER \`${ADMIN_USER}\` @'%' IDENTIFIED BY '${ADMIN_PASSWORD}';" ; then
# 	echo "User ${ADMIN_USER} successfully created."
# else
# 	echo "${ADMIN_USER} user couldnt be created."
# 	exit 1
# fi
# if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${ADMIN_USER}\`@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';" ; then
# 	echo "\`${ADMIN_USER}\` privileges changed."
# else 
# 	echo "\`${ADMIN_USER}\` privileges couldn't be changed."
# 	exit 1
# fi

# if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER \`${USER1_LOGIN}\` @'%' IDENTIFIED BY \"${USER1_PASSWORD}\";" ; then
# 	echo "User ${USER1_LOGIN} succesfully created."
# else
# 	echo "${USER1_LOGIN} user couldnt be created."
# 	exit 1
# fi
# if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT SELECT ON \`${MYSQL_DATABASE}\`.* TO \`${USER1_LOGIN}\`@'%' IDENTIFIED BY '${USER1_PASSWORD}';" ; then
# 	echo "\`${USER1_LOGIN}\` privileges changed."
# else 
# 	echo "\`${USER1_LOGIN}\` privileges couldn't be changed."
# 	exit 1
# fi

# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# echo "START"
# mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" ping
# # grep -i socket /etc/mysql/my.cnf
# # grep -i socket /etc/mysql/mariadb.conf.d/*
# # ls -l /var/run/mysqld/mysqld.sock
# echo "$MYSQL_ROOT_PASSWORD"
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -S /var/run/mysqld/mysqld.sock -e "SELECT VERSION();"
# mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
# echo "END"

# exec mysqld_safe

service mysql start

# Boucle d'attente pour vérifier si le service est prêt
until mysqladmin ping --silent; do
    echo "En attente de MariaDB..."
    sleep 1
done

echo "$MYSQL_ROOT_PASSWORD IS SET"
mysql -u root -p${MYSQL_ROOT_PASSWORD} --host=127.0.0.1 -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
echo "1"


mysql -u root -p${MYSQL_ROOT_PASSWORD} --host=127.0.0.1 -e "CREATE USER IF NOT EXISTS \`${ADMIN_USER}\`@'localhost' IDENTIFIED BY '${ADMIN_PASSWORD}';"
sleep 1
echo "2"

mysql -u root -p${MYSQL_ROOT_PASSWORD} --host=127.0.0.1 -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${ADMIN_USER}\`@'%' IDENTIFIED BY '${ADMIN_PASSWORD}';"
sleep 1
echo "3"

mysql -u root -p${MYSQL_ROOT_PASSWORD} --host=127.0.0.1 -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
sleep 1
echo "4"

mysql -u root -p${MYSQL_ROOT_PASSWORD} --host=127.0.0.1 -e "FLUSH PRIVILEGES;"
sleep 1
echo "5"

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

exec mysqld_safe

