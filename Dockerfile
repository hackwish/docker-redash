# FROM redash/redash:8.0.2.b37747
FROM redash/redash:10.1.0.b50633

USER root

# Aditional Packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    alien \
    build-essential \
    gcc \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    # python3-pyodbc \
    unixodbc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Dremio driver
ENV ODBC_DREMIO_DRIVER_VERSION=1.5.4.1002
RUN wget "https://download.dremio.com/odbc-driver/${ODBC_DREMIO_DRIVER_VERSION}/dremio-odbc-${ODBC_DREMIO_DRIVER_VERSION}-1.x86_64.rpm" -O /dremio-odbc-${ODBC_DREMIO_DRIVER_VERSION}-1.x86_64.rpm \
&& alien -i --scripts /dremio-odbc-${ODBC_DREMIO_DRIVER_VERSION}-1.x86_64.rpm \
&& rm -f /dremio-odbc-${ODBC_DREMIO_DRIVER_VERSION}-1.x86_64.rpm

COPY drivers/dremio/requirements-dremio.txt /app/
COPY drivers/dremio/dremio.py /app/redash/query_runner/
COPY drivers/dremio/dremio.png /app/client/dist/images/db-logos

# ADD dremio-driver/settings/__init__.py /app/redash/settings
# ADD requirements-core.txt /app/

RUN pip install --upgrade pip
# && pip install -r /app/requirements-core.txt \

RUN pip install -r /app/requirements-dremio.txt

USER redash
ENTRYPOINT ["/app/bin/docker-entrypoint"]
# CMD ["server"]