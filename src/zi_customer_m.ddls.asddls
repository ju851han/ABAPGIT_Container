@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Customer'
define root view entity ZI_CUSTOMER_M
  as select from zat_customer
{
    @EndUserText.label: 'Customer UUID'
  key customer_uuid         as CustomerUUID,
  @EndUserText.label: 'Customer ID'
      customer_id           as CustomerID,
      @EndUserText.label: 'First Name'
      @Semantics.name.givenName: true
      first_name            as FirstName,
      @EndUserText.label: 'Last Name'
      @Semantics.name.familyName: true
      last_name             as LastName,
      @EndUserText.label: 'Company Name'
      company_name          as CompanyName,
      @EndUserText.label: 'City'
      @Semantics.address.city: true
      city                  as City,
      @EndUserText.label: 'Postal Code'
      postal_code           as PostalCode,
      @EndUserText.label: 'Street'
      street                as Street,
      @EndUserText.label: 'CountryCode'
      country_code          as CountryCode,
      //Admin data
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_local_changed_at as LastLocalChangedAt //,
      // Make association public
      //    _association_name
}
