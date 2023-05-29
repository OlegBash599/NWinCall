FUNCTION z_mlt001_msg_parse.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_MSG_GUID) TYPE  CHAR32 OPTIONAL
*"     VALUE(IV_MSG_TYPEID) TYPE  TEXT40 OPTIONAL
*"----------------------------------------------------------------------

  NEW zcl_mlt001_msg_parse( iv_msg_guid = iv_msg_guid
                            iv_msg_typeid = iv_msg_typeid )->sh(  ).


ENDFUNCTION.
