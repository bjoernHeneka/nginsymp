# NginSymP (Nginx + Symfony + PHP)

### Description
This is a base image with Nginx, PHP 7.1 and symfony configuration.
  
**Must be symfony version > 3.3**

This image is used as base image
Build you application with an own Dockerfile.

### Build
```dockerfile
FROM bjoernheneka/nginsymp:latest

MAINTAINER Bjoern Heneka <bheneka@codebee.de>

ADD application /var/www/symfony

RUN mkdir -p /var/www/symfony/web/media/cache && \
    mkdir -p /var/www/symfony/var/cache  && \
    chmod 0755 /var/www/symfony -R && \
    chmod 0775 /var/www/symfony/web/media/cache/ -R && \
    chmod 0775 /var/www/symfony/var/ -R && \
    chown 1000.1000 -R /var/www/symfony
 
```