FROM postgres:14.6-bullseye

ENV TS_HOME=/opt/woongzz0110/timescaledb

ENV PGDATA=${TS_HOME}/data
ENV POSTGRES_PASSWORD=postgres

# make workdir
RUN mkdir -p ${PGDATA}
RUN chown -R postgres:postgres ${PGDATA} ${PGLOG} ${PGROOT}
WORKDIR ${TS_HOME}
########################

# install timescaledb
RUN apt update && apt install -y sudo wget lsb-release
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
RUN wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
RUN apt update && apt -y install timescaledb-2-2.8.1-postgresql-14 timescaledb-toolkit-postgresql-14
########################

# init db
RUN echo "shared_preload_libraries='pg_stat_statements,timescaledb'" >> /usr/share/postgresql/14/postgresql.conf.sample
ADD ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
########################

USER postgres
EXPOSE 5432
VOLUME ["${TS_HOME}"]