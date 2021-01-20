@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection BO View for Customer'

@UI:{
headerInfo: {typeName:'Customer', typeNamePlural:'Customers', title: { type: #STANDARD, value: 'CustomerID'}}}

@Search.searchable: true
@ObjectModel.semanticKey: ['CustomerID']
define root view entity ZC_CUSTOMER_M
  as projection on ZI_CUSTOMER_M as Customer
  //composition of target_data_source_name as _association_name
{
      @UI.facet: [{id:       'Customer',
                       purpose:  #STANDARD,
                       type:     #IDENTIFICATION_REFERENCE,
                       label:    'Customer',
                       position: 10 }]
      @UI:{ identification:[{position:1, label: 'Customer UUID' }]}
      @UI.hidden: true
  key CustomerUUID,
      @UI: {
        lineItem:       [ { position: 10, importance: #HIGH } ],
        identification: [ { position: 10, label: 'Customer ID' } ] }
      @Search.defaultSearchElement: true
      CustomerID,
      @UI: {
      lineItem:       [ { position: 20, importance: #MEDIUM } ],
      identification: [ { position: 20, label: 'First Name' } ] }
      FirstName,
      @UI: {
      lineItem:       [ { position: 30, importance: #MEDIUM } ],
      identification: [ { position: 30, label: 'Last Name' } ] }
      LastName,
      @UI: {
      lineItem:       [ { position: 40, importance: #MEDIUM } ],
      identification: [ { position: 40, label: 'Company Name' } ] }
      CompanyName,
      @UI: {
      lineItem:       [ { position: 50, importance: #MEDIUM } ],
      identification: [ { position: 50, label: 'City' } ] }
      City,
      @UI: {
      lineItem:       [ { position: 60, importance: #MEDIUM } ],
      identification: [ { position: 60, label: 'Postal Code' } ] }
      PostalCode,
      @UI: {
      lineItem:       [ { position: 70, importance: #MEDIUM } ],
      identification: [ { position: 70, label: 'Street' } ] }
      Street,
      @UI: {
      lineItem:       [ { position: 80, importance: #MEDIUM } ],
      identification: [ { position: 80, label: 'Country Code' } ] }
      CountryCode,
      // Admin data
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      LastChangedAt,
      @UI.hidden: true
      LastChangedBy //,
      // Make association public
      //    _association_name
}
