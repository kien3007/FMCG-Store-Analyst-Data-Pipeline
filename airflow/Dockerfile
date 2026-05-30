FROM apache/airflow:2.9.1

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         git \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow
RUN pip install --no-cache-dir dbt-postgres astronomer-cosmos psycopg2-binary \
    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.9.1/constraints-3.12.txt"
