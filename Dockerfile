FROM rust:alpine3.16

ENV PG_DATA=/woongzz0110/timescaledb/data

# install postgresql
RUN apk update
RUN apk --no-cache add bash postgresql14 postgresql-dev postgresql-libs pkgconfig
ADD ./src/run_postgres.sh /src/run_postgres.sh
RUN chmod +x /src/run_postgres.sh && /src/run_postgres.sh
########################

# install timescaledb
RUN apk --no-cache add git gcc cmake build-base
RUN git clone -b 2.5.1 https://github.com/timescale/timescaledb.git /clone/timescaledb
RUN cd /clone/timescaledb ./bootstrap
RUN cd /clone/timescaledb/build && make && make install
########################

# install timescaledb-toolkit
RUN apk --no-cache add make openssl-dev cargo
RUN cargo install --version '=0.5.4' --force cargo-pgx
RUN cargo pgx init --pg14 pg_config
RUN git clone https://github.com/timescale/timescaledb-toolkit /clone/timescaledb-toolkit
RUN cd /clone/timescaledb-toolkit/extension && cargo pgx install --release
RUN cd /clone/timescaledb-toolkit/extension && cargo run --manifest-path ../tools/post-install/Cargo.toml -- pg_config
########################

# make workdir
WORKDIR /woongzz0110/timescaledb
VOLUME [ "/woongzz0110/timescaledb"]
RUN rm -rf /clone
########################

USER 1001
EXPOSE 5432