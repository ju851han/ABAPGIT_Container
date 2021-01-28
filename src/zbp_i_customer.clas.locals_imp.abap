CLASS lhc_Customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Customer RESULT result.


    METHODS calculateCustomerID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Customer~calculateCustomerID.

ENDCLASS.

CLASS lhc_Customer IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD calculateCustomerID.
    " check if CustomerID is already filled
    READ ENTITIES OF zi_customer_m IN LOCAL MODE
      ENTITY Customer
        FIELDS ( CustomerID ) WITH CORRESPONDING #( keys )
      RESULT DATA(customers).

    " remove lines where CustomerID is already filled.
    DELETE customers WHERE CustomerID IS NOT INITIAL.

    " anything left ?
    CHECK customers IS NOT INITIAL.

    " Select max customer ID
    SELECT SINGLE
        FROM  zat_customer
        FIELDS MAX( customer_id ) AS customerID
        INTO @DATA(max_customerid).

    " Set the customer ID
    MODIFY ENTITIES OF zi_customer_m IN LOCAL MODE
    ENTITY Customer
      UPDATE
        FROM VALUE #( FOR customer IN customers INDEX INTO i (
          %tky              = customer-%tky
          CustomerID          = max_customerid + i
          %control-customerID = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

ENDCLASS.
