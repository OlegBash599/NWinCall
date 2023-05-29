class ZCL_MLT001_HTTP_INDEX definition
  public
  final
  create public .

public section.

  interfaces ZIF_MLT001_HTTP_PROCESSOR .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_sys_info
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
          , END OF ts_sys_info .

  data MO_SRV type ref to IF_HTTP_SERVER .

  methods SHOW_INDEX_PAGE .
  methods INFORM_NO_DATA_PROCESS .
  methods HTMP_INDEX_PAGE_AS_LINE
    exporting
      !RV_VAL type STRING .
ENDCLASS.



CLASS ZCL_MLT001_HTTP_INDEX IMPLEMENTATION.


  method HTMP_INDEX_PAGE_AS_LINE.
    " you could update html quikcly in notepad++
    " by replace:
    "    1) \n -> |
    "    2) \r -> | && \r
    "    3) { -> $1 _opbr $2
    "    4) } -> $1 _clbr $2
    "    5) $1 -> {
    "    5) $2 -> }
    "    6) " -> { _dq }
    " check last tag html and remomve | in last line

    data _dq TYPE string VALUE '"'.
    data _opbr TYPE string VALUE '{'.
    data _clbr TYPE string VALUE '}'.

    rv_val =

| <!doctype html> <html> <head> <meta charset='utf-8'>| &&
|    | &&
|    <meta name='viewport' content='width=device-width, initial-scale=1'>| &&
|    <title>Index  page for NetWeaver INcomming Call</title>| &&
|    <style type={ _dq }text/css{ _dq }>| &&
|      /*<![CDATA[*/| &&
|      | &&
|      html { _opbr }| &&
|        height: 100%;| &&
|        width: 100%;| &&
|      { _clbr }  | &&
|        body { _opbr }| &&
|	  background: rgb(60,149,180);| &&
|	  background: -moz-linear-gradient(180deg, rgba(60,110,180,1) 30%, rgba(9, 90, 46, 1) 90%)  ;| &&
|	  background: -webkit-linear-gradient(180deg, rgba(60,110,180,1) 30%, rgba(9, 90, 46, 1) 90%) ;| &&
|	  background: linear-gradient(180deg, rgba(60,110,180,1) 30%, rgba(9, 90, 46, 1) 90%);| &&
|	  background-repeat: no-repeat;| &&
|	  background-attachment: fixed;| &&
|   | &&
|	color: white;| &&
|	font-size: 0.9em;| &&
|	font-weight: 400;| &&
|	font-family: 'Montserrat', sans-serif;| &&
|	margin: 0;| &&
|	padding: 10em 6em 10em 6em;| &&
|	box-sizing: border-box;      | &&
|        | &&
|      { _clbr }| &&
|| &&
|   | &&
|  h1 { _opbr }| &&
|    text-align: center;| &&
|    margin: 0;| &&
|    padding: 0.6em 2em 0.4em;| &&
|    color: #fff;| &&
|    font-weight: bold;| &&
|    font-family: 'Montserrat', sans-serif;| &&
|    font-size: 2em;| &&
|  { _clbr }| &&
|  h1 strong { _opbr }| &&
|    font-weight: bolder;| &&
|    font-family: 'Montserrat', sans-serif;| &&
|  { _clbr }| &&
|  h2 { _opbr }| &&
|    font-size: 1.5em;| &&
|    font-weight:bold;| &&
|  { _clbr }| &&
|  | &&
|  .title { _opbr }| &&
|    border: 1px solid black;| &&
|    font-weight: bold;| &&
|    position: relative;| &&
|    float: right;| &&
|    width: 150px;| &&
|    text-align: center;| &&
|    padding: 10px 0 10px 0;| &&
|    margin-top: 0;| &&
|  { _clbr }| &&
|  | &&
|  .description { _opbr }| &&
|    padding: 45px 10px 5px 10px;| &&
|    clear: right;| &&
|    padding: 15px;| &&
|  { _clbr }| &&
|  | &&
|  .section { _opbr }| &&
|    padding-left: 3%;| &&
|   margin-bottom: 10px;| &&
|  { _clbr }| &&
|  | &&
|  a:hover img { _opbr }| &&
|    padding: 2px;| &&
|    margin: 2px;| &&
|  { _clbr }| &&
|| &&
|  :link { _opbr }| &&
|    color: rgb(199, 252, 77);| &&
|    text-shadow:| &&
|  { _clbr }| &&
|  :visited { _opbr }| &&
|    color: rgb(122, 206, 255);| &&
|  { _clbr }| &&
|  a:hover { _opbr }| &&
|    color: rgb(16, 44, 122);| &&
|  { _clbr }| &&
|  .row { _opbr }| &&
|    width: 100%;| &&
|    padding: 0 10px 0 10px;| &&
|  { _clbr }| &&
|  | &&
|  footer { _opbr }| &&
|    padding-top: 6em;| &&
|    margin-bottom: 6em;| &&
|    text-align: center;| &&
|    font-size: xx-small;| &&
|    overflow:hidden;| &&
|    clear: both;| &&
|  { _clbr }| &&
| | &&
|  .summary { _opbr }| &&
|    font-size: 140%;| &&
|    text-align: center;| &&
|  { _clbr }| &&
|| &&
|  | &&
|  /* Desktop  View Options */| &&
| | &&
|  @media (min-width: 768px)  { _opbr }| &&
|  | &&
|    body { _opbr }| &&
|      padding: 10em 20% !important;| &&
|    { _clbr }| &&
|    | &&
|    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,| &&
|    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 { _opbr }| &&
|      float: left;| &&
|    { _clbr }| &&
|  | &&
|    .col-md-1 { _opbr }| &&
|      width: 8.33%;| &&
|    { _clbr }| &&
|    .col-md-2 { _opbr }| &&
|      width: 16.66%;| &&
|    { _clbr }| &&
|    .col-md-3 { _opbr }| &&
|      width: 25%;| &&
|    { _clbr }| &&
|    .col-md-4 { _opbr }| &&
|      width: 33%;| &&
|    { _clbr }| &&
|    .col-md-5 { _opbr }| &&
|      width: 41.66%;| &&
|    { _clbr }| &&
|    .col-md-6 { _opbr }| &&
|      border-left:3px ;| &&
|      width: 50%;| &&
|      | &&
|| &&
|    { _clbr }| &&
|    .col-md-7 { _opbr }| &&
|      width: 58.33%;| &&
|    { _clbr }| &&
|    .col-md-8 { _opbr }| &&
|      width: 66.66%;| &&
|    { _clbr }| &&
|    .col-md-9 { _opbr }| &&
|      width: 74.99%;| &&
|    { _clbr }| &&
|    .col-md-10 { _opbr }| &&
|      width: 83.33%;| &&
|    { _clbr }| &&
|    .col-md-11 { _opbr }| &&
|      width: 91.66%;| &&
|    { _clbr }| &&
|    .col-md-12 { _opbr }| &&
|      width: 100%;| &&
|    { _clbr }| &&
|  { _clbr }| &&
|  | &&
|  /* Mobile View Options */| &&
|  @media (max-width: 767px) { _opbr }| &&
|    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,| &&
|    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 { _opbr }| &&
|      float: left;| &&
|    { _clbr }| &&
|  | &&
|    .col-sm-1 { _opbr }| &&
|      width: 8.33%;| &&
|    { _clbr }| &&
|    .col-sm-2 { _opbr }| &&
|      width: 16.66%;| &&
|    { _clbr }| &&
|    .col-sm-3 { _opbr }| &&
|      width: 25%;| &&
|    { _clbr }| &&
|    .col-sm-4 { _opbr }| &&
|      width: 33%;| &&
|    { _clbr }| &&
|    .col-sm-5 { _opbr }| &&
|      width: 41.66%;| &&
|    { _clbr }| &&
|    .col-sm-6 { _opbr }| &&
|      width: 50%;| &&
|    { _clbr }| &&
|    .col-sm-7 { _opbr }| &&
|      width: 58.33%;| &&
|    { _clbr }| &&
|    .col-sm-8 { _opbr }| &&
|      width: 66.66%;| &&
|    { _clbr }| &&
|    .col-sm-9 { _opbr }| &&
|      width: 74.99%;| &&
|    { _clbr }| &&
|    .col-sm-10 { _opbr }| &&
|      width: 83.33%;| &&
|    { _clbr }| &&
|    .col-sm-11 { _opbr }| &&
|      width: 91.66%;| &&
|    { _clbr }| &&
|    .col-sm-12 { _opbr }| &&
|      width: 100%;| &&
|    { _clbr }| &&
|    h1 { _opbr }| &&
|      padding: 0 !important;| &&
|    { _clbr }| &&
|  { _clbr }| &&
|  </style>| &&
|  | &&
|  | &&
|  </head>| &&
|  <body>| &&
|    <h1>NetWeaver INcoming Call HTTP interface </h1>| &&
|| &&
|    <div class='row'>| &&
|    | &&
|      <div class='col-sm-12 col-md-6 col-md-6 '></div>| &&
|          <p class={ _dq }summary{ _dq }>If you can| &&
|            read this page, it means that the NWinCall is installed at| &&
|            the system properly and you has proper authorization to use it.</p>| &&
|      </div>| &&
|      | &&
|      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>| &&
|     | &&
|       | &&
|        <div class='section'>| &&
|          <h2>If you are a member of the general public:</h2>| &&
|| &&
|          <p>If you were not intend to view this page | &&
|     contact your support team / helpdesk team.| &&
|     </p>| &&
|   | &&
|| &&
|        <ul>| &&
|          <li>Neither OlegBash or any member co-member of MultiMethods has any| &&
|          affiliation with the system or any data process| &&
|     (unless otherwise explicitly stated).</li>| &&
|| &&
|          <li>Neither OlegBash or any member co-member of MultiMethods has { _dq }hacked{ _dq }| &&
|          this system: this is only the initial page of NWinCall (Net Weaver INcoming Call).</li>| &&
|        </ul>| &&
|        </div>| &&
|      </div>| &&
|      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>| &&
|        <div class='section'>| &&
|         | &&
|          <h2>If you are the developer:</h2>| &&
|| &&
|        <p>All core objects for the development are in package | &&
|   <strong>ZMLT001</strong> (check via tcode <strong>SE21</strong>).</p>| &&
|        <p>Your are able to add on the top of built in function your| &&
|   own processor in table <strong>ZTMLT001_HNDL</strong>.</p>| &&
|| &&
|        <p><strong>Further documentation could be found here| &&
|        <a href={ _dq }https://github.com/OlegBash599/NWinCall{ _dq } target={ _dq }_blank{ _dq }> | &&
|   NWinCall on github</strong></a>:| &&
|        Please keep in mind that you are responsible for your developments in | &&
|   the system you are doing that</p>| &&
|| &&
|        <p>| &&
|     Good Luck! everything will be fine.| &&
|   </p>| &&
|       | &&
|             | &&
|      </div>| &&
|      </div>| &&
|      | &&
|      <footer class={ _dq }col-sm-12{ _dq }>| &&
|      <a href={ _dq }https://github.com/OlegBash599{ _dq } target={ _dq }_blank{ _dq }>| &&
|	  ABAP common application</a> | &&
|	  common application for ABAP by OlegBash.<BR>| &&
|      <a href={ _dq }https://docs.abapgit.org/{ _dq } target={ _dq }_blank{ _dq }>| &&
|	  abapGit</a> Documenation to abap Git.<BR>| &&
|      </footer>| &&
|      | &&
|  </body>| &&
|</html>|
.

  endmethod.


  method INFORM_NO_DATA_PROCESS.

    data lv_resp_json TYPE string.

    lv_resp_json =
    '{"msg": "Only check purposes; no data is processed"' &&
    '"docs_link": "https://github.com/OlegBash599/NWinCall"}'.
    .

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

  endmethod.


  METHOD show_index_page.
    DATA lv_html_info TYPE string.

    htmp_index_page_as_line( IMPORTING rv_val = lv_html_info ).


    mo_srv->response->set_content_type( content_type = 'text/html' ).

    CALL METHOD mo_srv->response->set_header_field(
        name  = 'Content-Type'                          "#EC NOTEXT
        value = 'text/html; charset=utf-8' ).

    CALL METHOD mo_srv->response->set_cdata
      EXPORTING
        data = lv_html_info   " Character data
*       OFFSET = 0    " Offset into character data
*       LENGTH = -1    " Length of character data
      .

  ENDMETHOD.


  METHOD ZIF_MLT001_HTTP_PROCESSOR~SET_IN.
    mo_srv = io_srv.
  ENDMETHOD.


  METHOD ZIF_MLT001_HTTP_PROCESSOR~SH.
    data lv_method_in TYPE string.

    lv_method_in = mo_srv->request->get_method( ).

    CASE lv_method_in.
      WHEN IF_HTTP_ENTITY=>CO_REQUEST_METHOD_GET.
      " WHEN IF_HTTP_ENTITY=>co_request_method_post.
        show_index_page( ).
      WHEN OTHERS.
        " post and others
        inform_no_data_process( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
