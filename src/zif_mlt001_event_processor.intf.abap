interface ZIF_MLT001_EVENT_PROCESSOR
  public .


  methods SH
    importing
      !IS_EV_INFO type ZTMLT001_OBJEVNT
    raising
      ZCX_MLT001_ERROR .
endinterface.
