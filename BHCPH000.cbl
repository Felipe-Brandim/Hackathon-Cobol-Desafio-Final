******************************************************************
      * SIGLA.....: BHC BOOTCAMP HACKATHON COBOL
      * PROGRAMA..: BHCPH000
      * ANALISTA..: HILARIO
      * AUTOR.....: FELIPE FERNANDES BRANDIM
      * DATA......: 05/07/2026
      * OBJETIVO..: GERADOR DE MASSA FINANCE CORE
      * EXECUCAO..: COBOL BATCH
      * ----------------------------------------------------------------
      * VRS DATA     RESPONSAVEL     DESCRICAO DA VERSAO
      * --- -------- --------------- ----------------------------------
      * 001 05.07.26 FELIPE BRANDIM  IMPLANTACAO COM INDENTACAO CORRETA
      ******************************************************************
 
      ******************************************************************
       IDENTIFICATION DIVISION.
      ******************************************************************
       PROGRAM-ID. BHCPH000.
 
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
           SELECT FD-ARQ-CLI ASSIGN     TO "BHCFHCLI.txt"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-CLI.

           SELECT FD-ARQ-TRA ASSIGN     TO "BHCFHTRA.txt"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS                  IS FS-TRA.
 
      ******************************************************************
       DATA DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       FILE                                   SECTION.
      *-----------------------------------------------------------------
       FD  FD-ARQ-CLI
           RECORDING MODE IS F
           RECORD CONTAINS 58 CHARACTERS.
       01 BHCFHCLI-REG       PIC X(058).

       FD  FD-ARQ-TRA
           RECORDING MODE IS F
           RECORD CONTAINS 31 CHARACTERS.
       01 BHCFHTRA-REG       PIC X(031).
 
      *----------------------------------------
       WORKING-STORAGE                 SECTION.
      *----------------------------------------
       01 WS-CONSTANTES.
          05 WS-FS-OK        PIC X(002) VALUE '00'.

      *----------------------------------------
       LOCAL-STORAGE                   SECTION.
      *----------------------------------------
           COPY BHCCLIEN.
           COPY BHCTRAXX.

       01 WS-FILE-STATUS.
          05 FS-CLI          PIC X(002) VALUE SPACES.
          05 FS-TRA          PIC X(002) VALUE SPACES.

       01 GDA-CONTROLES.
          05 IDX             PIC 9(002) VALUE ZEROS.

       01 WS-TOTALIZADORES.
          05 WS-TOT-CLI-GRV  PIC 9(005) VALUE ZEROS.
          05 WS-TOT-TRA-GRV  PIC 9(005) VALUE ZEROS.
 
