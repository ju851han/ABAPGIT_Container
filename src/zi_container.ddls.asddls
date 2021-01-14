@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'BO (Data Model) View for Container'
define root view entity ZI_Container
  as select from zat_container
  /* Associations */
  //association [0..1] to /DMO/I_Agency   as _Agency   on $projection.agency_id = _Agency.AgencyID

{
  key container_uuid as ContainerUUID,
      container_id   as ContainerID,
      weight         as Weight,
      available      as IsAvailable //,
      // Make association public
      //    _association_name
}
