# syntax=docker/dockerfile:1
FROM alpine:latest AS launch
WORKDIR /
RUN apk update ;\
	apk upgrade ;\
	apk add bash curl ;

COPY check_links.sh .

CMD ["-h"]
ENTRYPOINT ["bash", "check_links.sh"]
