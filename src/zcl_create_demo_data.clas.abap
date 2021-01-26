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
*   define internal tables (itab)
    DATA it_container TYPE TABLE OF zat_container.
    DATA it_order TYPE TABLE OF zat_order.
    DATA it_customer TYPE TABLE OF zat_customer.

*   read current timestamp
    GET TIME STAMP FIELD DATA(zv_tsl).


*   fill internal tables

    TRY.
        it_container = VALUE #(
   ( container_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) container_id = '1' max_payload = '21.67' payload_unit_of_measure = 't' available = 'X'  )
   ( container_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) container_id = '2' max_payload = '25.44' payload_unit_of_measure = 't' available = ''  )
   ( container_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) container_id = '3' max_payload = '26.48' payload_unit_of_measure = 't' available = 'X'  )
   ).


        it_order = VALUE #(
( order_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) order_id = '1' customer_id = '0' container_id = '2' category = 'EARTH&SOIL' price_per_t = '50' total_price = '125' currency_code = 'EUR' remarks = '' dest_city = 'Konstanz'
dest_postal_code = '78462' dest_street = 'Alfred-Wachtel-Straße 8' dest_country_code = 'DE' status = 'X' delivery_date = '20210101' delivery_time = '163000' desired_drop_off_date = '20210101' desired_drop_off_time = '163000' drop_off_date = '20210101'
drop_off_time = '163000' created_at = zv_tsl created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
( order_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) order_id = '2' customer_id = '1' container_id = '1' category = 'WOOD' price_per_t = '100' total_price = '70' currency_code = 'EUR' remarks = '' dest_city = 'Marchegg'
dest_postal_code = '2294' dest_street = 'Heimatland 2' dest_country_code = 'AT' status = 'X' delivery_date = '20210115' delivery_time = '140000' desired_drop_off_date = '20210115' desired_drop_off_time = '140500' drop_off_date = '20210115' drop_off_time
= '140500' created_at = zv_tsl created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
( order_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) order_id = '3' customer_id = '0' container_id = '2' category = 'EARTH&SOIL' price_per_t = '50' total_price = '125' currency_code = 'EUR' remarks = '' dest_city = 'Konstanz'
dest_postal_code = '78462' dest_street = 'Alfred-Wachtel-Straße 8' dest_country_code = 'DE' status = 'O' delivery_date = '20210202' delivery_time = '170000' desired_drop_off_date = '20210202' desired_drop_off_time = '190000' drop_off_date = '20210202'
drop_off_time = '190000' created_at = zv_tsl created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
          ).

        it_customer = VALUE #(
( customer_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) customer_id = '1' first_name = 'Max' last_name = 'Mustermann' company_name = '' city = 'Wien' postal_code = '1010' street = 'Taborstraße 1' country_code = 'AT' created_at = zv_tsl
created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
( customer_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) customer_id = '2' first_name = 'Tobias' last_name = 'Brendgens' company_name = 'HTWG Konstanz' city = 'Konstanz' postal_code = '78462' street = 'Alfred-Wachtel-Straße 8'
country_code = 'DE' created_at = zv_tsl created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
( customer_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ) customer_id = '3' first_name = 'Susanne' last_name = 'Saner' company_name = '' city = 'Basel' postal_code = '4001' street = 'Austraße 3' country_code = 'CH' created_at = zv_tsl
created_by = 'ADMIN' last_changed_at = zv_tsl last_changed_by = 'ADMIN' last_local_changed_at = zv_tsl  )
       ).

      CATCH cx_uuid_error INTO DATA(e_text).
* TODO    MESSAGE e_text->get_text TYPE 'I'.

    ENDTRY.

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zat_container.
    DELETE FROM zat_order.
    DELETE FROM zat_customer.

*   insert the new table entries
    INSERT zat_container FROM TABLE @it_container.
    INSERT zat_order FROM TABLE @it_order.
    INSERT zat_customer FROM TABLE @it_customer.


*   transfer succeeded
    out->write( 'Data inserted successfully!').

  ENDMETHOD.
ENDCLASS.
