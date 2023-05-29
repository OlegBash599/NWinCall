class ZCL_MLT001_HTTP_APOST_MSG definition
  public
  final
  create public .

public section.

  interfaces ZIF_MLT001_HTTP_PROCESSOR .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ts_sys_info
              , sysid TYPE sysysid
              , uname TYPE syuname
              , database TYPE sydbsys
              , oper_sys TYPE syopsys
              , as_abap_release TYPE sysaprl
              , appsrv_date TYPE sydatum
              , appsrv_time TYPE syuzeit
              , appsrv_host TYPE syhost
              , uspres_date TYPE syst_datlo
              , uspres_time TYPE syst_timlo
              , uspres_zone TYPE syst_zonlo
          , END OF ts_sys_info
          .

    DATA mo_srv TYPE REF TO if_http_server.

    METHODS get_nwin_apost_msg_in
      EXPORTING et_msg TYPE zttmlt001_apost_msg.

    METHODS put_msg2asmg_queue
      IMPORTING is_msg_in TYPE zsmlt001_apost_msg.

    METHODS start_queue_parse_n_proc.
    METHODS fill_response.

ENDCLASS.



CLASS ZCL_MLT001_HTTP_APOST_MSG IMPLEMENTATION.


  METHOD fill_response.

    data lv_resp_json TYPE string.

    mo_srv->response->set_content_type( content_type = 'application/json' ).

    CALL METHOD mo_srv->response->set_header_field(
        name  = 'Content-Type'                          "#EC NOTEXT
        value = 'application/json; charset=utf-8' ).

    CALL METHOD mo_srv->response->set_cdata
      EXPORTING
        data = lv_resp_json   " Character data
*       OFFSET = 0    " Offset into character data
*       LENGTH = -1    " Length of character data
      .


  ENDMETHOD.


  METHOD get_nwin_apost_msg_in.
    "    EXPORTING et_msg TYPE zttmlt001_apost_msg.

    DATA cdata_in TYPE string.
    cdata_in = mo_srv->request->get_cdata( ).


    /ui2/cl_json=>deserialize(
    EXPORTING
      json             = cdata_in
*          jsonx            =
       pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
*          assoc_arrays     =
*          assoc_arrays_opt =
*          name_mappings    =
*          conversion_exits =
    CHANGING
      data             = et_msg
  ).

  ENDMETHOD.


  METHOD put_msg2asmg_queue.
    " IMPORTING is_msg_in TYPE zsmlt001_apost_msg.

  ENDMETHOD.


  METHOD start_queue_parse_n_proc.
    DATA lv_qname TYPE trfcqout-qname VALUE  'ZNWINCALL01'.
    DATA lv_rfc_dest TYPE trfcqout-qname VALUE  'NONE'.

    CALL FUNCTION 'TRFC_SET_QUEUE_NAME'
      EXPORTING
        qname = lv_qname.

    IF 1 = 0.
      CALL FUNCTION 'Z_MLT001_MSG_PARSE'
        IN BACKGROUND TASK.
    ENDIF.

    CALL FUNCTION 'Z_MLT001_MSG_PARSE'
      IN BACKGROUND TASK
      DESTINATION lv_rfc_dest.

  ENDMETHOD.


  METHOD zif_mlt001_http_processor~set_in.
    mo_srv = io_srv.
  ENDMETHOD.


  METHOD zif_mlt001_http_processor~sh.

    DATA lt_apost_msg TYPE zttmlt001_apost_msg.

    FIELD-SYMBOLS <fs_apost_msg> TYPE zsmlt001_apost_msg.

    get_nwin_apost_msg_in( IMPORTING et_msg = lt_apost_msg ).

    LOOP AT lt_apost_msg ASSIGNING <fs_apost_msg>.
      put_msg2asmg_queue( <fs_apost_msg> ).
    ENDLOOP.
    start_queue_parse_n_proc(  ).
    fill_response( ).

  ENDMETHOD.
ENDCLASS.
