# 🦖 Sistema Financeiro — Finance Core

Backend financeiro corporativo batch desenvolvido em **COBOL** durante o **Bootcamp Hackathon COBOL 2026**. O sistema simula o core bancário de processamento de clientes e movimentações financeiras diárias, aplicando regras estritas de integridade e gerando artefatos modernos de integração.

![Dinossauro COBOL](/stefanini-bootcamp.png)

---

## 🛠️ O Desafio

O objetivo principal consiste em ler uma massa de dados de clientes e transações diárias, carregar os cadastros em tabelas indexadas na memória RAM (`OCCURS`), processar cada transação por meio de um subprograma especialista em regras de negócio, atualizar saldos, registrar logs de erro e exportar os dados consolidados em um formato de integração moderna (JSON manual).

### 📐 Padrões Arquiteturais Aplicados

- **Modularização via Copybooks (`.cpy`)**: Centralização e reutilização dos layouts físicos dos registros na `LOCAL-STORAGE SECTION`.
- **Acoplamento Fraco via Subprograma**: Isolamento completo das regras de negócio no módulo especialista `BHCSH001`, chamado via instrução `CALL` com área de parâmetros dedicada (`BHCPARAM`).
- **Rigor Estético Corporativo**: Alinhamento estrito de seções a partir da coluna 40, gerenciamento visual das divisões e encerramento seguro com ponto solitário cravado na coluna 12.
- **Tratamento de File Status**: Todas as operações de I/O são blindadas por avaliações de status em tempo real, mitigando abendings técnicos.

---

## 🏗️ Estrutura do Projeto

O ecossistema é composto pelos seguintes componentes obrigatórios:

| Artefato           | Tipo               | Descrição                                                                      |
| :----------------- | :----------------- | :----------------------------------------------------------------------------- |
| **`BHCPH000.cbl`** | Programa Principal | Gerador oficial da massa estática de testes (20 clientes / 40 transações).     |
| **`BHCPH001.cbl`** | Programa Principal | O Maestro. Orquestra as leituras, atualiza saldos em memória e gera as saídas. |
| **`BHCSH001.cbl`** | Subprograma        | Motor de Regras de Negócio que avalia a legitimidade de cada transação.        |
| **`BHCPARAM.cpy`** | Copybook           | Área compartilhada de parâmetros para comunicação via `LINKAGE SECTION`.       |
| `BHCCLIEN.cpy`     | Copybook           | Molde de dados do arquivo de Clientes (`BHCFHCLI`).                            |
| `BHCTRAXX.cpy`     | Copybook           | Molde de dados do arquivo de Transações (`BHCFHTRA`).                          |
| `BHCEXTXX.cpy`     | Copybook           | Molde de dados do arquivo de Extrato de Válidas (`BHCFHEXT`).                  |
| `BHCLOGXX.cpy`     | Copybook           | Molde de dados do arquivo de Log de Rejeições (`BHCFHLOG`).                    |

---

## 🚀 Como Executar o Sistema

### 1. Gerar a Massa de Dados Oficial

```bash
cobc -x -o BHCPH000 BHCPH000.cbl
./BHCPH000
```

## Repositório de Exercícios

### Os exercicios COBOL feitos nas etapas anteriores podems ser encontrados no link abaixo:

- https://github.com/Felipe-Brandim/Hackathon-Cobol
