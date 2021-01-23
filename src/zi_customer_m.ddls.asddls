@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Customer'
define root view entity ZI_CUSTOMER_M
  as select from zat_customer
  //composition of target_data_source_name as _association_name
{
  key customer_uuid         as CustomerUUID,
      customer_id           as CustomerID,
      @Semantics.name.givenName: true
      first_name            as FirstName,
      @Semantics.name.familyName: true
      last_name             as LastName,
      company_name          as CompanyName,
      @Semantics.address.city: true
      city                  as City,
      postal_code           as PostalCode,
      street                as Street,
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
