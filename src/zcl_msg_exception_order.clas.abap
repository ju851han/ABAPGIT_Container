CLASS zcl_msg_exception_order DEFINITION
 PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

  CONSTANTS:
      BEGIN OF date_interval,
        msgid TYPE symsgid VALUE 'ZCL_MSG_ORDER',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'DELIVERYDATE',
        attr2 TYPE scx_attrname VALUE 'DESIREDDROPOFFDATE',
        attr3 TYPE scx_attrname VALUE 'ORDERID',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_interval .
    CONSTANTS:
      BEGIN OF begin_date_before_system_date,
        msgid TYPE symsgid VALUE 'ZCL_MSG_ORDER',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'DELIVERYDATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_before_system_date .
    CONSTANTS:
      BEGIN OF customer_unknown,
        msgid TYPE symsgid VALUE 'ZCL_MSG_ORDER',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'CUSTOMERID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_unknown .
    CONSTANTS:
      BEGIN OF agency_unknown,
        msgid TYPE symsgid VALUE 'ZCL_MSG_ORDER',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'CONTAINERID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF agency_unknown .

    METHODS constructor
      IMPORTING
        severity   TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        deliverydate  TYPE d OPTIONAL
        desireddropoffdate    TYPE d OPTIONAL
        orderid   TYPE int1 OPTIONAL
        customerid TYPE int1 OPTIONAL
        containerid   TYPE int1  OPTIONAL
      .

    DATA deliverydate TYPE d READ-ONLY.
    DATA desireddropoffdate TYPE d READ-ONLY.
    DATA orderid TYPE string READ-ONLY.
    DATA customerid TYPE string READ-ONLY.
    DATA containerid TYPE string READ-ONLY.
.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MSG_EXCEPTION_ORDER IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.

    me->deliverydate = deliverydate.
    me->desireddropoffdate = desireddropoffdate.
    me->orderid = orderid.
*    |{ orderid ALPHA = OUT }|.
    me->customerid = customerid.
*     |{ customerid ALPHA = OUT }|.
    me->containerid = containerid.
*    |{ containerid ALPHA = OUT }|.
  ENDMETHOD.
ENDCLASS.
