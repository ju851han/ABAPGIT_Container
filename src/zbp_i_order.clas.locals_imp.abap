CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.
    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Order~recalcTotalPrice.

    METHODS setDropOffDate FOR MODIFY
      IMPORTING keys FOR ACTION Order~setDropOffDate RESULT result.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD setDropOffDate.
*    Get Current Date
    DATA: rv_date TYPE d.
    GET TIME STAMP FIELD DATA(zv_tsl).
    CONVERT TIME STAMP zv_tsl TIME ZONE 'utc' INTO DATE rv_date.


*   Set new Drop Off Date
    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
    ENTITY Order
        UPDATE
            FIELDS (  DropOffDate )
            WITH VALUE #( FOR key IN keys
                            ( %tky          = key-%tky
                              DropOffDate   =  rv_date ) )
    FAILED failed
    REPORTED reported.

*   Fill the response table
    READ ENTITIES OF zi_order_m IN LOCAL MODE
        ENTITY Order
            ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                         ( %tky      =   order-%tky
                           %param    =   order ) ).
  ENDMETHOD.

ENDCLASS.
