@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO (Data Model) View for Container'
define root view entity ZI_Container
  as select from zat_container
{
      @EndUserText.label: 'Container UUID'
  key container_uuid          as ContainerUUID,
      @EndUserText.label: 'Container ID'
      container_id            as ContainerID,
      @EndUserText.label: 'Payload'
      @Semantics.quantity.unitOfMeasure: 'PayloadUnitOfMeasure'
      max_payload             as Payload,
      payload_unit_of_measure as PayloadUnitOfMeasure,
      @EndUserText.label: 'IsAvailable'
      available               as IsAvailable //,
      // Make association public
      //    _association_name
}
