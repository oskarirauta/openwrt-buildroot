FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --no-cache --update add sudo busybox-suid && \
	apk --no-cache --update add nano openssh argp-standalone asciidoc bash bc binutils bzip2 cdrkit coreutils && \
	apk --no-cache --update add diffutils elfutils-dev findutils flex musl-fts-dev g++ gawk gcc gettext git && \
	apk --no-cache --update add grep intltool libxslt linux-headers make musl-libintl musl-obstack-dev && \
	apk --no-cache --update add ncurses-dev openssl-dev patch perl python3-dev rsync tar && \
	apk --no-cache --update add unzip util-linux wget zlib-dev bash && \
	apk --no-cache --update add p7zip xz bison m4 autoconf automake cmake subversion && \
	apk --no-cache add quilt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN \
	ln -s /usr/lib/libncurses.so /usr/lib/libtinfo.so

RUN \
	mkdir -p /home/user && \
	chown -R 1002:1002 /home/user

RUN \
	addgroup -g 1002 -S developers && \
	adduser -u 1002 -D -S -h /home/user -G developers -g user user

RUN \
	mkdir -p /usr/src && \
	chown -R 1002:1002 /usr/src

RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /var/cache/apk/*

COPY entrypoint.sh /scripts/entrypoint.sh

VOLUME ["/home/user"]
VOLUME ["/usr/src"]
VOLUME ["/scripts/entrypoint.d"]

EXPOSE 22

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/entrypoint.sh"]
WORKDIR /usr/src
CMD ["/bin/sh"]
