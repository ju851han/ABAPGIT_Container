@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection BO View for Customer'

@UI:{
headerInfo: {typeName:'Customer',
             typeNamePlural:'Customers',
             title: { type: #STANDARD, value: 'CustomerID'}},
   // Sort by CustomerID (Lowest CustomerID is on first row)
             presentationVariant: [{ sortOrder: [{ by: 'CustomerID', direction: #ASC }], visualizations: [{type: #AS_LINEITEM }] }]
             }

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
      @Semantics.text: true
      FirstName,
      @UI: {
      lineItem:       [ { position: 30, importance: #HIGH } ],
      identification: [ { position: 30, label: 'Last Name' } ] }
      @Semantics.text: true
      LastName,
      @UI: {
      lineItem:       [ { position: 40, importance: #MEDIUM } ],
      identification: [ { position: 40, label: 'Company Name' } ] }
      @Semantics.text: true
      @Semantics.organization.name: true
      CompanyName,
      @UI: {
      lineItem:       [ { position: 50, importance: #HIGH } ],
      identification: [ { position: 50, label: 'City' } ] }
      @Semantics.address.city: true
      @Semantics.text: true
      City,
      @UI: {
      lineItem:       [ { position: 60, importance: #HIGH } ],
      identification: [ { position: 60, label: 'Postal Code' } ] }
      PostalCode,
      @UI: {
      lineItem:       [ { position: 70, importance: #HIGH } ],
      identification: [ { position: 70, label: 'Street' } ] }
      @Semantics.address.street: true
      @Semantics.text: true
      Street,
      @UI: {
      lineItem:       [ { position: 80, importance: #HIGH } ],
      identification: [ { position: 80, label: 'Country Code' } ] }
      @Semantics.text: true
      CountryCode,
      // Admin data
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      LastChangedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden : true
      LastLocalChangedAt
      // Make association public
      //    _association_name
}
