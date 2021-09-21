FROM alpine
RUN apk add --no-cache samba
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["entrypoint.sh"]
CMD ["smbd", "--foreground", "--no-process-group", "--log-stdout"]
