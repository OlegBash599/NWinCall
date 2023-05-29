class ZCX_MLT001_ERROR definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  data DO_INFORM type ABAP_BOOL .
  data DETAIL type STRING .
  data ERROR_MARK type ABAP_BOOL .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !DO_INFORM type ABAP_BOOL optional
      !DETAIL type STRING optional
      !ERROR_MARK type ABAP_BOOL optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_MLT001_ERROR IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->DO_INFORM = DO_INFORM .
me->DETAIL = DETAIL .
me->ERROR_MARK = ERROR_MARK .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
