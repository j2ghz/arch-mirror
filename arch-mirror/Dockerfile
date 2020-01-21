FROM archlinux
RUN pacman -Syu diffutils docker rsync zsh jq go-ipfs --noconfirm

WORKDIR /mirror
#VOLUME /arch-repository
VOLUME /tmp/arch-repository

COPY *sh ./

CMD ./nicemonitor.zsh
