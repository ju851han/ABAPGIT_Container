@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Order'

define root view entity ZI_ORDER_M
  as select from zat_order as _Order

join zat_customer as _Customer on  _Order.customer_id = _Customer.customer_id

{
  key _Order.order_uuid            as OrderUUID,
      _Order.order_id              as OrderID,
   _Order.customer_id           as CustomerID,
      _Customer.last_name   as CustomerName,
    _Order.container_id          as ContainerID,
      _Order.category              as Category,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      _Order.price_per_t           as PricePerT,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      _Order.total_price           as TotalPrice,
      _Order.currency_code         as CurrencyCode,
      _Order.remarks               as Remarks,
      _Order.status                as Status,
      _Order.delivery_date         as DeliveryDate,
      _Order.delivery_time         as DeliveryTime,
      // 1= Datum ist valide
      case dats_is_valid(_Order.drop_off_date)  when   1 then
      //        cast( drop_off_date as abap.dats)
      dats_add_days(_Order.drop_off_date, 0, 'INITIAL')
      else '' end           as DropOffDate,
      //1 = Zeit ist valide
      case tims_is_valid(_Order.drop_off_time) when 1 then
        cast (_Order.drop_off_time as abap.tims)
      else '' end           as DropOffTime,
      _Order.desired_drop_off_date as DesiredDropOffDate,
      _Order.desired_drop_off_time as DesiredDropOffTime,
      @Semantics.address.city: true
      _Order.dest_city             as DestCity,
      _Order.dest_postal_code      as DestPostalCode,
      _Order.dest_street           as DestStreet,
      _Order.dest_country_code     as DestCountryCode,
      // Admin data
      @Semantics.systemDateTime.createdAt: true
      _Order.created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      _Order.created_by            as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Order.last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      _Order.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Order.last_local_changed_at as LastLocalChangedAt //,

}
