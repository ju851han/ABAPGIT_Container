CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
     BEGIN OF order_status,
          open TYPE c LENGTH 1 VALUE 'O', "Open
          finished TYPE c LENGTH 1 Value 'X', "Finished
     END OF order_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Order~recalcTotalPrice.

    METHODS setDropOffDate FOR MODIFY
      IMPORTING keys FOR ACTION Order~setDropOffDate RESULT result.

*    METHODS setInitialStatus FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Order~setInitialStatus.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~calculateOrderID.

    METHODS setStatusFinished FOR MODIFY
      IMPORTING keys FOR ACTION Order~setStatusFinished RESULT result.

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
*   TODO  call setStatusFinished.
  ENDMETHOD.

*  METHOD setInitialStatus.
*    " Read relevant travel instance data
*    READ ENTITIES OF zi_order_m IN LOCAL MODE
*      ENTITY Order
*        FIELDS ( OrderStatus ) WITH CORRESPONDING #( keys )
*      RESULT DATA(orders).
*
*    " Remove all travel instance data with defined status
*    DELETE orders WHERE TravelStatus IS NOT INITIAL.
*    CHECK orders IS NOT INITIAL.
*
*    " Set default travel status
*    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
*    ENTITY Order
*      UPDATE
*        FIELDS ( OrderStatus )
*        WITH VALUE #( FOR travel IN travels
*                      ( %tky         = travel-%tky
*                        TravelStatus = travel_status-open ) )
*    REPORTED DATA(update_reported).
*
*    reported = CORRESPONDING #( DEEP update_reported ).
*  ENDMETHOD.

  METHOD calculateOrderID.
   " check if OrderID is already filled
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( OrderID ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    " remove lines where OrderID is already filled.
    DELETE orders WHERE OrderID IS NOT INITIAL.

    " anything left ?
    CHECK orders IS NOT INITIAL.

    " Select max order ID
    SELECT SINGLE
        FROM  zat_order
        FIELDS MAX( order_id ) AS orderID
        INTO @DATA(max_orderid).

    " Set the order ID
    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
    ENTITY Order
      UPDATE
        FROM VALUE #( FOR order IN orders INDEX INTO i (
          %tky              = order-%tky
          OrderID          = max_orderid + i
          %control-orderID = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setStatusFinished.
   " Set the new overall status
    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
         UPDATE
           FIELDS ( status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             status       = order_status-finished ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).
  ENDMETHOD.
ENDCLASS.
