FUNCTION z_mlt001_event_proc.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_EVENT_GUID) TYPE  CHAR32 OPTIONAL
*"----------------------------------------------------------------------


  NEW zcl_mlt001_obj_event_proc( iv_event_guid = iv_event_guid )->sh(  ).

ENDFUNCTION.
