#!/bin/sh

cd "$HOME"/eureciclo/airflow/main-airflow/ && git pull --all
cd "$HOME"/eureciclo/datalake-infra/main-datalake-infra/ && git pull --all
cd "$HOME"/eureciclo/datalake-infra/main-datalake-infra/ && git pull --all
cd "$HOME"/eureciclo/databricks-notebooks/main-databricks-notebooks/ && git pull --all
cd "$HOME"/eureciclo/databricks-notebooks/main-databricks-notebooks/ && git pull --all
cd "$HOME"/eureciclo/salesops-dw/main-salesops-dw-DO-NOT-TOUCH/ && git pull --all
cd "$HOME"/eureciclo/utils/main-utils-DO-NOT-TOUCH/ && git pull --all
