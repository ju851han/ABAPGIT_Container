@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'BO (Data Model) View for Order'
define root view entity ZI_ORDER as select from zat_order
//composition of target_data_source_name as _association_name 
{
    key order_uuid as OrderUUID,
    order_id as OrderID,
    customer_id as CustomerId,
    container_id as ContainerId,
    category as Category,
    price_per_t as PricePerT,
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    remarks as Remarks,
    status as Status,
    delivery_date as DeliveryDate,
    drop_off_date as DropOffDate,
    dest_city as DestCity,
    dest_postal_code as DestPostalCode,
    dest_street as DestStreet,
    dest_country_code as DestCountryCode,
    created_at as CreatedAt,
    created_by as CreatedBy,
    last_changed_at as LastChangedAt,
    last_changed_by as LastChangedBy //,
    // Make association public
//    _association_name 
}
