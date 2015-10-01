#!/bin/bash
#

echo -ne "Killing mysql ... ";
kill $(cat /mysqld.pid)
echo "Done"
