import os
import shutil
from datetime import datetime
from airflow import DAG
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

DBT_PROJECT_PATH = "/opt/airflow/dbt"
DBT_EXECUTABLE_PATH = shutil.which("dbt") or "/home/airflow/.local/bin/dbt"

profile_config = ProfileConfig(
    profile_name="fmcg_dbt",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="supabase_postgres",
        profile_args={"schema": "public"},
    )
)

fmcg_dbt_dag = DbtDag(
    project_config=ProjectConfig(DBT_PROJECT_PATH),
    operator_args={
        "install_deps": True,
    },
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=DBT_EXECUTABLE_PATH,
    ),
    render_config=RenderConfig(
        emit_datasets=False
    ),
    schedule_interval="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    dag_id="fmcg_dbt_pipeline",
    tags=["dbt", "fmcg"],
)
