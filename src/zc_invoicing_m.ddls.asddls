@AbapCatalog.sqlViewName: 'ZAT_INVOICING'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View for Invoicing'
define view ZC_INVOICING_M
  as select from ZI_ORDER_M
    join         zat_container as _Container on _Container.container_id = ZI_ORDER_M.ContainerID
{
  key OrderUUID,

      CurrencyCode,
      @UI: {
        lineItem:       [ { position: 10, importance: #HIGH } ],
        identification: [ { position: 10, label: 'Order ID' } ] }
      OrderID,
      @UI: {
         lineItem:       [ { position: 11, importance: #HIGH } ],
         identification: [ { position: 11, label: 'Customer ID' } ] }
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_Customer_M', element: 'CustomerID'} }]
      @ObjectModel.text.element: ['CustomerName']
      CustomerID,
      @Semantics.text: true
      CustomerName,
      @UI: {
         lineItem:       [ { position: 20, importance: #HIGH } ],
         identification: [ { position: 20, label: 'Payload' } ] }
      @Semantics.quantity.unitOfMeasure: 'payload_unit_of_measure'
      _Container.max_payload                                                                    as MaxPayload,
      _Container.payload_unit_of_measure,
      @UI: {
         lineItem:       [ { position: 21, importance: #HIGH } ],
         identification: [ { position: 21, label: 'Category' } ] }
      @Semantics.text: true
      Category,
      @UI: {
         lineItem:       [ { position: 22, importance: #HIGH } ],
         identification: [ { position: 22, label: 'CatPrice' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      PricePerT,
      @UI: {
      lineItem:       [ { position: 23, importance: #HIGH } ],
      identification: [ { position: 23, label: 'CatPrice' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      _Container.max_payload *  PricePerT                                                       as CatPrice,
      @UI: {
      lineItem:       [ { position: 30, importance: #MEDIUM } ],
      identification: [ { position: 30, label: 'Delivery Date' } ] }
      @Semantics.businessDate.from: true
      DeliveryDate,
      @UI: {
      lineItem:       [ { position: 31, importance: #MEDIUM }],
      identification: [ { position: 31, label: 'Desired Drop Off Date' } ] }
      @Semantics.businessDate.to: true
      DropOffDate,
      @UI: {
      lineItem:       [ { position: 32, importance: #MEDIUM }],
      identification: [ { position: 32, label: 'Demurrage Days' } ] }
      dats_days_between(DeliveryDate, DropOffDate)                                              as DemurrageDays,
      @UI: {
      lineItem:       [ { position: 33, importance: #MEDIUM }],
      identification: [ { position: 33, label: 'Demurrage Costs' } ] }
      @Semantics.durationInDays: true
       @Semantics.amount.currencyCode: 'CurrencyCode'
      dats_days_between(DeliveryDate, DropOffDate) * 20                                         as DemurrageCosts,
      @UI: {
      lineItem:       [ { position: 40, importance: #MEDIUM }],
      identification: [ { position: 40, label: 'Destination City' } ] }
      @Semantics.address.city: true
      DestCity,
      @UI: {
      lineItem:       [ { position: 41, importance: #MEDIUM }],
      identification: [ { position: 41, label: 'Transport Costs' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'     
      case DestCountryCode
          when 'DE' then 0
          else 100 end                                                                          as Transportcosts,
          
      @UI: {
            lineItem:       [ { position: 42, importance: #MEDIUM }],
            identification: [ { position: 42, label: 'Total Price' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      case DestCountryCode
      when 'DE' then
      _Container.max_payload * PricePerT   +  dats_days_between(DeliveryDate, DropOffDate) * 20 + 0
      else _Container.max_payload * PricePerT   +  dats_days_between(DeliveryDate, DropOffDate) * 20 + 100 end as TotalPrice,

      @UI: {
      lineItem:       [ { position: 50, importance: #LOW }],
      identification: [ { position: 50, label: 'Remarks' } ] }
      Remarks
}
where
  Status = 'X'
