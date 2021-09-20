FROM alpine
RUN apk add --no-cache samba
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]
CMD ["smbd", "--foreground", "--log-stdout", "--no-process-group", "--debuglevel=1"]
