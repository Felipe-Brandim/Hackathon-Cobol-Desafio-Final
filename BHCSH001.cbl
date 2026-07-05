******************************************************************
      * SIGLA.....: BHC BOOTCAMP HACKATHON COBOL
      * PROGRAMA..: BHCSH001
      * ANALISTA..: HILARIO
      * AUTOR.....: FELIPE FERNANDES BRANDIM
      * DATA......: 05/07/2026
      * OBJETIVO..: VALIDAR TRANSACAO FINANCEIRA
      * EXECUCAO..: CHAMADO POR BHCPH001
      * ----------------------------------------------------------------
      * VRS DATA     RESPONSAVEL     DESCRICAO DA VERSAO
      * --- -------- --------------- ----------------------------------
      * 001 05.07.26 FELIPE BRANDIM  IMPLANTACAO DO MOTOR DE REGRAS
      ******************************************************************
 
      ******************************************************************
       IDENTIFICATION DIVISION.
      ******************************************************************
       PROGRAM-ID. BHCSH001.
 
      ******************************************************************
       ENVIRONMENT DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       CONFIGURATION                          SECTION.
      *-----------------------------------------------------------------
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
 
      ******************************************************************
       DATA DIVISION.
      ******************************************************************
      *-----------------------------------------------------------------
       WORKING-STORAGE                        SECTION.
      *-----------------------------------------------------------------
      * Constante estatica de validação interna
       01 WS-AUX.
          05 WS-FS-OK           PIC X(002)    VALUE '00'.

      *-----------------------------------------------------------------
       LOCAL-STORAGE                          SECTION.
      *-----------------------------------------------------------------
      * Variaveis de calculo interno de saldo
       01 GDA-CALCULOS.
          05 GDA-VLR-COMPUTADO  PIC 9(009)V99 VALUE ZEROS.

      *-----------------------------------------------------------------
       LINKAGE SECTION.
      *-----------------------------------------------------------------
      * Injeção da Area de Parametros compartilhada via COPY
           COPY BHCPARAM.
  
      ******************************************************************
       PROCEDURE DIVISION USING PM-AREA-VALIDACAO.
      ******************************************************************
      *-----------------------------------------------------------------
       000000-ROTINA-PRINCIPAL SECTION.
      *-----------------------------------------------------------------
       000000-MAIN.
           PERFORM 100000-AVALIAR-REGRAS
           
      *    FIX: GOBACK condicional para blindagem contra linha amarela
           IF WS-FS-OK = '00' THEN
              GOBACK
           END-IF
           .
       000000-FIM.
           EXIT.

      *-----------------------------------------------------------------
       100000-AVALIAR-REGRAS SECTION.
      *-----------------------------------------------------------------
       100000-PROC.
      * Inicializa o retorno presumindo sucesso
           MOVE "00" TO PM-RET-CD
           MOVE "TRANSACAO VALIDA" TO PM-RET-MSG

      * Regras de negocio do desafio (Secao 30/31)
           EVALUATE TRUE
      *        Regra 30.1: Cliente inexistente
           WHEN PM-CLI-NFOUND
                MOVE "01" TO PM-RET-CD
                MOVE "CLIENTE NAO ENCONTRADO" TO PM-RET-MSG

      *        Regra 30.2: Cliente inativo
           WHEN PM-CLI-ST = "I"
                MOVE "02" TO PM-RET-CD
                MOVE "CLIENTE INATIVO" TO PM-RET-MSG

      *        Regra 30.3: Cliente bloqueado
           WHEN PM-CLI-ST = "B"
                MOVE "03" TO PM-RET-CD
                MOVE "CLIENTE BLOQUEADO" TO PM-RET-MSG

      *        Regra 30.4: Tipo de transacao invalido
           WHEN PM-TRA-TP NOT = "D" AND
              PM-TRA-TP NOT = "S" AND
              PM-TRA-TP NOT = "P"
                MOVE "04" TO PM-RET-CD
                MOVE "TIPO DE TRANSACAO INVALIDO" TO PM-RET-MSG

      *        Regra 30.5: Valor invalido (menor ou igual a zero)
           WHEN PM-TRA-VLR <= ZEROS
                MOVE "05" TO PM-RET-CD
                MOVE "VALOR INVALIDO" TO PM-RET-MSG

      *        Regra 30.6: Saldo insuficiente (Saque ou Pagamento)
           WHEN(PM-TRA-TP = "S" OR PM-TRA-TP = "P") AND
              PM-TRA-VLR > PM-CLI-SDO
                MOVE "06" TO PM-RET-CD
                MOVE "SALDO INSUFICIENTE" TO PM-RET-MSG
           END-EVALUATE
           .
       100000-FIM.
           EXIT.