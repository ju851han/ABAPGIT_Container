@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Order'

define root view entity ZI_ORDER_M
  as select from zat_order
  //composition of target_data_source_name as _association_name

  /* Associations */
  association [0..*] to ZI_CUSTOMER_M as _Customer  on $projection.CustomerID = _Customer.CustomerID
  association [0..*] to ZI_Container  as _Container on $projection.ContainerID = _Container.ContainerID
  
{
  key order_uuid        as OrderUUID,
      order_id          as OrderID,
      customer_id       as CustomerID,
      container_id      as ContainerID,
      category          as Category,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price_per_t       as PricePerT,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price       as TotalPrice,
      currency_code     as CurrencyCode,
      remarks           as Remarks,
      status            as Status,
      delivery_date     as DeliveryDate,
      delivery_time     as DeliveryTime,
      drop_off_date     as DropOffDate,
      drop_off_time     as DropOffTime,
      @Semantics.address.city: true
      dest_city         as DestCity,
      dest_postal_code  as DestPostalCode,
      @Semantics.address.street: true
      dest_street       as DestStreet,
      dest_country_code as DestCountryCode,
      // Admin data
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at   as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by   as LastChangedBy,

      // Make association public
      _Customer,
      _Container
}
