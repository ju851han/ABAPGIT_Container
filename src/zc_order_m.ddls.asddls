@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection BO View for Order'

@UI:{
headerInfo: {typeName:'Order',
             typeNamePlural:'Orders',
             title: { type: #STANDARD, value: 'OrderID'}},
// Sort by Delivery Date (Youngest Date is on first row)
presentationVariant: [{ sortOrder: [{ by: 'DeliveryDate', direction: #DESC }], visualizations: [{type: #AS_LINEITEM }] }]
}


@Search.searchable: true
// @Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['OrderID']

define root view entity ZC_ORDER_M
  as projection on ZI_ORDER_M as Order
{
      @UI.facet: [{id:       'Order',
                   purpose:  #STANDARD,
                   type:     #IDENTIFICATION_REFERENCE,
                   label:    'Order',
                   position: 10 }]
      @UI:{ identification:[{position:1, label: 'Order UUID' }]}
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
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_Customer_M', element: 'CustomerID'} }]
//           @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      CustomerID,
//          _Customer.LastName as CustomerName,
      @UI: {
          lineItem:       [ { position: 12, importance: #HIGH } ],
          identification: [ { position: 12, label: 'Container ID' } ],
          selectionField: [ { position: 12 } ] }
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_Container', element: 'ContainerID' }}]
      @Search.defaultSearchElement: true
      ContainerID,
      @UI: {
          lineItem:       [ { position: 20, importance: #MEDIUM } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
      Category,
      //            @UI: {
      //          lineItem:       [ { position: 30, importance: #MEDIUM } ],
      //          identification: [ { position: 30 } ],
      //          selectionField: [ { position: 30 } ] }
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      PricePerT,
      @UI: {
      lineItem:       [ { position: 30, importance: #MEDIUM } ],
      identification: [ { position: 30, label: 'Total Price' } ] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      @UI: {
      lineItem:       [ { position: 40, importance: #MEDIUM } ],
      identification: [ { position: 40, label: 'Remarks' } ] }
      Remarks,
      @UI: {
      lineItem:       [ { position: 50, importance: #MEDIUM } ],
      identification: [ { position: 50, label: 'Delivery Date' } ],
      selectionField: [ { position: 50 } ] }
      DeliveryDate,
      @UI: {
      lineItem:       [ { position: 51, importance: #MEDIUM } ],
      identification: [ { position: 51, label: 'Delivery Date' } ] }
      DeliveryTime,
      //      @UI: {
      //       lineItem:       [ { position: 52, importance: #MEDIUM } ],
      //       identification: [ { position: 52, label: 'Drop Off Date' } ],
      //       selectionField: [ { position: 52 } ] }
      //      DropOffDate,
      //      @UI: {
      //      lineItem:       [ { position: 53, importance: #MEDIUM } ],
      //      identification: [ { position: 53, label: 'Drop Off Time' } ],
      //      selectionField: [ { position: 53 } ] }
      //      DropOffTime,
      //      DestCity,
      //      DestPostalCode,
      //      DestStreet,
      //      DestCountryCode,
      @UI: {
      lineItem:       [ { position: 60, importance: #MEDIUM }
      //      , {type: #FOR_ACTION, dataAction: 'setDropOff', label:'setDropOff'}
        ],
      identification: [ { position: 60, label: 'Status' }
      //      , {type: #FOR_ACTION, dataAction: 'setDropOff', label:'setDropOff'}
       ],
      selectionField: [ { position: 60 } ] }
      Status,
      // Admin data
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      LastChangedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastLocalChangedAt,
      /*  Make association public */
      _Container,
      _Customer
}
