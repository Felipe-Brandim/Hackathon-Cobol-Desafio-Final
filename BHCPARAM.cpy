      * Layout da area de parametros de validacao - Injetado via COPY
       01 PM-AREA-VALIDACAO.
          05 PM-TRA-ID          PIC 9(006).
          05 PM-CLI-CD          PIC 9(005).
          05 PM-TRA-TP          PIC X(001).
          05 PM-TRA-VLR         PIC 9(009)V99.
          05 PM-CLI-ENCONTRADO  PIC X(001).
             88 PM-CLI-ACHADO                 VALUE 'S'.
             88 PM-CLI-NFOUND                 VALUE 'N'.
          05 PM-CLI-ST          PIC X(001).
          05 PM-CLI-SDO         PIC 9(009)V99.
          05 PM-RET-CD          PIC X(002).
          05 PM-RET-MSG         PIC X(060).