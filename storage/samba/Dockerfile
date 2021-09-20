FROM alpine
RUN apk add --no-cache samba
COPY smb.conf /etc/samba/smb.conf
RUN mkdir --parents /srv/samba/projects
RUN adduser --disabled-password --no-create-home test
RUN printf "test\ntest" | smbpasswd -s -a test
CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group", "--debuglevel=1"]
