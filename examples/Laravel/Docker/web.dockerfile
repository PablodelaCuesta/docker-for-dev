FROM nginx:latest

ADD ./config/vhost.conf /etc/nginx/conf.d/default.conf