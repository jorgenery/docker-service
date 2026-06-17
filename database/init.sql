-- ========================================
-- SCRIPT: init.sql
-- ========================================
-- Inicializa bancos de dados para diferentes serviços

-- Criar database para Metabase
CREATE DATABASE metabase;
GRANT ALL PRIVILEGES ON DATABASE metabase TO postgres;

-- Criar database para n8n
CREATE DATABASE n8n;
GRANT ALL PRIVILEGES ON DATABASE n8n TO postgres;

-- Criar database para OpenClaw
CREATE DATABASE openclaw;
GRANT ALL PRIVILEGES ON DATABASE openclaw TO postgres;

-- Criar database para Airflow
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES ON DATABASE airflow TO postgres;

-- Criar database para Keycloak
CREATE DATABASE keycloak;
GRANT ALL PRIVILEGES ON DATABASE keycloak TO postgres;

-- Criar database principal
CREATE DATABASE maindb;
GRANT ALL PRIVILEGES ON DATABASE maindb TO postgres;

-- Exibir databases criados
\l
