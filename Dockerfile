FROM clkao/postgres-plv8:9.5-1.5

MAINTAINER Vitaly Ostanin <vitaly.ostanin@gmail.com>

ENV JSQUERY_VERSION=ver_1.0.0
ENV JSQUERY_DIR=jsquery-${JSQUERY_VERSION}
ENV JSQUERY_ARCHIVE=${JSQUERY_DIR}.tar.gz
ENV JSQUERY_SHASUM="32039b32b2e426948939958229b8fbb1cf46da93c9086c2451e16c63521bff8e  ${JSQUERY_ARCHIVE}"

RUN buildDependencies="build-essential \
    bison \
    flex \
    ca-certificates \
    curl \
    git-core \
    postgresql-server-dev-$PG_MAJOR" \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${buildDependencies} \
  && mkdir -p /tmp/build \
  && curl -o /tmp/build/jsquery-${JSQUERY_VERSION}.tar.gz -SL "https://github.com/postgrespro/jsquery/archive/${JSQUERY_VERSION}.tar.gz" \
  && cd /tmp/build \
  && echo ${JSQUERY_SHASUM} | sha256sum -c \
  && tar -xzf /tmp/build/${JSQUERY_ARCHIVE} -C /tmp/build/ \
  && cd /tmp/build/${JSQUERY_DIR} \
  && make USE_PGXS=1 install \
  && strip /usr/lib/postgresql/$PG_MAJOR/lib/jsquery.so \
  && cd / \
  && apt-get clean \
  && apt-get remove -y  ${buildDependencies} \
  && apt-get autoremove -y \
  && rm -rf /tmp/build /var/lib/apt/lists/*
