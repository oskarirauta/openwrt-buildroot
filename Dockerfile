FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --no-cache --update add sudo busybox-suid && \
	apk --no-cache --update add nano openssh argp-standalone asciidoc bash bc binutils bzip2 cdrkit coreutils \
				diffutils elfutils-dev findutils flex musl-fts-dev g++ gawk gcc gettext git \
				grep intltool libxslt linux-headers make musl-libintl musl-obstack-dev \
				ncurses-dev openssl-dev patch perl python3-dev rsync tar \
				unzip util-linux wget zlib-dev bash sed sudo tmux \
				p7zip xz bison m4 autoconf automake cmake subversion && \
	apk --no-cache add quilt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
	apk --no-cache add perl-extutils-makemaker --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN \
	ln -s /usr/lib/libncurses.so /usr/lib/libtinfo.so

RUN \
	mkdir -p /home/user && \
	chown -R 1002:1002 /home/user

RUN \
	addgroup -g 1002 -S developers && \
	adduser -u 1002 -D -s /bin/sh -h /home/user -G developers -g user user

RUN \
	mkdir -p /usr/src && \
	chown -R 1002:1002 /usr/src

RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	rm -f /var/cache/apk/*

COPY sudoers /etc/sudoers
COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /scripts/entrypoint.sh

RUN \
	passwd -d root && \
	passwd -d user

USER user

VOLUME ["/home/user"]
VOLUME ["/usr/src"]
VOLUME ["/scripts/entrypoint.d"]
VOLUME ["/root"]

EXPOSE 22

ENTRYPOINT ["/scripts/entrypoint.sh"]
WORKDIR /usr/src
CMD ["/bin/bash"]
