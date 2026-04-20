#!/bin/bash
# Script para corrigir permissões do arquivo acme.json
if [ -f /acme.json ]; then
  chmod 600 /acme.json
  echo "Permissões do acme.json corrigidas para 600"
else
  echo "{}" > /acme.json
  chmod 600 /acme.json
  echo "Arquivo acme.json criado com permissões 600"
fi