FROM alpine:latest

RUN apk add --no-cache neovim git wget xclip python3-pip

RUN addgroup -S user && adduser -h /home/user -s /bin/sh -S -G user user

COPY . ~/.config/nvim/init.vim
