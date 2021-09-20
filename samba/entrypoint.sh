#!/bin/sh

echo "reverting users..."
echo "root:x:0:0:root:/root:/bin/ash" > /etc/passwd
echo "root:!::0:::::" > /etc/shadow
echo "root:x:0:root" > /etc/group

while read line
do
    username=$(echo $line | cut -d " " -f 1)
    password=$(echo $line | cut -d " " -f 2)

    echo "adding $username with password $password..."
    adduser --disabled-password --no-create-home $username
    printf "$password\n$password" | smbpasswd -s -a $username
done < /etc/samba/users.conf

echo "[global]" > /etc/samba/smb.conf
echo "    log file = /var/log/samba/%m" >> /etc/samba/smb.conf
echo "    log level = 1" >> /etc/samba/smb.conf
echo "    server role = standalone server" >> /etc/samba/smb.conf

echo >> /etc/samba/smb.conf

while read line
do
    name=$(echo $line | cut -d " " -f 1)
    path=$(echo $line | cut -d " " -f 2)
	users=$(echo $line | cut -d " " -f 3-)

	echo "adding share $name at $path for users [$users]"
	echo "[$name]" >> /etc/samba/smb.conf
	echo "    path = $path" >> /etc/samba/smb.conf
	echo "    read only = no" >> /etc/samba/smb.conf
	echo "    valid users = $users" >> /etc/samba/smb.conf
	echo "    inherit permissions = yes" >> /etc/samba/smb.conf
done < /etc/samba/shares.conf

exec "$@"