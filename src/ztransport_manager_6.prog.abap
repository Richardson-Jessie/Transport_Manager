*&---------------------------------------------------------------------*
*& Report ZTRANSPORT_MANAGER_6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTRANSPORT_MANAGER_6.

PARAMETERS: p_check TYPE c,
            p_rad1  RADIOBUTTON GROUP grp1 DEFAULT 'X',
            p_rad2  RADIOBUTTON GROUP grp1,
            p_rad3  RADIOBUTTON GROUP grp1.
SELECTION-SCREEN COMMENT /1(79) comm1.

CLASS lcl_transport_manager_helpers DEFINITION.
  PUBLIC SECTION.
    DATA: gt_fcat TYPE lvc_t_fcat.
    METHODS: build_field_catalogue.
ENDCLASS.

CLASS lcl_transport_manager_helpers IMPLEMENTATION.
  METHOD build_field_catalogue.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'SLANDIR'
      CHANGING
        ct_fieldcat            = gt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

AT SELECTION-SCREEN OUTPUT.

DATA:
  gt_fieldcat      TYPE lvc_t_fcat.

cl_cts_language_file_io=>get_directory_listing(
      EXPORTING
        im_directory         = '/usr/'
      IMPORTING
        ex_directory_content = DATA(directories)
      ) .

BREAK-POINT.

TYPES: BEGIN OF ty_ls_output,
         line TYPE string,
       END OF ty_ls_output.

DATA: lt_ls_output TYPE TABLE OF ty_ls_output,
      lt_slandirt  TYPE TABLE OF slandirt.

BREAK-POINT.

DATA: dockingbottom TYPE REF TO cl_gui_docking_container,
      alv_bottom    TYPE REF TO cl_gui_alv_grid,
      repid         TYPE syrepid.

repid = sy-repid.

DATA(lo_transport_manager_helpers) = NEW lcl_transport_manager_helpers( ).
lo_transport_manager_helpers->build_field_catalogue( ).
gt_fieldcat = lo_transport_manager_helpers->gt_fcat.

CHECK dockingbottom IS INITIAL.

TRY.
  CREATE OBJECT dockingbottom
    EXPORTING
      repid     = repid
      dynnr     = sy-dynnr
      side      = dockingbottom->dock_at_bottom
      extension = 170.
CATCH cx_root INTO DATA(lx_create).
  MESSAGE lx_create TYPE 'E'.
ENDTRY.

TRY.
  CREATE OBJECT alv_bottom
    EXPORTING
      i_parent = dockingbottom.
CATCH cx_root INTO DATA(lx_create1).
  MESSAGE lx_create1 TYPE 'E'.
ENDTRY.

TRY.
  alv_bottom->set_table_for_first_display(
    EXPORTING
      i_structure_name = 'SLANDIRT'
    CHANGING
      it_fieldcatalog  = gt_fieldcat
      it_outtab        = directories ).
CATCH cx_root INTO DATA(lx_set_table).
  MESSAGE lx_set_table TYPE 'E'.
ENDTRY.
