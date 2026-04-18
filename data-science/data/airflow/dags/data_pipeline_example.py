from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.mongo.hooks.mongo import MongoHook
import pandas as pd
import requests

default_args = {
    'owner': 'datareview',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'data_pipeline_example',
    default_args=default_args,
    description='Exemplo de pipeline de dados com múltiplas fontes',
    schedule_interval=timedelta(days=1),
    catchup=False,
    tags=['datareview', 'example'],
)

def extract_data_from_api():
    """Extrai dados de uma API externa"""
    response = requests.get('https://jsonplaceholder.typicode.com/posts')
    data = response.json()
    df = pd.DataFrame(data)
    df.to_csv('/opt/airflow/dags/data/api_data.csv', index=False)
    print(f"Extraídos {len(data)} registros da API")

def transform_data():
    """Transforma os dados extraídos"""
    df = pd.read_csv('/opt/airflow/dags/data/api_data.csv')
    # Exemplo de transformação: converter títulos para maiúsculo
    df['title'] = df['title'].str.upper()
    df['processed_at'] = datetime.now()
    df.to_csv('/opt/airflow/dags/data/transformed_data.csv', index=False)
    print(f"Transformados {len(df)} registros")

def load_to_postgres():
    """Carrega dados no PostgreSQL"""
    df = pd.read_csv('/opt/airflow/dags/data/transformed_data.csv')
    # Aqui seria implementada a lógica de carga no PostgreSQL
    print(f"Pronto para carregar {len(df)} registros no PostgreSQL")

def load_to_mongodb():
    """Carrega dados no MongoDB"""
    df = pd.read_csv('/opt/airflow/dags/data/transformed_data.csv')
    records = df.to_dict('records')

    # Conectar ao MongoDB
    hook = MongoHook(mongo_conn_id='mongodb_default')
    client = hook.get_conn()
    db = client['datareview']
    collection = db['api_data']

    # Inserir dados
    collection.insert_many(records)
    print(f"Inseridos {len(records)} documentos no MongoDB")

# Tarefas
extract_task = PythonOperator(
    task_id='extract_data',
    python_callable=extract_data_from_api,
    dag=dag,
)

transform_task = PythonOperator(
    task_id='transform_data',
    python_callable=transform_data,
    dag=dag,
)

load_postgres_task = PythonOperator(
    task_id='load_to_postgres',
    python_callable=load_to_postgres,
    dag=dag,
)

load_mongo_task = PythonOperator(
    task_id='load_to_mongodb',
    python_callable=load_to_mongodb,
    dag=dag,
)

# Verificação de qualidade dos dados
data_quality_check = BashOperator(
    task_id='data_quality_check',
    bash_command='echo "Verificando qualidade dos dados..." && wc -l /opt/airflow/dags/data/transformed_data.csv',
    dag=dag,
)

# Definir dependências
extract_task >> transform_task >> [load_postgres_task, load_mongo_task] >> data_quality_check