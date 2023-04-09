FROM postgres:13

# add scripts to initialize the database
COPY init.sql /docker-entrypoint-initdb.d/10-init.sql
COPY views.sql /docker-entrypoint-initdb.d/11-views.sql
COPY procedures.sql /docker-entrypoint-initdb.d/12-procedures.sql
# COPY triggers.sql /docker-entrypoint-initdb.d/13-triggers.sql
COPY insert.sql /docker-entrypoint-initdb.d/14-insert.sql


