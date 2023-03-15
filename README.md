These are the steps to set up airflow on ECS Fargate.

 1. Set up a terraform workspace.
 2. Set up postgres. Airflow uses postgres to store metadata such as DAGs, number of DAG runs, tasks etc
 3. Set up redis. The CeleryExecutor needs a broker to coordinate execution of tasks.
 4. Set up the required environment variables

 envs

    /dev/airflow/AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://air:CeG229yZfvfvbfbUR9ccccXZb4j@dev-db.cdxshmu7gdmb.eu-west-2.rds.amazonaws.com/air  
    /dev/airflow/AIRFLOW__CORE__EXECUTOR: CeleryExecutor  
    /dev/airflow/AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://air:CeG229yZfvfvbfbUR9ccccXZb4j@dev-db.cdxshmu7gdmb.eu-west-2.rds.amazonaws.com/air]
    /dev/airflow/AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://air:CeG229yZfvfvbfbUR9ccccXZb4j@dev-db.cdxshmu7gdmb.eu-west-2.rds.amazonaws.com/airflow
    /dev/airflow/AIRFLOW__CELERY__BROKER_URL: redis://dev-redis.t6dddxbb.ng.0001.euw2.cache.amazonaws.com:6379/0
    /dev/airflow/AIRFLOW__CORE__FERNET_KEY: 46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=  
    /dev/airflow/AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: true  
    /dev/airflow/AIRFLOW__CORE__LOAD_EXAMPLES: false  
    /dev/airflow/AIRFLOW__API__AUTH_BACKENDS: airflow.api.auth.backend.basic_auth  
    /dev/airflow/_PIP_ADDITIONAL_REQUIREMENTS: requests
    /dev/airflow/AIRFLOW__WEBSERVER__SECRET_KEY: hdbcvhduva

 5. Set up an ECS cluster and an ECR repo.
 6. Set up EFS. Airflow tasks need shared storage for things such as logs eg The worker writes logs to EFS which are in turn read by the webserver and displayed on the browser.
 7. Set up the webserver airflow service as an ECS service behind an ALB.
 8. Set up the scheduler airflow service as an ECS service without an ALB. The scheduler tasks should not scale
 9. Set up the worker airflow service as an ECS service without an ALB. Workers can scale based on load.
 10. Log in to one of the tasks using ECS Exec and create users
 
    airflow users create \  
    --username tom \  
    --firstname Tom \  
    --lastname Ford \  
    --role Admin \  
    --email tom@company.com \  
    --password 2SAX63FW4cmtdMrc
    
8. Set up a CICD pipeline so that any changes eg DAG addition are automatically done.
9. Test the sample DAG below

hello-world.py 

    from airflow import DAG
    from airflow.operators.bash_operator import BashOperator
    from datetime import datetime
    
    with DAG(
        "hello-world",
        start_date=datetime(2023, 3, 8),
        schedule_interval="*/5 * * * *",
        catchup=False,
    ) as dag:
        hi = BashOperator(
            task_id='simple_task',
            bash_command='echo "Hello, World!"'
        )
    
        hi 