******************************************************************
       PROCEDURE DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       000000-ROTINA-PRINCIPAL SECTION.
      *-----------------------------------------------------------------
       000000-MAIN.
           PERFORM 100000-INICIALIZAR
           PERFORM 200000-ABRIR-ARQUIVOS
           PERFORM 300000-GERAR-CLIENTES
           PERFORM 400000-GERAR-TRANSACOES
           PERFORM 900000-FECHAR-ARQUIVOS
           PERFORM 910000-EXIBIR-TOTALIZADORES
           
      *    FIX: GOBACK condicional para limpar o "Unreachable Code"
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
           MOVE ZEROS TO WS-TOT-CLI-GRV
                         WS-TOT-TRA-GRV
           DISPLAY '**************************************************'
           DISPLAY '* PROGRAMA..: BHCPH000'
           DISPLAY '* OBJETIVO..: GERADOR DE MASSA FINANCE CORE'
           DISPLAY '**************************************************'
           .
       100000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       200000-ABRIR-ARQUIVOS SECTION.
      *-----------------------------------------------------------------
       200000-PROC.
           OPEN OUTPUT FD-ARQ-CLI
           IF FS-CLI NOT = WS-FS-OK THEN
              DISPLAY 'ERRO AO ABRIR BHCFHCLI: ' FS-CLI
              GOBACK
           END-IF

           OPEN OUTPUT FD-ARQ-TRA
           IF FS-TRA NOT = WS-FS-OK THEN
              DISPLAY 'ERRO AO ABRIR BHCFHTRA: ' FS-TRA
              GOBACK
           END-IF
           .
       200000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       300000-GERAR-CLIENTES SECTION.
      *-----------------------------------------------------------------
       300000-PROC.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 20
                   EVALUATE IDX
                   WHEN 1
                        MOVE 00001 TO FD-CLI-CD
                        MOVE "JOAO SILVA" TO FD-CLI-NM
                        MOVE 12345678901 TO FD-CLI-CPF
                        MOVE 00000150000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 2
                        MOVE 00002 TO FD-CLI-CD
                        MOVE "MARIA SOUZA" TO FD-CLI-NM
                        MOVE 23456789012 TO FD-CLI-CPF
                        MOVE 00000087550 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 3
                        MOVE 00003 TO FD-CLI-CD
                        MOVE "CARLOS LIMA" TO FD-CLI-NM
                        MOVE 34567890123 TO FD-CLI-CPF
                        MOVE 00000005000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 4
                        MOVE 00004 TO FD-CLI-CD
                        MOVE "ANA PEREIRA" TO FD-CLI-NM
                        MOVE 45678901234 TO FD-CLI-CPF
                        MOVE 00000250000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 5
                        MOVE 00005 TO FD-CLI-CD
                        MOVE "PAULO SANTOS" TO FD-CLI-NM
                        MOVE 56789012345 TO FD-CLI-CPF
                        MOVE 00000000000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 6
                        MOVE 00006 TO FD-CLI-CD
                        MOVE "FERNANDA COSTA" TO FD-CLI-NM
                        MOVE 67890123456 TO FD-CLI-CPF
                        MOVE 00000032000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 7
                        MOVE 00007 TO FD-CLI-CD
                        MOVE "RICARDO ALMEIDA" TO FD-CLI-NM
                        MOVE 78901234567 TO FD-CLI-CPF
                        MOVE 00000120000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 8
                        MOVE 00008 TO FD-CLI-CD
                        MOVE "JULIANA ROCHA" TO FD-CLI-NM
                        MOVE 89012345678 TO FD-CLI-CPF
                        MOVE 00000065000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 9
                        MOVE 00009 TO FD-CLI-CD
                        MOVE "MARCOS OLIVEIRA" TO FD-CLI-NM
                        MOVE 90123456789 TO FD-CLI-CPF
                        MOVE 00000007500 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 10
                        MOVE 00010 TO FD-CLI-CD
                        MOVE "PATRICIA GOMES" TO FD-CLI-NM
                        MOVE 01234567890 TO FD-CLI-CPF
                        MOVE 00000180000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 11
                        MOVE 00011 TO FD-CLI-CD
                        MOVE "LUCAS MARTINS" TO FD-CLI-NM
                        MOVE 11223344556 TO FD-CLI-CPF
                        MOVE 00000040000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 12
                        MOVE 00012 TO FD-CLI-CD
                        MOVE "CAMILA RIBEIRO" TO FD-CLI-NM
                        MOVE 22334455667 TO FD-CLI-CPF
                        MOVE 00000099000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 13
                        MOVE 00013 TO FD-CLI-CD
                        MOVE "ROBERTO BARBOSA" TO FD-CLI-NM
                        MOVE 33445566778 TO FD-CLI-CPF
                        MOVE 00000003000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 14
                        MOVE 00014 TO FD-CLI-CD
                        MOVE "BEATRIZ MENDES" TO FD-CLI-NM
                        MOVE 44556677889 TO FD-CLI-CPF
                        MOVE 00000145000 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 15
                        MOVE 00015 TO FD-CLI-CD
                        MOVE "GUSTAVO NUNES" TO FD-CLI-NM
                        MOVE 55667788990 TO FD-CLI-CPF
                        MOVE 00000002500 TO FD-CLI-SDO
                        MOVE "A" TO FD-CLI-ST
                   WHEN 16
                        MOVE 00016 TO FD-CLI-CD
                        MOVE "HELENA DIAS" TO FD-CLI-NM
                        MOVE 66778899001 TO FD-CLI-CPF
                        MOVE 00000007000 TO FD-CLI-SDO
                        MOVE "I" TO FD-CLI-ST
                   WHEN 17
                        MOVE 00017 TO FD-CLI-CD
                        MOVE "RAFAEL FREITAS" TO FD-CLI-NM
                        MOVE 77889900112 TO FD-CLI-CPF
                        MOVE 00000110000 TO FD-CLI-SDO
                        MOVE "I" TO FD-CLI-ST
                   WHEN 18
                        MOVE 00018 TO FD-CLI-CD
                        MOVE "LARISSA CAMPOS" TO FD-CLI-NM
                        MOVE 88990011223 TO FD-CLI-CPF
                        MOVE 00000055000 TO FD-CLI-SDO
                        MOVE "I" TO FD-CLI-ST
                   WHEN 19
                        MOVE 00019 TO FD-CLI-CD
                        MOVE "EDUARDO MOREIRA" TO FD-CLI-NM
                        MOVE 99001122334 TO FD-CLI-CPF
                        MOVE 00000200000 TO FD-CLI-SDO
                        MOVE "B" TO FD-CLI-ST
                   WHEN 20
                        MOVE 00020 TO FD-CLI-CD
                        MOVE "TATIANE AZEVEDO" TO FD-CLI-NM
                        MOVE 00112233445 TO FD-CLI-CPF
                        MOVE 00000033000 TO FD-CLI-SDO
                        MOVE "B" TO FD-CLI-ST
                   END-EVALUATE

                   WRITE BHCFHCLI-REG FROM FD-REG-CLI
                   IF FS-CLI = WS-FS-OK THEN
                      ADD 1 TO WS-TOT-CLI-GRV
                   ELSE
                      DISPLAY 'ERRO AO GRAVAR CLIENTE: ' FS-CLI
                   END-IF
           END-PERFORM
           .
       300000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       400000-GERAR-TRANSACOES SECTION.
      *-----------------------------------------------------------------
       400000-PROC.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 40
                   MOVE IDX TO FD-TRA-ID
                   MOVE 20260704 TO FD-TRA-DT
                   EVALUATE IDX
                   WHEN 1
                        MOVE 00001 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000050000 TO FD-TRA-VLR
                   WHEN 2
                        MOVE 00002 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 3
                        MOVE 00003 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000002000 TO FD-TRA-VLR
                   WHEN 4
                        MOVE 00004 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000030000 TO FD-TRA-VLR
                   WHEN 5
                        MOVE 00005 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000002500 TO FD-TRA-VLR
                   WHEN 6
                        MOVE 00006 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 7
                        MOVE 00007 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000050000 TO FD-TRA-VLR
                   WHEN 8
                        MOVE 00008 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000007500 TO FD-TRA-VLR
                   WHEN 9
                        MOVE 00009 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000002500 TO FD-TRA-VLR
                   WHEN 10
                        MOVE 00010 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000020000 TO FD-TRA-VLR
                   WHEN 11
                        MOVE 00011 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 12
                        MOVE 00012 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000000500 TO FD-TRA-VLR
                   WHEN 13
                        MOVE 00013 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000002000 TO FD-TRA-VLR
                   WHEN 14
                        MOVE 00014 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000030000 TO FD-TRA-VLR
                   WHEN 15
                        MOVE 00015 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 16
                        MOVE 00001 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000025000 TO FD-TRA-VLR
                   WHEN 17
                        MOVE 00002 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000040000 TO FD-TRA-VLR
                   WHEN 18
                        MOVE 00003 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 19
                        MOVE 00004 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000050000 TO FD-TRA-VLR
                   WHEN 20
                        MOVE 00005 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000001000 TO FD-TRA-VLR
                   WHEN 21
                        MOVE 99999 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 22
                        MOVE 88888 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000005000 TO FD-TRA-VLR
                   WHEN 23
                        MOVE 77777 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000007500 TO FD-TRA-VLR
                   WHEN 24
                        MOVE 66666 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000020000 TO FD-TRA-VLR
                   WHEN 25
                        MOVE 55555 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000001000 TO FD-TRA-VLR
                   WHEN 26
                        MOVE 00016 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 27
                        MOVE 00017 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000005000 TO FD-TRA-VLR
                   WHEN 28
                        MOVE 00018 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000002500 TO FD-TRA-VLR
                   WHEN 29
                        MOVE 00019 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000050000 TO FD-TRA-VLR
                   WHEN 30
                        MOVE 00020 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 31
                        MOVE 00001 TO FD-TRA-CD-CLI
                        MOVE "X" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 32
                        MOVE 00002 TO FD-TRA-CD-CLI
                        MOVE "Z" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 33
                        MOVE 00003 TO FD-TRA-CD-CLI
                        MOVE "T" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 34
                        MOVE 00004 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000300000 TO FD-TRA-VLR
                   WHEN 35
                        MOVE 00006 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000100000 TO FD-TRA-VLR
                   WHEN 36
                        MOVE 00009 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000010000 TO FD-TRA-VLR
                   WHEN 37
                        MOVE 00013 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000050000 TO FD-TRA-VLR
                   WHEN 38
                        MOVE 00005 TO FD-TRA-CD-CLI
                        MOVE "D" TO FD-TRA-TP
                        MOVE 00000000000 TO FD-TRA-VLR
                   WHEN 39
                        MOVE 00007 TO FD-TRA-CD-CLI
                        MOVE "S" TO FD-TRA-TP
                        MOVE 00000000000 TO FD-TRA-VLR
                   WHEN 40
                        MOVE 00008 TO FD-TRA-CD-CLI
                        MOVE "P" TO FD-TRA-TP
                        MOVE 00000000000 TO FD-TRA-VLR
                   END-EVALUATE

                   WRITE BHCFHTRA-REG FROM FD-REG-TRA
                   IF FS-TRA = WS-FS-OK THEN
                      ADD 1 TO WS-TOT-TRA-GRV
                   ELSE
                      DISPLAY 'ERRO AO GRAVAR TRANSACAO: ' FS-TRA
                   END-IF
           END-PERFORM
           .
       400000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       900000-FECHAR-ARQUIVOS SECTION.
      *-----------------------------------------------------------------
       900000-PROC.
           CLOSE FD-ARQ-CLI FD-ARQ-TRA
           .
       900000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       910000-EXIBIR-TOTALIZADORES SECTION.
      *-----------------------------------------------------------------
       910000-PROC.
           DISPLAY 'TOTAL DE CLIENTES GRAVADOS...: ' WS-TOT-CLI-GRV
           DISPLAY 'TOTAL DE TRANSACOES GRAVADAS.: ' WS-TOT-TRA-GRV
           DISPLAY 'BHCPH000 FIM DO PROCESSAMENTO'
           .
       910000-FIM.
           EXIT.