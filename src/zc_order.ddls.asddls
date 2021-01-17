@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection BO View for Order'

@UI:{
headerInfo: {typeName:'Order', typeNamePlural:'Orders', title: { type: #STANDARD, value: 'OrderID'}}}


@Search.searchable: true
// @Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['OrderID']

define root view entity ZC_Order
  as projection on ZI_ORDER as Order
{
      @UI.facet: [{id:       'Order',
                   purpose:  #STANDARD,
                   type:     #IDENTIFICATION_REFERENCE,
                   label:    'Order',
                   position: 10 }]
      @UI.hidden: true
  key OrderUUID,
      @UI: {
      lineItem:       [ { position: 10, importance: #HIGH } ],
      identification: [ { position: 10, label: 'Order ID' } ] }
      @Search.defaultSearchElement: true
      OrderID,
      @UI: {
          lineItem:       [ { position: 11, importance: #HIGH } ],
          identification: [ { position: 11, label: 'Customer ID' } ],
          selectionField: [ { position: 11 } ] }
    @Search.defaultSearchElement: true
      CustomerID,
      @UI: {
          lineItem:       [ { position: 12, importance: #HIGH } ],
          identification: [ { position: 12, label: 'Container ID' } ],
          selectionField: [ { position: 12 } ] }
              @Search.defaultSearchElement: true
      ContainerID,
      @UI: {
          lineItem:       [ { position: 20, importance: #MEDIUM } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
      Category,
      //            @UI: {
      //          lineItem:       [ { position: 50, importance: #MEDIUM } ],
      //          identification: [ { position: 50 } ],
      //          selectionField: [ { position: 50 } ] }
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      PricePerT,
      //            @UI: {
      //          lineItem:       [ { position: 30, importance: #MEDIUM } ],
      //          identification: [ { position: 30 } ],
      //          selectionField: [ { position: 30 } ] }
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      TotalPrice,
      //      CurrencyCode,
      @UI: {
      lineItem:       [ { position: 40, importance: #MEDIUM } ],
      identification: [ { position: 40, label: 'Remarks' } ],
      selectionField: [ { position: 40 } ] }
      Remarks,
      @UI: {
      lineItem:       [ { position: 50, importance: #MEDIUM } ],
      identification: [ { position: 50, label: 'Status' } ],
      selectionField: [ { position: 50 } ] }
      Status,
      @UI: {
      lineItem:       [ { position: 60, importance: #MEDIUM } ],
      identification: [ { position: 60, label: 'Delivery Date' } ],
      selectionField: [ { position: 60 } ] }
      DeliveryDate,
       @UI: {
      lineItem:       [ { position: 60, importance: #MEDIUM } ],
      identification: [ { position: 60, label: 'Delivery Date' } ],
      selectionField: [ { position: 60 } ] }
      DeliveryTime,
      //      DropOffDate,
      //      DropOffTime,
      //      DestCity,
      //      DestPostalCode,
      //      DestStreet,
      //      DestCountryCode,
      // Admin data
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy,
      /*  Make association public */
      _Container,
      _Customer
}
