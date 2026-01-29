@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 service for Po'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpo_f4 as select from I_PurchaseOrderAPI01 as a left outer join
 I_Supplier  as b on ( a.Supplier = b.Supplier )
{
key  a.PurchaseOrder,
     a.SupplierRespSalesPersonName ,
     a.PurchaseOrderDate,
     b.SupplierName
    
}
