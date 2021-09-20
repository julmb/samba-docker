FROM alpine
RUN apk add --no-cache samba
CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group", "--debuglevel=1"]
