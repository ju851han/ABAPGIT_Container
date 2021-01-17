CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.
