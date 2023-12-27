FROM alpine:3.18.4

RUN apk update
RUN apk upgrade

# required by qemu
RUN apk add\
 make\
 samurai\
 perl\
 python3\
 gcc\
 libc-dev\
 pkgconf\
 linux-headers\
 glib-dev glib-static\
 zlib-dev zlib-static\
 flex\
 bison
 bison\
 meson

# additional
RUN apk add bash xz git patch

RUN apk add pixman-dev pixman-static\
            libbz2 bzip2-static\
            ncurses-dev ncurses-static

WORKDIR /work

ADD --link qemu src/qemu

COPY command/base command/base
#COPY command/fetch command/fetch
#RUN /work/command/fetch

#COPY command/extract command/extract
#RUN /work/command/extract

#COPY patch patch
#COPY command/patch command/patch
#RUN /work/command/patch

COPY command/slirp command/slirp
RUN /work/command/slirp
COPY command/configure command/configure
RUN /work/command/configure

COPY command/make command/make
RUN /work/command/make

COPY command/install command/install
RUN /work/command/install

COPY command/package command/package
RUN /work/command/package
