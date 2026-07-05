#!/bin/bash

# Cores para o relatório visual
GREEN='\e[32m'
RED='\e[31m'
BLUE='\e[34m'
CYAN='\e[36m'
NC='\e[0m' # Sem Cor

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}* BHC - ESTEIRA DE TESTES AUTOMATIZADOS (CI/CD)  *${NC}"
echo -e "${BLUE}* SISTEMA: FINANCE CORE                          *${NC}"
echo -e "${BLUE}==================================================${NC}"

# 1. Limpeza de ambiente de execuções anteriores
echo -e "\n${CYAN}[PASSO 1/4] Limpando artefatos antigos...${NC}"
rm -f BHCPH000 BHCPH001 *.txt *.json test_sysout.log

# 2. Compilação e execução do Gerador de Massa (BHCPH000)
echo -e "${CYAN}[PASSO 2/4] Compilando e executando o Gerador de Massa (BHCPH000)...${NC}"
cobc -x -Wno-others -o BHCPH000 BHCPH000.cbl
if [ $? -ne 0 ]; then
    echo -e "${RED}[FALHA] Erro de compilação no BHCPH000!${NC}"
    exit 1
fi
./BHCPH000 > /dev/null

# Validando se os arquivos físicos de entrada foram gerados
if [ ! -f "BHCFHCLI.txt" ] || [ ! -f "BHCFHTRA.txt" ]; then
    echo -e "${RED}[FALHA] Arquivos de massa oficial não foram encontrados!${NC}"
    exit 1
fi

# 3. Compilação e execução do Orquestrador Core (BHCPH001 + BHCSH001)
echo -e "${CYAN}[PASSO 3/4] Compilando e executando o Sistema Core (BHCPH001)...${NC}"
cobc -x -Wno-others -o BHCPH001 BHCPH001.cbl BHCSH001.cbl
if [ $? -ne 0 ]; then
    echo -e "${RED}[FALHA] Erro de compilação no ecossistema BHCPH001!${NC}"
    exit 1
fi

# Executa coletando a SYSOUT em um arquivo de log para análise
./BHCPH001 > test_sysout.log
cat test_sysout.log

# 4. Asserções Automatizadas (O Coração da Suite de Testes)
echo -e "\n${CYAN}[PASSO 4/4] Executando asserções lógicas nas métricas...${NC}"
TEST_PASSED=true

# Extrai os valores reais da SYSOUT para validar contra o esperado matemático
VALIDAS_REAIS=$(grep -i "válidas" test_sysout.log | awk '{print $NF}')
REJEITADAS_REAIS=$(grep -i "rejeitadas" test_sysout.log | awk '{print $NF}')

echo -e "\n--- Relatório de Cobertura ---"

# Asserção 1: Transações Válidas deve ser 18
if [ "$VALIDAS_REAIS" -eq 18 ]; then
    echo -e "  [ASSERÇÃO] Transações Válidas: Esperado [18] | Obtido [$VALIDAS_REAIS] -> ${GREEN}PASS${NC}"
else
    echo -e "  [ASSERÇÃO] Transações Válidas: Esperado [18] | Obtido [$VALIDAS_REAIS] -> ${RED}FAIL${NC}"
    TEST_PASSED=false
fi

# Asserção 2: Transações Rejeitadas deve ser 22
if [ "$REJEITADAS_REAIS" -eq 22 ]; then
    echo -e "  [ASSERÇÃO] Transações Rejeitadas: Esperado [22] | Obtido [$REJEITADAS_REAIS] -> ${GREEN}PASS${NC}"
else
    echo -e "  [ASSERÇÃO] Transações Rejeitadas: Esperado [22] | Obtido [$REJEITADAS_REAIS] -> ${RED}FAIL${NC}"
    TEST_PASSED=false
fi

# Asserção 3: Integridade física do JSON estruturado
if [ -f "BHCFHJSN.json" ] && grep -q '"sistema": "FINANCE CORE"' BHCFHJSN.json; then
    echo -e "  [ASSERÇÃO] Integridade do Artefato JSON: -> ${GREEN}PASS${NC}"
else
    echo -e "  [ASSERÇÃO] Integridade do Artefato JSON: -> ${RED}FAIL${NC}"
    TEST_PASSED=false
fi

# 5. Veredito Final da Suite
echo -e "\n${BLUE}==================================================${NC}"
if [ "$TEST_PASSED" = true ]; then
    echo -e "${GREEN} STATUS DA ESTEIRA: SUCESSO (TODOS OS TESTES PASSARAM) ${NC}"
    echo -e "${BLUE}==================================================${NC}"
    exit 0
else
    echo -e "${RED} STATUS DA ESTEIRA: REJEITADO (DISCREPÂNCIA DETECTADA)  ${NC}"
    echo -e "${BLUE}==================================================${NC}"
    exit 1
fi