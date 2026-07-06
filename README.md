# 🦖 Sistema Financeiro — Finance Core

Backend financeiro corporativo batch desenvolvido em **COBOL** durante o **Bootcamp Hackathon COBOL 2026**. O sistema simula o core bancário de processamento de clientes e movimentações financeiras diárias, aplicando regras estritas de integridade e gerando artefatos modernos de integração.

![Dinossauro COBOL](/stefanini-bootcamp.png)

---

## Repositório de Exercícios

### Os exercicios COBOL feitos nas etapas anteriores podem ser encontrados no link abaixo:

- https://github.com/Felipe-Brandim/Hackathon-Cobol

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

## 🧪 Automação & Testes (CI/CD)

Como diferencial técnico e garantia de estabilidade frente a futuras alterações no motor do core financeiro, o projeto conta com uma **Esteira de Testes Automatizada via Shell Script (`run_tests.sh`)** baseada na metodologia _Golden Master Testing_.

O script encarrega-se de:

1. Limpar de forma idempotente o espaço de trabalho.
2. Compilar os fontes suprimindo avisos estéticos não-críticos de quebra de linha do editor (`-Wno-others`).
3. Orquestrar a execução sequencial do gerador e do core.
4. Realizar asserções automatizadas com base no resultado esperado pelo processamento matemático rigoroso da massa oficial de entrada.

> 💡 **Nota de Engenharia sobre a Massa Oficial:**
> O documento de especificação do Hackathon apresenta um JSON de exemplo puramente visual/conceitual com o placar de 25/15. No entanto, o processamento real, estrito e exato das 40 transações diárias oficiais fornecidas sobre as regras de negócio bancárias resulta em **18 transações válidas** e **22 transações rejeitadas** por insuficiência de fundos, bloqueios cadastrais ou status inativos. A suíte de testes valida e garante a precisão deste comportamento numérico real centavo por centavo.

---

## 🚀 Como Executar o Sistema

Escolha uma das duas abordagens abaixo para homologar e rodar o ecossistema batch em seu ambiente Linux/Ubuntu:

### Abordagem A: Execução Totalmente Automatizada (Recomendado)

Esta rota limpa o ambiente, compila todos os módulos com as flags de otimização necessárias e executa as asserções de negócio exibindo um relatório colorido no terminal.

1. **Conceda permissão de execução ao script de teste:**
   ```bash
   chmod +x run_tests.sh
   ```
2. **Depois veja a saída com o comando**
   ```bash
   ./run_tests.sh
   ```

### Abordagem B: Execução Manual Passo a Passo

Caso prefira executar o ecossistema batch manualmente e acompanhar a geração dos arquivos em cada etapa, siga os passos abaixo.

#### Passo 1: Geração da Massa de Dados

1. Compile o programa gerador:

   ```bash
   cobc -x -Wno-others -o BHCPH000 BHCPH000.cbl
   ```

2. Execute o gerador para criar os arquivos de entrada:

   ```bash
   ./BHCPH000
   ```

3. Verifique se os seguintes arquivos foram criados:
   - **BHCFHCLI.txt** — Deve conter **20 registros** de clientes.
   - **BHCFHTRA.txt** — Deve conter **40 registros** de transações.

---

#### Passo 2: Processamento do Core Financeiro

1. Compile o programa principal juntamente com o subprograma de regras de negócio:

   ```bash
   cobc -x -Wno-others -o BHCPH001 BHCPH001.cbl BHCSH001.cbl
   ```

2. Execute o processamento:

   ```bash
   ./BHCPH001
   ```

---

#### Passo 3: Auditoria dos Resultados

Ao final da execução, confirme a geração dos seguintes arquivos:

- **BHCFHEXT.txt**
  - Contém as **18 movimentações financeiras válidas**, incluindo os saldos atualizados.

- **BHCFHLOG.txt**
  - Contém as **22 transações rejeitadas**, acompanhadas de seus respectivos códigos e mensagens de erro.

- **BHCFHJSN.json**
  - Contém os metadados da execução, os totalizadores do processamento e o saldo final consolidado de todos os clientes.
