CLASS zcl_delete_demo_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DELETE_DEMO_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zat_container.
    DELETE FROM zat_order.
    DELETE FROM zat_customer.
    DELETE FROM zdt_order.
    DELETE FROM zdt_customer.
    out->write( 'Data deleted successfully!').
  ENDMETHOD.
ENDCLASS.
