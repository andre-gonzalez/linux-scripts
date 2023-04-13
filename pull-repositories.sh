#!/bin/sh

cd "$HOME"/eureciclo/airflow/main-airflow/ && git pull
cd "$HOME"/eureciclo/datalake-infra/main-datalake-infra/ && git pull
cd "$HOME"/eureciclo/datalake-infra/main-datalake-infra/ && git pull
cd "$HOME"/eureciclo/databricks-notebooks/main-databricks-notebooks/ && git pull
cd "$HOME"/eureciclo/databricks-notebooks/main-databricks-notebooks/ && git pull
cd "$HOME"/eureciclo/salesops-dw/main-salesops-dw-DO-NOT-TOUCH/ && git pull
cd "$HOME"/eureciclo/utils/main-utils-DO-NOT-TOUCH/ && git pull
