FROM apache/airflow:2.4.2

ENV AIRFLOW_HOME=/opt/airflow

COPY --chown=50000:0 dags "${AIRFLOW_HOME}/dags"

USER root
COPY  build/entrypoint "/entrypoint" 
RUN chmod 775 /entrypoint
USER 50000