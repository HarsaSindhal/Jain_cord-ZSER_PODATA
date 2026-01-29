@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds View For Po Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zmatdoc_data as select from I_MaterialDocumentItem_2
as a inner join YMSEG4 as b on ( a.MaterialDocument  = b.MaterialDocument and a.MaterialDocumentItem = b.MaterialDocumentItem   )
{

 a.PurchaseOrder ,
 a.PurchaseOrderItem ,
 a.EntryUnit ,  
 @Semantics.quantity.unitOfMeasure: 'EntryUnit'    
 sum(  a.QuantityInEntryUnit ) as migoQty    
}
 where a.GoodsMovementType = '101' and a.GoodsMovementIsCancelled = '' 
group by 
 a.PurchaseOrder , 
 a.PurchaseOrderItem, 
 a.EntryUnit
