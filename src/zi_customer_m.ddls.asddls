@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Customer'
define root view entity ZI_CUSTOMER_M
  as select from zat_customer
  //composition of target_data_source_name as _association_name
{
  key customer_uuid         as CustomerUUID,
      customer_id           as CustomerID,
      first_name            as FirstName,
      last_name             as LastName,
      company_name          as CompanyName,
      city                  as City,
      postal_code           as PostalCode,
      street                as Street,
      country_code          as CountryCode,
      created_at            as CreatedAt,
      created_by            as CreatedBy,
      last_changed_at       as LastChangedAt,
      last_changed_by       as LastChangedBy,
      last_local_changed_at as LastLocalChangedAt //,
      // Make association public
      //    _association_name
}
