CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF order_status,
        open     TYPE c LENGTH 1 VALUE 'O', "Open
        finished TYPE c LENGTH 1 VALUE 'X', "Finished
      END OF order_status.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Order~recalcTotalPrice.

    METHODS setDropOffDate FOR MODIFY
      IMPORTING keys FOR ACTION Order~setDropOffDate RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~setInitialStatus.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~calculateOrderID.

    METHODS setStatusFinished FOR MODIFY
      IMPORTING keys FOR ACTION Order~setStatusFinished RESULT result.
    METHODS validateContainer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateContainer.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateDates.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

*  METHOD get_instance_features.
* ENDMETHOD.

  METHOD get_features.
    " Read the order status of the existing order
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders)
      FAILED failed.

    result =
      VALUE #(
        FOR order IN orders
          LET is_open =   COND #( WHEN order-Status = order_status-open
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_finished =   COND #( WHEN order-Status = order_status-finished
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = order-%tky
              %action-setDropOffDate = is_finished
             ) ).
  ENDMETHOD.


  METHOD recalcTotalPrice.
  ENDMETHOD.

  METHOD setDropOffDate.
    DATA(today) = sy-datlo.
    DATA(now) = sy-timlo.

*   Set new Drop Off Date
    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
    ENTITY Order
        UPDATE
            FIELDS (  DropOffDate DropOffTime )
            WITH VALUE #( FOR key IN keys
                            ( %tky          = key-%tky
                              DropOffDate   =  today
                              DropOffTime   = now ) )
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

  METHOD setInitialStatus.
    " Read relevant order instance data
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( status ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    " Remove all order instance data with defined status
    DELETE orders WHERE status IS NOT INITIAL.
    CHECK orders IS NOT INITIAL.

    " Set default order status
    MODIFY ENTITIES OF zi_order_m IN LOCAL MODE
    ENTITY Order
      UPDATE
        FIELDS ( Status )
        WITH VALUE #( FOR order IN orders
                      ( %tky         = order-%tky
                        status = order_status-open ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

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
  METHOD validateContainer.
  " Read relevant order instance data
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( ContainerID ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    DATA containers TYPE SORTED TABLE OF zat_container WITH UNIQUE KEY container_id.

    " Optimization of DB select: extract distinct non-initial agency IDs
    containers = CORRESPONDING #( orders DISCARDING DUPLICATES MAPPING container_id = ContainerID EXCEPT * ).
    DELETE containers WHERE container_id IS INITIAL.

    IF containers IS NOT INITIAL.
      " Check if agency ID exist
      SELECT FROM zat_container FIELDS container_id
        FOR ALL ENTRIES IN @containers
        WHERE container_id = @containers-container_id
        INTO TABLE @DATA(containers_db).
    ENDIF.

    " Raise msg for non existing and initial ContainerID
    LOOP AT orders INTO DATA(order).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky               = order-%tky
                       %state_area        = 'VALIDATE_AGENCY' )
        TO reported-order.

      IF order-ContainerID IS INITIAL OR NOT line_exists( containers_db[ container_id = order-ContainerID ] ).
        APPEND VALUE #( %tky = order-%tky ) TO failed-order.

        APPEND VALUE #( %tky        = order-%tky
                        %state_area = 'VALIDATE_AGENCY'
                        %msg        = NEW zcl_msg_exception_order(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcl_msg_exception_order=>agency_unknown
                                          containerid = order-ContainerID )
                        %element-ContainerID = if_abap_behv=>mk-on )
          TO reported-order.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomer.
   " Read relevant order instance data
    READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( CustomerID ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    DATA customers TYPE SORTED TABLE OF zat_customer WITH UNIQUE KEY customer_id.

    " Optimization of DB select: extract distinct non-initial customer IDs
    customers = CORRESPONDING #( orders DISCARDING DUPLICATES MAPPING customer_id = CustomerID EXCEPT * ).
    DELETE customers WHERE customer_id IS INITIAL.
    IF customers IS NOT INITIAL.
      " Check if customer ID exist
      SELECT FROM zat_customer FIELDS customer_id
        FOR ALL ENTRIES IN @customers
        WHERE customer_id = @customers-customer_id
        INTO TABLE @DATA(customers_db).
    ENDIF.

    " Raise msg for non existing and initial customerID
    LOOP AT orders INTO DATA(order).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = order-%tky
                       %state_area = 'VALIDATE_CUSTOMER' )
        TO reported-order.

      IF order-CustomerID IS INITIAL OR NOT line_exists( customers_db[ customer_id = order-CustomerID ] ).
        APPEND VALUE #(  %tky = order-%tky ) TO failed-order.

        APPEND VALUE #(  %tky        = order-%tky
                         %state_area = 'VALIDATE_CUSTOMER'
                         %msg        = NEW zcl_msg_exception_order(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcl_msg_exception_order=>customer_unknown
                                           customerid = order-CustomerID )
                         %element-CustomerID = if_abap_behv=>mk-on )
          TO reported-order.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.
   READ ENTITIES OF zi_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( OrderID DeliveryDate DropOffDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    LOOP AT orders INTO DATA(order).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = order-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-order.

      IF order-DropOffDate < order-DeliveryDate.
        APPEND VALUE #( %tky = order-%tky ) TO failed-order.
        APPEND VALUE #( %tky               = order-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcl_msg_exception_order(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_msg_exception_order=>date_interval
                                                 deliverydate = order-DeliveryDate
                                                 dropoffdate   = order-DropOffDate
                                                 orderid  = order-OrderID )
                        %element-DeliveryDate = if_abap_behv=>mk-on
                        %element-DropOffDate   = if_abap_behv=>mk-on ) TO reported-order.

      ELSEIF order-DeliveryDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = order-%tky ) TO failed-order.
        APPEND VALUE #( %tky               = order-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcl_msg_exception_order(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_msg_exception_order=>begin_date_before_system_date
*                                                 delivery_date_before_system_date
                                                 deliverydate = order-deliverydate )
                        %element-DeliveryDate = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
