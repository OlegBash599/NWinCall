CLASS zcl_mlt001_http_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_extension .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF ts_builtin_proc
             , sel_id TYPE string
             , processor TYPE seoclsname
           , END OF ts_builtin_proc
           , tt_builtin_proc TYPE SORTED TABLE OF ts_builtin_proc
                WITH UNIQUE KEY sel_id
           .


    DATA mt_builtin_proc TYPE tt_builtin_proc.

    DATA mo_srv TYPE REF TO if_http_server .

    METHODS auth_check
      RAISING zcx_mlt001_error.

    METHODS get_url
      RETURNING VALUE(rv_val) TYPE string.

    METHODS response_bad_request
      IMPORTING iv_detail TYPE string.

    METHODS get_processor
      RETURNING VALUE(ro_obj) TYPE REF TO zif_mlt001_http_processor
      RAISING   zcx_mlt001_error.


ENDCLASS.



CLASS ZCL_MLT001_HTTP_HANDLER IMPLEMENTATION.


  METHOD auth_check.

    DATA lv_det TYPE string.

    RETURN.

    lv_det = 'No authorization for service; user ' &&
             cl_abap_syst=>get_user_name( ) &&
             'Ask team support '.

    RAISE EXCEPTION TYPE zcx_mlt001_error
      EXPORTING
        do_inform = abap_false
        detail    = lv_det.
  ENDMETHOD.


  METHOD constructor.

    mt_builtin_proc = VALUE #(
    ( sel_id = 'GET_' processor = 'ZCL_MLT001_HTTP_INDEX' )


    " http://[:server]:[:port]/sap/nwincall/sysinfo?sap-client=[:mandt]
    ( sel_id = 'GET_/sysinfo' processor = 'ZCL_MLT001_HTTP_SYSINFO' )

    ( sel_id = 'POST_' processor = 'ZCL_MLT001_HTTP_INDEX' )
    ( sel_id = 'POST_/asy2nw' processor = 'ZCL_MLT001_HTTP_APOST_MSG' )
    ).


  ENDMETHOD.


  METHOD get_processor.
    "      RETURNING VALUE(ro_obj) TYPE REF TO zif_knw69_http_processor.
    DATA lv_method_in TYPE string.
    DATA lv_url_in TYPE string.
    DATA lv_proc_selector TYPE string.
    DATA lv_proc_cls TYPE seoclsname.
    DATA lv_msg TYPE string VALUE 'No add info'.

    DATA lt_handlers_add TYPE STANDARD TABLE OF ztmlt001_hndl.
    FIELD-SYMBOLS <fs_handlers_add> TYPE ztmlt001_hndl.

    FIELD-SYMBOLS <fs_builtin_proc> TYPE ts_builtin_proc.

    lv_method_in = mo_srv->request->get_method( ).
    lv_url_in = to_lower( val = get_url( ) ).

    lv_proc_selector = lv_method_in && '_' && lv_url_in.

    READ TABLE mt_builtin_proc ASSIGNING <fs_builtin_proc>
      WITH KEY sel_id = lv_proc_selector.
    IF sy-subrc EQ 0.
      lv_proc_cls = <fs_builtin_proc>-processor.
    ELSE.
      SELECT mandt sel_id cls_handler cls_handler_alt alt_is_on
        FROM ztmlt001_hndl
        INTO TABLE lt_handlers_add
        WHERE sel_id = lv_proc_selector.
      READ TABLE lt_handlers_add ASSIGNING <fs_handlers_add> INDEX 1.
      IF sy-subrc EQ 0.
        IF <fs_handlers_add>-alt_is_on EQ abap_false.
          lv_proc_cls = <fs_handlers_add>-cls_handler.
        ELSE.
          lv_proc_cls = <fs_handlers_add>-cls_handler_alt.
        ENDIF.
      ENDIF.
    ENDIF.

    TRY .
        CREATE OBJECT ro_obj TYPE (lv_proc_cls).
      CATCH cx_sy_create_object_error.
        lv_msg = 'Could not create instance for class ' && lv_proc_cls.

      CATCH cx_root.
        lv_msg = 'Error while create instalce for class ' && lv_proc_cls.
    ENDTRY.

    IF ro_obj IS INITIAL.
      RAISE EXCEPTION TYPE zcx_mlt001_error
        EXPORTING
          do_inform = abap_false
          detail    = |No processor for method { lv_method_in } and url { lv_url_in }. add_info: { lv_msg }|.
    ENDIF.

  ENDMETHOD.


  METHOD get_url.
    "returning value(rv_val) type string.
    CONSTANTS c_path_info TYPE string VALUE '~path_info'.   "#EC NOTEXT

    rv_val = mo_srv->request->get_header_field( c_path_info ).
  ENDMETHOD.


  METHOD if_http_extension~handle_request.

    DATA lo_nwincall_http_processor TYPE REF TO zif_mlt001_http_processor.
    DATA lx TYPE REF TO zcx_mlt001_error.

    mo_srv = server.

    TRY.
        auth_check( ).
        lo_nwincall_http_processor = get_processor(  ).
        lo_nwincall_http_processor->set_in( mo_srv ).
        lo_nwincall_http_processor->sh(  ).
      CATCH zcx_mlt001_error INTO lx.
        response_bad_request( lx->detail ).
    ENDTRY.

  ENDMETHOD.


  METHOD response_bad_request.
    " IMPORTING iv_detail TYPE string.

    DATA lv_resp_json TYPE string.

    lv_resp_json =
    '{"msg": ' && '"' && iv_detail && '"' &&
    '"docs_link": "https://github.com/OlegBash599/NWinCall"}'.
    .

    mo_srv->response->set_content_type( content_type = 'application/json' ).

    CALL METHOD mo_srv->response->set_header_field(
        name  = 'Content-Type'                          "#EC NOTEXT
        value = 'application/json; charset=utf-8' ).

    CALL METHOD mo_srv->response->set_status
      EXPORTING
        code   = cl_rest_status_code=>gc_client_error_bad_request
        reason = iv_detail.

  ENDMETHOD.
ENDCLASS.
