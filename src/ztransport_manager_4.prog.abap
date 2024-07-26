*&---------------------------------------------------------------------*
*& Report ZTRANSPORT_MANAGER_4
*&---------------------------------------------------------------------*
*&You could also check the demo programs in SE38: BCALV_GRID* and F4
*&
*&---------------------------------------------------------------------*
REPORT ztransport_manager_4.

CLASS lcl_directory DEFINITION.

  PUBLIC SECTION.

    TYPES: lt_lvc_t_fcat TYPE lvc_t_fcat.

    METHODS:
      get_directory_data,
      build_fieldcatalogue,
      display_alv.

    DATA: gt_directories TYPE slandirt,
          gt_fcat        TYPE lvc_t_fcat.

ENDCLASS.                    "lcl_sflight DEFINITION



CLASS lcl_directory IMPLEMENTATION.

  METHOD  get_directory_data.

    CALL METHOD cl_cts_language_file_io=>get_directory_listing
      EXPORTING
        im_directory         = '/usr/'
*       im_timeout           = '10'
*       im_file_mask         = SPACE
      IMPORTING
        ex_directory_content = DATA(directories).
*  EXCEPTIONS
*    too_many_read_errors = 1
*    empty_directory_list = 2
*    directory_read_error = 3
*    others               = 4
    .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.

  METHOD build_fieldcatalogue.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'SLANDIRT'
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
  ENDMETHOD.                    "build_fieldcatlog

  METHOD display_alv.
    CALL SCREEN 0100.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.

  DATA: lo_directory     TYPE REF TO lcl_directory,
        lo_container_100 TYPE REF TO cl_gui_custom_container,
        lo_grid          TYPE REF TO cl_gui_alv_grid.

  CREATE OBJECT lo_directory.

  lo_directory->get_directory_data( ).

  CREATE OBJECT lo_grid EXPORTING i_parent = lo_container_100.

  CREATE OBJECT lo_grid
    EXPORTING
      i_parent = lo_container_100.

  lo_directory->build_fieldcatalogue( ).

  CALL METHOD lo_grid->set_table_for_first_display
    CHANGING
      it_outtab                     = lo_directory->gt_directories
      it_fieldcatalog               = lo_directory->gt_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

*  CALL METHOD lo_directory=>build_fieldcatalogue ( ).
lo_directory->display_alv( ).
