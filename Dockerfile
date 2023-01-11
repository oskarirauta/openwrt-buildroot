FROM alpine:latest

RUN \
	apk --no-cache update && \
	apk --no-cache upgrade && \
	apk --no-cache --update add sudo busybox-suid && \
	apk --no-cache --update add nano openssh argp-standalone asciidoc bash bc binutils bzip2 cdrkit coreutils \
				diffutils elfutils-dev findutils flex musl-fts-dev g++ gawk gcc gettext git \
				grep intltool libxslt linux-headers make musl-libintl musl-obstack-dev \
				ncurses-dev openssl-dev patch perl python3-dev rsync tar \
				unzip util-linux wget zlib-dev bash sed sudo tmux git-bash-completion \
				p7zip xz bison m4 autoconf automake cmake subversion && \
	apk --no-cache add quilt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
	apk --no-cache add perl-extutils-makemaker --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN \
	ln -s /usr/lib/libncurses.so /usr/lib/libtinfo.so

RUN \
	mkdir -p /home/user && \
	chown -R 1002:1002 /home/user

RUN \
	addgroup -g 1002 -S devel && \
	adduser -u 1002 -D -s /bin/bash -h /home/user -G devel -g user user

RUN \
	mkdir -p /usr/src && \
	chown -R 1002:1002 /usr/src

RUN \
	mkdir -p /scripts /scripts/entrypoint.d

RUN \
	sed -i 's#/bin/sh#/bin/bash/#g' /etc/passwd && \
	rm /etc/motd && \
	rm /etc/profile && \
	rm -f /var/cache/apk/*

COPY sudoers /etc/sudoers
COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /scripts/entrypoint.sh
COPY profile /etc/profile

RUN \
	chown root:root /etc/profile && \
	chmod 644 /etc/profile

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
