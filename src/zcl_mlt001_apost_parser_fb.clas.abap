CLASS zcl_mlt001_apost_parser_fb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_mlt001_amsg_parser .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_dto	TYPE REF TO zcl_mlt001_amsg_dto.

ENDCLASS.



CLASS ZCL_MLT001_APOST_PARSER_FB IMPLEMENTATION.


  METHOD zif_mlt001_amsg_parser~set_in.
    mo_dto = io_dto.
  ENDMETHOD.


  METHOD zif_mlt001_amsg_parser~sh.
    "no implementation here as it is fall back
  ENDMETHOD.
ENDCLASS.
