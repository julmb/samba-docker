FROM alpine
RUN apk add --no-cache samba
COPY smb.conf /etc/samba/smb.conf
RUN adduser --disabled-password --no-create-home test
RUN printf "test\ntest" | smbpasswd -s -a test
RUN mkdir /data/projects
RUN chown test /data/projects
CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group", "--debuglevel=1"]
