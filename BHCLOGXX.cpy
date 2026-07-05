      * Layout detalhado do arquivo de log - Injetado via COPY
       01 FD-REG-LOG.
          05 FD-LOG-ID-TRA   PIC 9(006).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-LOG-CD-CLI   PIC 9(005).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-LOG-TP-TRA   PIC X(001).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-LOG-VLR-TRA  PIC 9(009)V99.
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-LOG-CD-ERR   PIC X(002).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-LOG-MSG-ERR  PIC X(060).