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