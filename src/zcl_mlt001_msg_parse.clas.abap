CLASS zcl_mlt001_msg_parse DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_msg_guid   TYPE char32 OPTIONAL
        !iv_msg_typeid TYPE text40 OPTIONAL .
    METHODS sh .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      tt_msgs_in TYPE STANDARD TABLE OF ztmlt001_amsg WITH DEFAULT KEY .

    DATA mc_init_save TYPE char2 VALUE 'A0'.

    DATA mv_msg_guid  TYPE  char32.
    DATA mv_msg_typeid TYPE  text40.

    METHODS get_msg2process
      EXPORTING !et_msgs TYPE tt_msgs_in.
    METHODS msg_parse
      CHANGING !ct_msgs TYPE tt_msgs_in.
    METHODS msg_stat_update
      IMPORTING !it_msgs TYPE tt_msgs_in.
    METHODS get_parser
      IMPORTING
        !io_dto       TYPE REF TO zcl_mlt001_amsg_dto
      RETURNING
        VALUE(ro_obj) TYPE REF TO zif_mlt001_amsg_parser .
ENDCLASS.



CLASS ZCL_MLT001_MSG_PARSE IMPLEMENTATION.


  METHOD constructor.
    mv_msg_guid = iv_msg_guid.
    mv_msg_typeid = iv_msg_typeid.
  ENDMETHOD.


  METHOD get_msg2process.

    DATA lt_rng_msg_guid TYPE RANGE OF char32.
    DATA lt_rng_amsg_typeid TYPE RANGE OF ztmlt001_amsg-msg_typeid.


    IF mv_msg_guid IS NOT INITIAL.
      lt_rng_msg_guid = VALUE #(
      ( sign = 'I' option = 'EQ' low = mv_msg_guid )
      ).
    ENDIF.

    IF mv_msg_typeid IS NOT INITIAL.
      IF mv_msg_typeid CS '*'.
        lt_rng_amsg_typeid = VALUE #( ( sign = 'I' option = 'CP' low = mv_msg_typeid ) ).
      ELSE.
        lt_rng_amsg_typeid = VALUE #( ( sign = 'I' option = 'EQ' low = mv_msg_typeid ) ).
      ENDIF.
    ENDIF.

    SELECT DISTINCT
     msg_guid msg_typeid msg_ts_ext msg_key_ext msg_status crd crt cru cts
      FROM ztmlt001_amsg
        INTO CORRESPONDING FIELDS OF TABLE et_msgs
      UP TO 10000 ROWS
      WHERE msg_status = mc_init_save
       AND msg_guid IN lt_rng_msg_guid
       AND msg_typeid IN lt_rng_amsg_typeid
      .

  ENDMETHOD.


  METHOD get_parser.

    DATA lv_class_name TYPE seoclsname VALUE 'ZCL_MLT001_APOST_PARSER_FB'.

    DATA lt_msg_parsers TYPE STANDARD TABLE OF ztmlt001_msgpars.
    FIELD-SYMBOLS <fs_msg_parser> TYPE ztmlt001_msgpars.


    SELECT mandt parser_id msg_typeid parser_cls is_active alt_is_on parser_cls_alt
      FROM ztmlt001_msgpars
        INTO TABLE lt_msg_parsers
        WHERE msg_typeid =  io_dto->msr_apost_msg->msg_typeid
        .

    LOOP AT lt_msg_parsers ASSIGNING <fs_msg_parser> WHERE is_active = abap_true.
      IF <fs_msg_parser>-alt_is_on EQ abap_false.
        lv_class_name = <fs_msg_parser>-parser_cls.
      ELSE.
        lv_class_name = <fs_msg_parser>-parser_cls_alt.
      ENDIF.
      EXIT.
    ENDLOOP.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    TRY.
        CREATE OBJECT ro_obj TYPE (lv_class_name).
        ro_obj->set_in( io_dto = io_dto ).
      CATCH cx_root.
        lv_class_name = 'ZCL_MLT001_APOST_PARSER_FB'.
        RETRY.
    ENDTRY.

  ENDMETHOD.


  METHOD msg_parse.

    CONSTANTS lc_parsed TYPE zemlt001_msg_status VALUE 'B0'.
    CONSTANTS lc_error TYPE zemlt001_msg_status VALUE 'E0'.
    CONSTANTS lc_no_parser_found TYPE zemlt001_msg_status VALUE 'B1'.
    DATA lv_msg_body TYPE string.
    DATA lo_parser TYPE REF TO zif_mlt001_amsg_parser.
    DATA lo_msg_dto TYPE REF TO zcl_mlt001_amsg_dto.
    FIELD-SYMBOLS <fs_msg_in> TYPE ztmlt001_amsg.


    LOOP AT ct_msgs ASSIGNING <fs_msg_in>.
      CLEAR lv_msg_body.

      IMPORT msg_in_body = lv_msg_body
      FROM DATABASE ztmlt001_amsg(z1)
      ID <fs_msg_in>-msg_guid.

      lo_msg_dto = NEW #(  ).
      lo_msg_dto->set_init( EXPORTING is_apost_msg = <fs_msg_in>
                                      iv_msg      = lv_msg_body ).
      lo_parser = get_parser( lo_msg_dto ).

      IF lo_parser IS BOUND.
        TRY.
            lo_parser->sh( ).
            <fs_msg_in>-msg_status = lc_parsed.
          CATCH zcx_mlt001_error INTO DATA(lx).
            MESSAGE s000(cl) WITH lx->detail INTO sy-msgv4.
            <fs_msg_in>-msg_status = lc_error.
        ENDTRY.
      ELSE.
        <fs_msg_in>-msg_status = lc_no_parser_found.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD msg_stat_update.

    DATA lt_msg_db TYPE STANDARD TABLE OF ztmlt001_amsg.
    FIELD-SYMBOLS <fs_msg> TYPE ztmlt001_amsg.
    FIELD-SYMBOLS <fs_msg_db> TYPE ztmlt001_amsg.

    LOOP AT it_msgs ASSIGNING <fs_msg> WHERE msg_status NE mc_init_save.
      APPEND INITIAL LINE TO lt_msg_db ASSIGNING <fs_msg_db>.
      <fs_msg_db>-client = <fs_msg>-client.
      <fs_msg_db>-msg_guid = <fs_msg>-msg_guid.
      <fs_msg_db>-msg_status = <fs_msg>-msg_status.

      GET TIME STAMP FIELD <fs_msg_db>-cts .

    ENDLOOP.

    IF lt_msg_db IS INITIAL.
      RETURN.
    ENDIF.

    NEW zcl_c8a005_save2db(  )->save2db(
      EXPORTING
        iv_tabname     = 'ZTMLT001_AMSG'
        it_tab_content = lt_msg_db
        iv_do_commit   = abap_true
        iv_kz          = 'U'
*        iv_dest_none   = abap_false
    ).

  ENDMETHOD.


  METHOD sh.
    DATA lt_msgs TYPE tt_msgs_in.

    get_msg2process( IMPORTING et_msgs = lt_msgs ).

    msg_parse( CHANGING ct_msgs = lt_msgs ).

    msg_stat_update( EXPORTING it_msgs = lt_msgs ).

  ENDMETHOD.
ENDCLASS.
