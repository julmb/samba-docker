#!/bin/sh

echo "reverting users..."
echo "root:x:0:0:root:/root:/bin/ash" > /etc/passwd
echo "root:!::0:::::" > /etc/shadow
echo "root:x:0:root" > /etc/group

while read line
do
    username=$(echo $line | cut -d " " -f 1)
    password=$(echo $line | cut -d " " -f 2)
    echo "adding $username..."
    adduser --disabled-password --no-create-home $username
    printf "$password\n$password" | smbpasswd -s -a $username
done < $1

exec "$@"
