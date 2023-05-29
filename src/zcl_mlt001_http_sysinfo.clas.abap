CLASS zcl_mlt001_http_sysinfo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mlt001_http_processor .
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

ENDCLASS.



CLASS ZCL_MLT001_HTTP_SYSINFO IMPLEMENTATION.


  METHOD zif_mlt001_http_processor~set_in.
    mo_srv = io_srv.
  ENDMETHOD.


  METHOD zif_mlt001_http_processor~sh.

    DATA ls_sys_info TYPE ts_sys_info.
    DATA lv_resp_json TYPE string.

    ls_sys_info-sysid = sy-sysid.
    ls_sys_info-uname  = sy-uname.
    ls_sys_info-database  = sy-dbsys.
    ls_sys_info-oper_sys  = sy-opsys.
    ls_sys_info-as_abap_release  = sy-saprl.
    ls_sys_info-appsrv_date = sy-datum.
    ls_sys_info-appsrv_time = sy-uzeit.
    ls_sys_info-appsrv_host = sy-host.
    ls_sys_info-uspres_date = sy-datlo.
    ls_sys_info-uspres_time = sy-timlo.
    ls_sys_info-uspres_zone = sy-zonlo.

    /ui2/cl_json=>serialize(
      EXPORTING
        data             = ls_sys_info    " Data to serialize
*        compress         =     " Skip empty elements
*        name             =     " Object name
*        pretty_name      =     " Pretty Print property names
*        type_descr       =     " Data descriptor
*        assoc_arrays     =     " Serialize tables with unique keys as associative array
*        ts_as_iso8601    =     " Dump timestamps as string in ISO8601 format
*        expand_includes  =     " Expand named includes in structures
*        assoc_arrays_opt =     " Optimize rendering of name value maps
*        numc_as_string   =     " Serialize NUMC fields as strings
      RECEIVING
        r_json           = lv_resp_json    " JSON string
    ).


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
ENDCLASS.
