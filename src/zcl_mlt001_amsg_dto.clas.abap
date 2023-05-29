CLASS zcl_mlt001_amsg_dto DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA msr_apost_msg TYPE REF TO ztmlt001_amsg READ-ONLY.
    DATA mvr_msg TYPE REF TO string READ-ONLY.

    METHODS constructor.
    METHODS set_init
      IMPORTING is_apost_msg TYPE ztmlt001_amsg
                iv_msg       TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MLT001_AMSG_DTO IMPLEMENTATION.


  METHOD constructor.

  ENDMETHOD.


  METHOD set_init.
*      IMPORTING is_msg_meta TYPE ZTKNW69_KFKNWIN
*                iv_msg      TYPE string.

    msr_apost_msg = REF #( is_apost_msg ).
    mvr_msg = REF #( iv_msg ).
  ENDMETHOD.
ENDCLASS.
