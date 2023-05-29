INTERFACE zif_mlt001_http_processor
  PUBLIC .


  METHODS set_in
    IMPORTING
      !io_srv TYPE REF TO if_http_server .
  METHODS sh
    RAISING
      zcx_mlt001_error .
ENDINTERFACE.
