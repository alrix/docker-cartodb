# Installs v4.12.49

FROM ubuntu:xenial

RUN apt-get update \
 && apt-get install -q -y make pkg-config git \
 && apt-get -y install software-properties-common \
 && apt-get -y install locales \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV RAILS_ENV production

# Install core utilies
RUN apt-get update \
 && apt-get install -y python-software-properties \
 && apt-get install -y autoconf binutils-doc bison build-essential flex \
 && rm -rf /var/lib/apt/lists/*

# Postgres 10
RUN add-apt-repository -y ppa:cartodb/postgresql-10 \
 && apt-get update \
 && apt-get install -y postgresql-10 postgresql-plpython-10 postgresql-server-dev-10 postgresql-10-plproxy \ 
 && rm -rf /var/lib/apt/lists/*
ADD pg_hba.conf /etc/postgresql/10/main/pg_hba.conf
ADD postgresql.conf /etc/postgresql/10/main/postgresql.conf

#create users
RUN service postgresql start \
 && createuser --no-createrole --no-createdb --no-superuser -U postgres publicuser \
 && service postgresql stop
RUN service postgresql start \
 && createuser --no-createrole --no-createdb --no-superuser -U postgres tileuser \
 && service postgresql stop

# Build cartodb extension for postgres
ENV CARTODB_POSTGRESQL_VERSION 0.23.2
RUN cd /opt \
 && git clone https://github.com/CartoDB/cartodb-postgresql.git \
 && cd cartodb-postgresql \
 && git checkout ${CARTODB_POSTGRESQL_VERSION} \
 && make all install 

#GIS dependencies
RUN add-apt-repository -y ppa:cartodb/gis \
 && apt-get update \
 && apt-get -y install gdal-bin libgdal-dev \
 && apt-get -y install postgis \
 && rm -rf /var/lib/apt/lists/*

RUN service postgresql start \
 && createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis \
 && psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;' \
 && ldconfig \
# && cd /opt/cartodb-postgresql \
# && PGUSER=postgres make installcheck \
 && /etc/init.d/postgresql stop

# Install Ruby
RUN apt-add-repository ppa:brightbox/ruby-ng \
 && apt-get update \
 && apt-get -y install ruby2.2 ruby2.2-dev ruby-bundler \
 && rm -rf /var/lib/apt/lists/*

# Installing other extensions
RUN cd /opt \
 && git clone https://github.com/CartoDB/dataservices-api.git \
 && cd /opt/dataservices-api/client \
 && make install \
 && cd  /opt/dataservices-api/server/extension \
 && make install 

# Backup Database
RUN mkdir /opt/db_bootstrap \
 && mv /var/lib/postgresql/10 /opt/db_bootstrap/

RUN cd /opt \
 && git clone https://github.com/CartoDB/odbc_fdw \
 && cd /opt/odbc_fdw \
 && make install
ADD startup.sh /opt/startup.sh

EXPOSE 5432 
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
USER 106

CMD ["/bin/bash", "/opt/startup.sh"]
