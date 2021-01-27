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
      @ObjectModel.text.element: ['CustomerName']

      @Search.defaultSearchElement: true
      CustomerID,
      @Semantics.text: true
      CustomerName,
      @UI: {
          lineItem:       [ { position: 12, importance: #HIGH } ],
          identification: [ { position: 12, label: 'Container ID' } ],
          selectionField: [ { position: 12 } ] }
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_Container', element: 'ContainerID' }}]
      @Search.defaultSearchElement: true
      ContainerID,
      @UI: {
          lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
      @Semantics.text: true
      Category,
      //            @UI: {
      //          lineItem:       [ { position: 30, importance: #MEDIUM } ],
      //          identification: [ { position: 30 } ],
      //          selectionField: [ { position: 30 } ] }
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      PricePerT,
      //      @UI: {
      //      lineItem:       [ { position: 30, importance: #MEDIUM } ],
      //      identification: [ { position: 30, label: 'Total Price' } ] }
      //      @Semantics.amount.currencyCode: 'CurrencyCode'
      //      TotalPrice,
      CurrencyCode,
      @UI: {
      lineItem:       [ { position: 40, importance: #LOW } ],
      identification: [ { position: 40, label: 'Remarks' } ] }
      @Semantics.text: true
      Remarks,
      @UI: {
      lineItem:       [ { position: 50, importance: #HIGH } ],
      identification: [ { position: 50, label: 'Delivery Date' } ]//,
      //selectionField: [ { position: 50 } ]
      }
      @Semantics.businessDate.from: true
      DeliveryDate,
      @UI: {
      lineItem:       [ { position: 51, importance: #LOW } ],
      identification: [ { position: 51, label: 'Delivery Time' } ] }
      DeliveryTime,
      @UI: {
      lineItem:       [ { position: 52, importance: #HIGH },
      {type: #FOR_ACTION, dataAction: 'setDropOffDate', label: 'Container dropped off'} ],
      identification: [ { position: 52, label: 'Desired Drop Off Date' } ] }
      @Semantics.businessDate.to: true
      DesiredDropOffDate,
      @UI: {
      lineItem:       [ { position: 53, importance: #LOW } ],
      identification: [ { position: 53, label: 'Desired Drop Off Time' } ]}
      DesiredDropOffTime,
      @UI: {
       lineItem:       [ { position: 54, importance: #MEDIUM }
      //              , {type: #FOR_ACTION, dataAction: 'setDropOffDate', label: 'Container dropped off'}
      ], identification: [ { position: 54, label: 'Drop Off Date' }
           ,   {type: #FOR_ACTION, dataAction: 'setDropOffDate', label: 'Container dropped off'}
      ]}
      @Semantics.businessDate.to: true
      DropOffDate,
      @UI: {
      lineItem:       [ { position: 55, importance: #MEDIUM } ],
      identification: [ { position: 55, label: 'Drop Off Time' } ]}
      DropOffTime,
      @UI: {
      lineItem:       [ { position: 60, importance: #HIGH }],
      identification: [ { position: 60, label: 'Destination City' }]}
      @Semantics.address.city: true
      DestCity,
      @UI: {
      lineItem:       [ { position: 61, importance: #HIGH }],
      identification: [ { position: 61, label: 'Destination PLZ' }]}
      @Semantics.address.postBox: true
      DestPostalCode,
      @UI: {
      lineItem:       [ { position: 62, importance: #HIGH }],
      identification: [ { position: 62, label: 'Destination Street' }]}
      @Semantics.address.street: true
      DestStreet,
      @UI: {
      lineItem:       [ { position: 63, importance: #HIGH }],
      identification: [ { position: 63, label: 'Cntry' }]}
      //      @UI.hidden: true
      DestCountryCode,
      @UI: {
      lineItem:       [ { position: 70, importance: #HIGH }
        , {type: #FOR_ACTION, dataAction: 'setStatusFinished', label: 'Order finished'}
      ],
      identification: [ { position: 70, label: 'Status' }
        , {type: #FOR_ACTION, dataAction: 'setStatusFinished', label: 'Order finished'}
      ],
      selectionField: [ { position: 70 } ] }
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
      LastLocalChangedAt


}
