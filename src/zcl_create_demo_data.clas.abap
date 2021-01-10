CLASS zcl_create_demo_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_create_demo_data IMPLEMENTATION.

 METHOD if_oo_adt_classrun~main.
*   define tabletypes
    DATA it_container TYPE TABLE OF zat_container.
    DATA it_order TYPE TABLE OF zat_order.
    DATA it_customer TYPE TABLE OF zat_customer.


*   read current timestamp
    GET TIME STAMP FIELD DATA(zv_tsl).

*   fill internal tables (itab) TODO insert values
    it_container = VALUE #(
      ).
         it_order = VALUE #(
      ).
    it_customer = VALUE #(
      ).
*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zat_container.
    DELETE FROM zat_order.
    DELETE FROM zat_customer.

*   insert the new table entries
    INSERT zat_container FROM TABLE @it_container.
    INSERT zat_order FROM TABLE @it_order.
    INSERT zat_customer FROM TABLE @it_customer.


*   check the result
    SELECT * FROM zat_order INTO TABLE @it_order.
    out->write( sy-dbcnt ).
    out->write( 'Data inserted successfully!').

  ENDMETHOD.
ENDCLASS.
