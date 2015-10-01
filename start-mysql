#!/bin/bash
#

echo -ne "Starting mysql ... ";
touch /mysqld.pid
chmod 777 /mysqld.pid
mysqld --user=root --skip-networking --pid-file=/mysqld.pid > /dev/null 2>&1 &
mysqladmin --silent --wait=30 ping > /dev/null
echo "Done";

