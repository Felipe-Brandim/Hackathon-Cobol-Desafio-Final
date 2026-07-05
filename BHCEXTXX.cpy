      * Layout detalhado do arquivo de extrato - Injetado via COPY
       01 FD-REG-EXT.
          05 FD-EXT-ID-TRA   PIC 9(006).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-CD-CLI   PIC 9(005).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-TP-TRA   PIC X(001).
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-VLR-TRA  PIC 9(009)V99.
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-SDO-ANT  PIC 9(009)V99.
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-SDO-ATU  PIC 9(009)V99.
          05 FILLER          PIC X(001)    VALUE ';'.
          05 FD-EXT-DT-TRA   PIC 9(008).