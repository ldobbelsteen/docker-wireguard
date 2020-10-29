FROM alpine
RUN apk add --no-cache wireguard-tools bash
COPY run.sh .
CMD ["/run.sh"]
