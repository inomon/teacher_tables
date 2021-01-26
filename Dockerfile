FROM docker.io/bitnami/mariadb:10.3-debian-10

# DB scripts
RUN	mkdir /usr/sql
RUN	chmod 777 /usr/sql

ADD ["db.sql", "/usr/sql/db.sql"]

