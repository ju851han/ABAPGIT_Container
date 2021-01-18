@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection BO View for Customer'
define root view entity ZC_CUSTOMER_M
  as projection on ZI_CUSTOMER_M as Customer
  //composition of target_data_source_name as _association_name
{
  key CustomerUUID,
      CustomerID,
      FirstName,
      LastName,
      CompanyName,
      City,
      PostalCode,
      Street,
      CountryCode,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy //,
      // Make association public
      //    _association_name
}
