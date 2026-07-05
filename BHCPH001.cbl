******************************************************************
      * SIGLA.....: BHC BOOTCAMP HACKATHON COBOL
      * PROGRAMA..: BHCPH001
      * ANALISTA..: HILARIO
      * AUTOR.....: FELIPE FERNANDES BRANDIM
      * DATA......: 05/07/2026
      * OBJETIVO..: SISTEMA FINANCEIRO FINANCE CORE
      * EXECUCAO..: COBOL - BATCH
      * ----------------------------------------------------------------
      * VRS DATA     RESPONSAVEL     DESCRICAO DA VERSAO
      * --- -------- --------------- ----------------------------------
      * 003 05.07.26 FELIPE BRANDIM  HEADER COMPLETO E AJUSTES DE JSON
      ******************************************************************
 
      ******************************************************************
       IDENTIFICATION DIVISION.
      ******************************************************************
       PROGRAM-ID. BHCPH001.
 
      ******************************************************************
       ENVIRONMENT DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       CONFIGURATION                          SECTION.
      *-----------------------------------------------------------------
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
 
      *-----------------------------------------------------------------
       INPUT-OUTPUT                           SECTION.
      *-----------------------------------------------------------------
       FILE-CONTROL.
           SELECT FD-ARQ-CLI ASSIGN     TO 'BHCFHCLI.txt'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-CLI.

           SELECT FD-ARQ-TRA ASSIGN     TO 'BHCFHTRA.txt'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-TRA.

           SELECT FD-ARQ-EXT ASSIGN     TO 'BHCFHEXT.txt'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-EXT.

           SELECT FD-ARQ-LOG ASSIGN     TO 'BHCFHLOG.txt'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-LOG.

           SELECT FD-ARQ-JSN ASSIGN     TO 'BHCFHJSN.json'
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-JSN.
 
      ******************************************************************
       DATA DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       FILE                                   SECTION.
      *-----------------------------------------------------------------
       FD  FD-ARQ-CLI
           RECORDING MODE IS F
           RECORD CONTAINS 58 CHARACTERS.
       01 BHCFHCLI-REG            PIC X(058).

       FD  FD-ARQ-TRA
           RECORDING MODE IS F
           RECORD CONTAINS 31 CHARACTERS.
       01 BHCFHTRA-REG            PIC X(031).

       FD  FD-ARQ-EXT
           RECORDING MODE IS F
           RECORD CONTAINS 59 CHARACTERS.
       01 BHCFHEXT-REG            PIC X(059).

       FD  FD-ARQ-LOG
           RECORDING MODE IS F
           RECORD CONTAINS 91 CHARACTERS.
       01 BHCFHLOG-REG            PIC X(091).

       FD  FD-ARQ-JSN
           RECORDING MODE IS F
           RECORD CONTAINS 200 CHARACTERS.
       01 BHCFHJSN-REG            PIC X(200).
 
      *----------------------------------------
       WORKING-STORAGE                 SECTION.
      *----------------------------------------
       01 WS-CONSTANTES.
          05 WS-FS-OK             PIC X(002)    VALUE '00'.
          05 WS-FS-EOF            PIC X(002)    VALUE '10'.

      *----------------------------------------
       LOCAL-STORAGE                   SECTION.
      *----------------------------------------
           COPY BHCCLIEN.
           COPY BHCTRAXX.
           COPY BHCEXTXX.
           COPY BHCLOGXX.
           COPY BHCPARAM.

       01 WS-TB-CLI.
          05 WS-CLI OCCURS 100 TIMES.
             10 WS-CLI-CD         PIC 9(005).
             10 WS-CLI-NM         PIC X(030).
             10 WS-CLI-CPF        PIC 9(011).
             10 WS-CLI-SDO        PIC 9(009)V99.
             10 WS-CLI-ST         PIC X(001).

       01 WS-FILE-STATUS.
          05 FS-CLI               PIC X(002)    VALUE SPACES.
          05 FS-TRA               PIC X(002)    VALUE SPACES.
          05 FS-EXT               PIC X(002)    VALUE SPACES.
          05 FS-LOG               PIC X(002)    VALUE SPACES.
          05 FS-JSN               PIC X(002)    VALUE SPACES.

       01 GDA-VARIAVEIS-CONTROLE.
          05 GDA-FIM-CLI          PIC X(001)    VALUE 'N'.
             88 GDA-FIM-CLI-SIM                 VALUE 'S'.
          05 GDA-FIM-TRA          PIC X(001)    VALUE 'N'.
             88 GDA-FIM-TRA-SIM                 VALUE 'S'.
          05 IDX                  PIC 9(003)    VALUE ZEROS.
          05 GDA-IDX-CLI          PIC 9(003)    VALUE ZEROS.
          05 GDA-CLI-ACHOU-FLG    PIC X(001)    VALUE 'N'.
          05 GDA-SDO-ANT          PIC 9(009)V99 VALUE ZEROS.
          05 GDA-SDO-ATU          PIC 9(009)V99 VALUE ZEROS.
          05 GDA-ERR-NOME-ARQ     PIC X(008)    VALUE SPACES.
          05 GDA-ERR-OPERACAO     PIC X(010)    VALUE SPACES.
          05 GDA-ERR-STATUS       PIC X(002)    VALUE SPACES.
          05 GDA-ERR-MSG          PIC X(060)    VALUE SPACES.

       01 WS-TOTALIZADORES.
          05 WS-TOT-CLI-LIDOS     PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-TRA-LIDAS     PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-TRA-VALIDAS   PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-TRA-REJ       PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-EXT-GRV       PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-LOG-GRV       PIC 9(005)    VALUE ZEROS.
          05 WS-TOT-JSN-GRV       PIC 9(005)    VALUE ZEROS.

      * Mascaras de edicao para limpar zeros a esquerda no JSON
       01 WS-AUX-JSN.
          05 WS-DISP-SDO          PIC 9(011).
          05 WS-JSN-LIDOS-Z       PIC ZZZZ9.
          05 WS-JSN-TRA-LID-Z     PIC ZZZZ9.
          05 WS-JSN-VALIDAS-Z     PIC ZZZZ9.
          05 WS-JSN-REJ-Z         PIC ZZZZ9.

      * Estrutura de desempacotamento de data e hora do sistema
       01 WS-DATA-HORA-SISTEMA.
          05 WS-DT-ANO            PIC X(004).
          05 WS-DT-MES            PIC X(002).
          05 WS-DT-DIA            PIC X(002).
          05 WS-HR-HORA           PIC X(002).
          05 WS-HR-MIN            PIC X(002).
          05 WS-HR-SEG            PIC X(002).
          05 FILLER               PIC X(009).
       01 WS-HEADER-DATA-HORA     PIC X(023)    VALUE SPACES.
 
      ******************************************************************
       PROCEDURE DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       000000-ROTINA-PRINCIPAL SECTION.
      *-----------------------------------------------------------------
       000000-MAIN.
           PERFORM 100000-INICIALIZAR
           PERFORM 200000-ABRIR-ARQUIVOS
           PERFORM 300000-CARREGAR-CLIENTES
           PERFORM 400000-PROCESSAR-TRANSACOES
           PERFORM 500000-GERAR-JSON
           PERFORM 900000-FECHAR-ARQUIVOS
           PERFORM 910000-EXIBIR-TOTALIZADORES
           
           IF WS-FS-OK = '00' THEN
              GOBACK
           END-IF
           .
       000000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       100000-INICIALIZAR SECTION.
      *-----------------------------------------------------------------
       100000-PROC.
           INITIALIZE WS-TOTALIZADORES
           INITIALIZE WS-TB-CLI
           MOVE 'N' TO GDA-FIM-CLI
           MOVE 'N' TO GDA-FIM-TRA
           
      *    Montagem dinamica do campo de Data/Hora do Desafio
           MOVE FUNCTION CURRENT-DATE TO WS-DATA-HORA-SISTEMA
           STRING WS-DT-DIA DELIMITED BY SIZE
                  '/' DELIMITED BY SIZE
                  WS-DT-MES DELIMITED BY SIZE
                  '/' DELIMITED BY SIZE
                  WS-DT-ANO DELIMITED BY SIZE
                  ' - ' DELIMITED BY SIZE
                  WS-HR-HORA DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-HR-MIN DELIMITED BY SIZE
                  ':' DELIMITED BY SIZE
                  WS-HR-SEG DELIMITED BY SIZE
              INTO WS-HEADER-DATA-HORA

      *    Impressao obrigatoria do Cabecalho na SYSOUT (Secao 39)
           DISPLAY '***************************************************'
           DISPLAY '* SIGLA.....: BHC - BOOTCAMP HACKATHON COBOL'
           DISPLAY '* PROGRAMA..: BHCPH001'
           DISPLAY '* ANALISTA..: HILARIO'
           DISPLAY '* AUTOR.....: FELIPE FERNANDES BRANDIM'
           DISPLAY '* DATA/HORA.: ' WS-HEADER-DATA-HORA
           DISPLAY '* OBJETIVO..: SISTEMA FINANCEIRO - FINANCE CORE'
           DISPLAY '* EXECUCAO..: COBOL - BATCH'
           DISPLAY '***************************************************'
           .
       100000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       200000-ABRIR-ARQUIVOS SECTION.
      *-----------------------------------------------------------------
       200000-PROC.
           MOVE 'BHCFHCLI' TO GDA-ERR-NOME-ARQ
           MOVE 'OPEN INPUT' TO GDA-ERR-OPERACAO
           OPEN INPUT FD-ARQ-CLI
           MOVE FS-CLI TO GDA-ERR-STATUS
           PERFORM 810000-VALIDAR-FS

           MOVE 'BHCFHTRA' TO GDA-ERR-NOME-ARQ
           MOVE 'OPEN INPUT' TO GDA-ERR-OPERACAO
           OPEN INPUT FD-ARQ-TRA
           MOVE FS-TRA TO GDA-ERR-STATUS
           PERFORM 810000-VALIDAR-FS

           MOVE 'BHCFHEXT' TO GDA-ERR-NOME-ARQ
           MOVE 'OPEN OUT' TO GDA-ERR-OPERACAO
           OPEN OUTPUT FD-ARQ-EXT
           MOVE FS-EXT TO GDA-ERR-STATUS
           PERFORM 810000-VALIDAR-FS

           MOVE 'BHCFHLOG' TO GDA-ERR-NOME-ARQ
           MOVE 'OPEN OUT' TO GDA-ERR-OPERACAO
           OPEN OUTPUT FD-ARQ-LOG
           MOVE FS-LOG TO GDA-ERR-STATUS
           PERFORM 810000-VALIDAR-FS

           MOVE 'BHCFHJSN' TO GDA-ERR-NOME-ARQ
           MOVE 'OPEN OUT' TO GDA-ERR-OPERACAO
           OPEN OUTPUT FD-ARQ-JSN
           MOVE FS-JSN TO GDA-ERR-STATUS
           PERFORM 810000-VALIDAR-FS
           .
       200000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       300000-CARREGAR-CLIENTES SECTION.
      *-----------------------------------------------------------------
       300000-PROC.
           PERFORM UNTIL GDA-FIM-CLI-SIM
                   READ FD-ARQ-CLI INTO FD-REG-CLI
                   AT END
                      SET GDA-FIM-CLI-SIM TO TRUE
                   NOT AT END
                       IF FS-CLI = WS-FS-OK THEN
                          ADD 1 TO WS-TOT-CLI-LIDOS
                          MOVE WS-TOT-CLI-LIDOS TO IDX
                          MOVE FD-CLI-CD TO WS-CLI-CD(IDX)
                          MOVE FD-CLI-NM TO WS-CLI-NM(IDX)
                          MOVE FD-CLI-CPF TO WS-CLI-CPF(IDX)
                          MOVE FD-CLI-SDO TO WS-CLI-SDO(IDX)
                          MOVE FD-CLI-ST TO WS-CLI-ST(IDX)
                       ELSE
                          MOVE 'BHCFHCLI' TO GDA-ERR-NOME-ARQ
                          MOVE 'READ' TO GDA-ERR-OPERACAO
                          MOVE FS-CLI TO GDA-ERR-STATUS
                          PERFORM 810000-VALIDAR-FS
                       END-IF
                   END-READ
           END-PERFORM
           .
       300000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       400000-PROCESSAR-TRANSACOES SECTION.
      *-----------------------------------------------------------------
       400000-PROC.
           PERFORM UNTIL GDA-FIM-TRA-SIM
                   READ FD-ARQ-TRA INTO FD-REG-TRA
                   AT END
                      SET GDA-FIM-TRA-SIM TO TRUE
                   NOT AT END
                       IF FS-TRA = WS-FS-OK THEN
                          ADD 1 TO WS-TOT-TRA-LIDAS
                          PERFORM 410000-LOCALIZAR-CLIENTE
                          PERFORM 420000-CHAMAR-MOTOR-REGRAS
                          PERFORM 430000-TRATAR-RETORNO
                       ELSE
                          MOVE 'BHCFHTRA' TO GDA-ERR-NOME-ARQ
                          MOVE 'READ' TO GDA-ERR-OPERACAO
                          MOVE FS-TRA TO GDA-ERR-STATUS
                          PERFORM 810000-VALIDAR-FS
                       END-IF
                   END-READ
           END-PERFORM
           .
       400000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       410000-LOCALIZAR-CLIENTE SECTION.
      *-----------------------------------------------------------------
       410000-PROC.
           MOVE 'N' TO GDA-CLI-ACHOU-FLG
           MOVE ZEROS TO GDA-IDX-CLI
           
           PERFORM VARYING IDX FROM 1 BY 1
              UNTIL IDX > 20 OR GDA-CLI-ACHOU-FLG = 'S'
                   IF WS-CLI-CD(IDX) = FD-TRA-CD-CLI THEN
                      MOVE 'S' TO GDA-CLI-ACHOU-FLG
                      MOVE IDX TO GDA-IDX-CLI
                   END-IF
           END-PERFORM
           .
       410000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       420000-CHAMAR-MOTOR-REGRAS SECTION.
      *-----------------------------------------------------------------
       420000-PROC.
           MOVE FD-TRA-ID TO PM-TRA-ID
           MOVE FD-TRA-CD-CLI TO PM-CLI-CD
           MOVE FD-TRA-TP TO PM-TRA-TP
           MOVE FD-TRA-VLR TO PM-TRA-VLR
           
           IF GDA-CLI-ACHOU-FLG = 'S' THEN
              MOVE 'S' TO PM-CLI-ENCONTRADO
              MOVE WS-CLI-ST(GDA-IDX-CLI) TO PM-CLI-ST
              MOVE WS-CLI-SDO(GDA-IDX-CLI) TO PM-CLI-SDO
           ELSE
              MOVE 'N' TO PM-CLI-ENCONTRADO
              MOVE SPACES TO PM-CLI-ST
              MOVE ZEROS TO PM-CLI-SDO
           END-IF

           CALL 'BHCSH001' USING PM-AREA-VALIDACAO
           .
       420000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       430000-TRATAR-RETORNO SECTION.
      *-----------------------------------------------------------------
       430000-PROC.
           IF PM-RET-CD = "00" THEN
              ADD 1 TO WS-TOT-TRA-VALIDAS
              MOVE WS-CLI-SDO(GDA-IDX-CLI) TO GDA-SDO-ANT
              
              EVALUATE FD-TRA-TP
              WHEN 'D'
                   ADD FD-TRA-VLR TO WS-CLI-SDO(GDA-IDX-CLI)
              WHEN 'S'
              WHEN 'P'
                   SUBTRACT FD-TRA-VLR FROM WS-CLI-SDO(GDA-IDX-CLI)
              END-EVALUATE
              
              MOVE WS-CLI-SDO(GDA-IDX-CLI) TO GDA-SDO-ATU
              PERFORM 440000-GRAVAR-EXTRATO
           ELSE
              ADD 1 TO WS-TOT-TRA-REJ
              PERFORM 450000-GRAVAR-LOG
           END-IF
           .
       430000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       440000-GRAVAR-EXTRATO SECTION.
      *-----------------------------------------------------------------
       440000-PROC.
           MOVE FD-TRA-ID TO FD-EXT-ID-TRA
           MOVE FD-TRA-CD-CLI TO FD-EXT-CD-CLI
           MOVE FD-TRA-TP TO FD-EXT-TP-TRA
           MOVE FD-TRA-VLR TO FD-EXT-VLR-TRA
           MOVE GDA-SDO-ANT TO FD-EXT-SDO-ANT
           MOVE GDA-SDO-ATU TO FD-EXT-SDO-ATU
           MOVE FD-TRA-DT TO FD-EXT-DT-TRA

           WRITE BHCFHEXT-REG FROM FD-REG-EXT
           IF FS-EXT = WS-FS-OK THEN
              ADD 1 TO WS-TOT-EXT-GRV
           ELSE
              MOVE 'BHCFHEXT' TO GDA-ERR-NOME-ARQ
              MOVE 'WRITE' TO GDA-ERR-OPERACAO
              MOVE FS-EXT TO GDA-ERR-STATUS
              PERFORM 810000-VALIDAR-FS
           END-IF
           .
       440000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       450000-GRAVAR-LOG SECTION.
      *-----------------------------------------------------------------
       450000-PROC.
           MOVE FD-TRA-ID TO FD-LOG-ID-TRA
           MOVE FD-TRA-CD-CLI TO FD-LOG-CD-CLI
           MOVE FD-TRA-TP TO FD-LOG-TP-TRA
           MOVE FD-TRA-VLR TO FD-LOG-VLR-TRA
           MOVE PM-RET-CD TO FD-LOG-CD-ERR
           MOVE PM-RET-MSG TO FD-LOG-MSG-ERR

           WRITE BHCFHLOG-REG FROM FD-REG-LOG
           IF FS-LOG = WS-FS-OK THEN
              ADD 1 TO WS-TOT-LOG-GRV
           ELSE
              MOVE 'BHCFHLOG' TO GDA-ERR-NOME-ARQ
              MOVE 'WRITE' TO GDA-ERR-OPERACAO
              MOVE FS-LOG TO GDA-ERR-STATUS
              PERFORM 810000-VALIDAR-FS
           END-IF
           .
       450000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       500000-GERAR-JSON SECTION.
      *-----------------------------------------------------------------
       500000-PROC.
           MOVE '{' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '  "sistema": "FINANCE CORE",' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '  "programa": "BHCPH001",' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '  "totalizadores": {' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

    
           MOVE WS-TOT-CLI-LIDOS TO WS-JSN-LIDOS-Z
           MOVE SPACES TO BHCFHJSN-REG
           STRING '    "clientesLidos": ' DELIMITED BY SIZE
                  FUNCTION TRIM(WS-JSN-LIDOS-Z) DELIMITED BY SIZE
                  ',' DELIMITED BY SIZE
              INTO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE WS-TOT-TRA-LIDAS TO WS-JSN-TRA-LID-Z
           MOVE SPACES TO BHCFHJSN-REG
           STRING '    "transacoesLidas": ' DELIMITED BY SIZE
                  FUNCTION TRIM(WS-JSN-TRA-LID-Z) DELIMITED BY SIZE
                  ',' DELIMITED BY SIZE
              INTO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE WS-TOT-TRA-VALIDAS TO WS-JSN-VALIDAS-Z
           MOVE SPACES TO BHCFHJSN-REG
           STRING '    "transacoesValidas": ' DELIMITED BY SIZE
                  FUNCTION TRIM(WS-JSN-VALIDAS-Z) DELIMITED BY SIZE
                  ',' DELIMITED BY SIZE
              INTO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE WS-TOT-TRA-REJ TO WS-JSN-REJ-Z
           MOVE SPACES TO BHCFHJSN-REG
           STRING '    "transacoesRejeitadas": ' DELIMITED BY SIZE
                  FUNCTION TRIM(WS-JSN-REJ-Z) DELIMITED BY SIZE
              INTO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '  },' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '  "clientes": [' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 20
                   MOVE '    {' TO BHCFHJSN-REG
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV

                   MOVE SPACES TO BHCFHJSN-REG
                   STRING '      "codigo": "' DELIMITED BY SIZE
                          WS-CLI-CD(IDX) DELIMITED BY SIZE
                          '",' DELIMITED BY SIZE
                      INTO BHCFHJSN-REG
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV

                   MOVE SPACES TO BHCFHJSN-REG
                   STRING '      "nome": "' DELIMITED BY SIZE
                          FUNCTION TRIM(WS-CLI-NM(IDX)) DELIMITED BY
                      SIZE
                          '",' DELIMITED BY SIZE
                      INTO BHCFHJSN-REG
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV

      *        FIX: Removido multiplicacao por 100 para cravar as 11 posicoes
                   MOVE WS-CLI-SDO(IDX) TO WS-DISP-SDO
                   MOVE SPACES TO BHCFHJSN-REG
                   STRING '      "saldoFinal": "' DELIMITED BY SIZE
                          WS-DISP-SDO DELIMITED BY SIZE
                          '",' DELIMITED BY SIZE
                      INTO BHCFHJSN-REG
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV

                   MOVE SPACES TO BHCFHJSN-REG
                   STRING '      "status": "' DELIMITED BY SIZE
                          WS-CLI-ST(IDX) DELIMITED BY SIZE
                          '"' DELIMITED BY SIZE
                      INTO BHCFHJSN-REG
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV

                   IF IDX = 20 THEN
                      MOVE '    }' TO BHCFHJSN-REG
                   ELSE
                      MOVE '    },' TO BHCFHJSN-REG
                   END-IF
                   WRITE BHCFHJSN-REG
                   ADD 1 TO WS-TOT-JSN-GRV
           END-PERFORM

           MOVE '  ]' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV

           MOVE '}' TO BHCFHJSN-REG
           WRITE BHCFHJSN-REG
           ADD 1 TO WS-TOT-JSN-GRV
           .
       500000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       800000-TRATAR-ERRO SECTION.
      *-----------------------------------------------------------------
       800000-PROC.
           DISPLAY '=================================================='
           DISPLAY 'ERRO TECNICO DETECTADO NO MAESTRO:'
           DISPLAY 'PROGRAMA...: BHCPH001'
           DISPLAY 'ARQUIVO....: ' GDA-ERR-NOME-ARQ
           DISPLAY 'OPERACAO...: ' GDA-ERR-OPERACAO
           DISPLAY 'FILE STATUS: ' GDA-ERR-STATUS
           DISPLAY 'MENSAGEM...: ' GDA-ERR-MSG
           DISPLAY '=================================================='
           IF WS-FS-OK = '00' THEN
              GOBACK
           END-IF
           .
       800000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       810000-VALIDAR-FS SECTION.
      *-----------------------------------------------------------------
       810000-PROC.
           EVALUATE GDA-ERR-STATUS
           WHEN '00' 
                EXIT PARAGRAPH
           WHEN '10' 
                MOVE 'FIM DE ARQUIVO ALCANCADO' TO GDA-ERR-MSG
           WHEN '35' 
                MOVE 'ARQUIVO NAO ENCONTRADO' TO GDA-ERR-MSG
                PERFORM 800000-TRATAR-ERRO
           WHEN '37' 
                MOVE 'MODO DE ABERTURA INCOMPATIVEL' TO GDA-ERR-MSG
                PERFORM 800000-TRATAR-ERRO
           WHEN '39' 
                MOVE 'ATRIBUTOS DE ARQUIVO INCOMPATIVEIS'
                   TO GDA-ERR-MSG
                PERFORM 800000-TRATAR-ERRO
           WHEN OTHER
                MOVE 'ERRO DESCONHECIDO OU NAO MAPEADO'
                   TO GDA-ERR-MSG
                PERFORM 800000-TRATAR-ERRO
           END-EVALUATE
           .
       810000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       900000-FECHAR-ARQUIVOS SECTION.
      *-----------------------------------------------------------------
       900000-PROC.
           CLOSE FD-ARQ-CLI FD-ARQ-TRA FD-ARQ-EXT FD-ARQ-LOG FD-ARQ-JSN
           .
       900000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       910000-EXIBIR-TOTALIZADORES SECTION.
      *-----------------------------------------------------------------
       910000-PROC.
      *    FIX: Nomenclatura idêntica à Seção 38.2 do gabarito oficial
           DISPLAY 'Total de clientes lidos...............: '
                   WS-TOT-CLI-LIDOS
           DISPLAY 'Total de transações lidas.............: '
                   WS-TOT-TRA-LIDAS
           DISPLAY 'Total de transações válidas...........: '
                   WS-TOT-TRA-VALIDAS
           DISPLAY 'Total de transações rejeitadas........: '
                   WS-TOT-TRA-REJ
           DISPLAY 'Total de registros gravados no extrato: '
                   WS-TOT-EXT-GRV
           DISPLAY 'Total de registros gravados no log....: '
                   WS-TOT-LOG-GRV
           DISPLAY 'Total de linhas gravadas no JSON......: '
                   WS-TOT-JSN-GRV
           DISPLAY 'BHCPH001 - FIM DO PROCESSAMENTO'
           .
       910000-FIM.
           EXIT.