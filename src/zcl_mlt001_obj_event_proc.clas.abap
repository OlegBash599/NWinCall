CLASS zcl_mlt001_obj_event_proc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_event_guid TYPE char32 OPTIONAL .
    METHODS sh .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: ts_obj_event TYPE ztmlt001_objevnt.
    TYPES: tt_obj_event TYPE STANDARD TABLE OF ts_obj_event WITH DEFAULT KEY.


    DATA mv_event_id TYPE char32 .
    DATA mt_events_cust TYPE STANDARD TABLE OF ztmlt001_events.

    DATA mc_init_state TYPE char2 VALUE '10'.
    DATA mc_event_processed TYPE char2 VALUE '50'.
    DATA mc_event_error TYPE char2 VALUE '40'.

    METHODS read_events_cust .
    METHODS read_obj_events
      CHANGING ct_obj_events TYPE tt_obj_event.

    METHODS process_events_step
      CHANGING ct_obj_events TYPE tt_obj_event.

    METHODS update_events_state
      CHANGING ct_obj_events TYPE tt_obj_event.

    METHODS get_event_processor
      IMPORTING is_ev_info    TYPE ts_obj_event
      RETURNING VALUE(ro_obj) TYPE REF TO zif_mlt001_event_processor
      RAISING   zcx_mlt001_error.
ENDCLASS.



CLASS ZCL_MLT001_OBJ_EVENT_PROC IMPLEMENTATION.


  METHOD constructor.
    mv_event_id = iv_event_guid.
  ENDMETHOD.


  METHOD get_event_processor.
*      IMPORTING is_ev_info    TYPE ts_obj_event
*      RETURNING VALUE(ro_obj) TYPE REF TO zif_mlt001_event_processor.

    DATA lv_trg_cls TYPE seoclsname.
    FIELD-SYMBOLS <fs_event_cust> TYPE ztmlt001_events.

    READ TABLE mt_events_cust ASSIGNING <fs_event_cust>
        WITH KEY event_type = is_ev_info-event_type
                 event_step = is_ev_info-event_step.
    IF sy-subrc EQ 0.
      TRY.
          IF <fs_event_cust>-alt_is_on EQ abap_false.
            lv_trg_cls = <fs_event_cust>-event_processor.
          ELSE.
            lv_trg_cls = <fs_event_cust>-event_processor_alt.
          ENDIF.

          CREATE OBJECT ro_obj TYPE (lv_trg_cls).
        CATCH cx_root INTO DATA(lx_any).
          RAISE EXCEPTION TYPE zcx_mlt001_error
            EXPORTING
              detail     = |Processor for event { is_ev_info-event_type } { is_ev_info-event_step } is bad|
              error_mark = abap_true.
      ENDTRY.
    ELSE.
      RAISE EXCEPTION TYPE zcx_mlt001_error
        EXPORTING
          detail     = |Processor for event { is_ev_info-event_type } { is_ev_info-event_step } not found|
          error_mark = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD process_events_step.

    DATA lo_ev_processor TYPE REF TO zif_mlt001_event_processor.
    DATA lx_error TYPE REF TO zcx_mlt001_error.


    FIELD-SYMBOLS <fs_obj_event> TYPE ts_obj_event.

    LOOP AT ct_obj_events ASSIGNING <fs_obj_event>.

      TRY.
          lo_ev_processor = get_event_processor( <fs_obj_event> ).
          IF lo_ev_processor IS BOUND.
            lo_ev_processor->sh( <fs_obj_event> ).
            <fs_obj_event>-event_state = mc_event_processed.
          ENDIF.
        CATCH zcx_mlt001_error INTO lx_error.

          IF lx_error->error_mark EQ abap_true.
            <fs_obj_event>-event_state = mc_event_error.
          ENDIF.

      ENDTRY.

      CLEAR lo_ev_processor.
    ENDLOOP.


  ENDMETHOD.


  METHOD read_events_cust.
    " ZTMLT001_EVENTS
    SELECT * FROM
      ztmlt001_events
      INTO TABLE mt_events_cust
      UP TO 100000 ROWS
      ORDER BY PRIMARY KEY
      .
  ENDMETHOD.


  METHOD read_obj_events.
    "READ_OBJ_EVENTS

    DATA lt_rng_event_guid TYPE RANGE OF char32.


    IF mv_event_id IS NOT INITIAL.
      lt_rng_event_guid = VALUE #(
      ( sign = 'I' option = 'EQ' low = mv_event_id )
      ).
    ENDIF.

    CLEAR ct_obj_events.

    SELECT
    mandt event_guid event_type event_step
        param1  param2 param3 param4 param5 event_state crts cru chts chu
   FROM ztmlt001_objevnt
        UP TO 100000 ROWS
        INTO TABLE ct_obj_events
        WHERE event_guid IN lt_rng_event_guid
        AND event_state EQ mc_init_state
        .


  ENDMETHOD.


  METHOD sh.

    DATA lt_obj_events TYPE tt_obj_event.

    read_events_cust( ).

    read_obj_events( CHANGING ct_obj_events = lt_obj_events ).

    IF lt_obj_events IS INITIAL.
      RETURN.
    ENDIF.

    process_events_step( CHANGING ct_obj_events = lt_obj_events ).

    update_events_state( CHANGING ct_obj_events = lt_obj_events ).

  ENDMETHOD.


  METHOD update_events_state.

    DATA lt_objevent_db TYPE STANDARD TABLE OF ztmlt001_objevnt.
    FIELD-SYMBOLS <fs_objevent_db> TYPE ztmlt001_objevnt.
    FIELD-SYMBOLS <fs_obj_event> TYPE ts_obj_event.

    LOOP AT ct_obj_events ASSIGNING <fs_obj_event>
        WHERE event_state NE mc_init_state.
      APPEND INITIAL LINE TO lt_objevent_db ASSIGNING <fs_objevent_db> .
      <fs_objevent_db>-event_guid = <fs_obj_event>-event_guid.
      <fs_objevent_db>-event_state = <fs_obj_event>-event_state.
      GET TIME STAMP FIELD <fs_objevent_db>-chts.
      <fs_objevent_db>-chu = cl_abap_syst=>get_user_name( ).
    ENDLOOP.

    NEW zcl_c8a005_save2db(  )->save2db(
       EXPORTING
        iv_tabname     = 'ZTMLT001_OBJEVNT'
        it_tab_content = lt_objevent_db
        iv_do_commit   = abap_true
        iv_kz          = 'U'
*            iv_dest_none   = abap_false
    ).

  ENDMETHOD.
ENDCLASS.
