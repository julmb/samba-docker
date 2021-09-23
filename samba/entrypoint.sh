#!/bin/sh

echo "resetting users..."
echo "root:x:0:0:root:/root:/bin/ash" > /etc/passwd
echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" >> /etc/passwd
echo "root:!::0:::::" > /etc/shadow
echo "nobody:!::0:::::" >> /etc/shadow
echo "root:x:0:root" > /etc/group
echo "nogroup:x:65533:" >> /etc/group
echo "nobody:x:65534:" >> /etc/group

echo "resetting samba state..."
rm -r /var/lib/samba
mkdir /var/lib/samba
mkdir -m 770 /var/lib/samba/bind-dns
mkdir -m 700 /var/lib/samba/private
mkdir -m 755 /var/lib/samba/sysvol

while read line
do
	username=$(echo $line | cut -d " " -f 1)
	password=$(echo $line | cut -d " " -f 2)

	echo "adding $username with password $password..."
	adduser --disabled-password --no-create-home $username
	printf "$password\n$password" | smbpasswd -s -a $username
done < /etc/samba/users.conf

echo "resetting samba configuration..."
echo "[global]" > /etc/samba/smb.conf
echo "    log level = 1" >> /etc/samba/smb.conf

echo >> /etc/samba/smb.conf

while read line
do
	name=$(echo $line | cut -d " " -f 1)
	path=$(echo $line | cut -d " " -f 2)
	user=$(echo $line | cut -d " " -f 3)

	echo "adding share $name at $path for user $user"
	mkdir --parents "$path"
	echo "[$name]" >> /etc/samba/smb.conf
	echo "    path = $path" >> /etc/samba/smb.conf
	if test -z $user
	then
		chown nobody "$path"
		echo "    guest ok = yes" >> /etc/samba/smb.conf
	else
		chown $user "$path"
		echo "    valid users = $user" >> /etc/samba/smb.conf
	fi
	echo "    read only = no" >> /etc/samba/smb.conf
	echo "    inherit permissions = yes" >> /etc/samba/smb.conf
	echo "    store dos attributes = no" >> /etc/samba/smb.conf
done < /etc/samba/shares.conf

exec "$@"
