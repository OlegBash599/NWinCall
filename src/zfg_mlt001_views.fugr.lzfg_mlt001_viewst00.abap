*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTMLT001_EVENTS.................................*
DATA:  BEGIN OF STATUS_ZTMLT001_EVENTS               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMLT001_EVENTS               .
CONTROLS: TCTRL_ZTMLT001_EVENTS
            TYPE TABLEVIEW USING SCREEN '4030'.
*...processing: ZTMLT001_HNDL...................................*
DATA:  BEGIN OF STATUS_ZTMLT001_HNDL                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMLT001_HNDL                 .
CONTROLS: TCTRL_ZTMLT001_HNDL
            TYPE TABLEVIEW USING SCREEN '4010'.
*...processing: ZTMLT001_MSGPARS................................*
DATA:  BEGIN OF STATUS_ZTMLT001_MSGPARS              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTMLT001_MSGPARS              .
CONTROLS: TCTRL_ZTMLT001_MSGPARS
            TYPE TABLEVIEW USING SCREEN '4020'.
*.........table declarations:.................................*
TABLES: *ZTMLT001_EVENTS               .
TABLES: *ZTMLT001_HNDL                 .
TABLES: *ZTMLT001_MSGPARS              .
TABLES: ZTMLT001_EVENTS                .
TABLES: ZTMLT001_HNDL                  .
TABLES: ZTMLT001_MSGPARS               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
