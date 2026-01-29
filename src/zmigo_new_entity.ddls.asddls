@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds for new entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIGO_NEW_ENTITY as select from  ZMM_SHEDULCEAGRREMENT as SHE
left outer join I_SchedgAgrmtItmApi01 as a  on ( a.SchedulingAgreement = SHE.SchedulingAgreement and a.SchedulingAgreementItem = SHE.SchedulingAgreementItem )
left outer join I_Product as b on (a.Material = b.Product)

left outer join I_SchedgagrmthdrApi01 as d on (d.SchedulingAgreement  = a.SchedulingAgreement )
left outer join I_Supplier as e on (e.Supplier = d.Supplier )

{
    key SHE.SchedulingAgreement,
    key SHE.SchedulingAgreementItem,
        SHE.OrderQuantityUnit  as SHEUNIT,
        @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
        SHE.Qty,
        a.Material,
        a.PurchasingDocumentItemText,
        a.OrderQuantityUnit,
        a.Plant,
        a.StorageLocation,
        b.ProductManufacturerNumber,
        d.Supplier,
        e.SupplierName
        
}
