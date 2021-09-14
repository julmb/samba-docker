FROM alpine
RUN apk add --no-cache samba
COPY smb.conf /etc/samba/smb.conf
RUN mkdir --parents /srv/samba/projects
# TODO: get credentials from environment
RUN adduser --disabled-password --no-create-home user
RUN smbpasswd -a -n user
CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group", "--debuglevel=1"]
