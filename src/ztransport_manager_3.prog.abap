*&---------------------------------------------------------------------*
*& Report ZTRANSPORT_MANAGER_3
*&---------------------------------------------------------------------*
*&https://help.sap.com/docs/ABAP_PLATFORM/b1c834a22d05483b8a75710743b5ff26/4ec1f117076868b8e10000000a42189e.html
*&https://community.sap.com/t5/application-development-blog-posts/reports-with-cl-salv-table/ba-p/13469111
*&---------------------------------------------------------------------*
REPORT ztransport_manager_3.


DATA: dockingbottom TYPE REF TO cl_gui_docking_container,
        dockingright  TYPE REF TO cl_gui_docking_container,
        alv_bottom    TYPE REF TO cl_gui_alv_grid,
        alv_right     TYPE REF TO cl_gui_alv_grid,
        repid         TYPE syrepid.

  repid = sy-repid.

  CHECK dockingbottom IS INITIAL.

  CREATE OBJECT dockingbottom
    EXPORTING
      repid     = repid
      dynnr     = sy-dynnr
      side      = dockingbottom->dock_at_bottom
      extension = 170.


  CREATE OBJECT alv_bottom
    EXPORTING
      i_parent = dockingbottom.



CALL METHOD cl_cts_language_file_io=>get_directory_listing
  EXPORTING
    im_directory         = '/usr/'
*   im_timeout           = '10'
*   im_file_mask         = SPACE
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


alv_bottom->set_table_for_first_display(  EXPORTING i_structure_name = 'directories'
                                            CHANGING it_outtab        = directories
                                          ).
