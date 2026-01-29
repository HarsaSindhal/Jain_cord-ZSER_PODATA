@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Purchase Order Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zmm_podetail as select from  
I_PurchaseOrderAPI01 as a 
      left outer join
        I_PurchaseOrderItemAPI01 as b 
      on ( b.PurchaseOrder = a.PurchaseOrder )
  //    left outer join I_PurOrdAccountAssignmentAPI01  as c on  ( c.PurchaseOrder = b.PurchaseOrder 
  //                                                       and c.PurchaseOrderItem = b.PurchaseOrderItem ) 
      left outer join I_Supplier as d on ( d.Supplier = a.Supplier )                                                
      left outer join I_ProductDescription as e on ( e.Product = b.Material and e.Language = 'E' ) 
      left outer join I_Product as f on ( f.Product = b.Material  )  
      left outer join zmatdoc_data as g on (                 g.PurchaseOrder = b.PurchaseOrder 
                                                         and g.PurchaseOrderItem = b.PurchaseOrderItem ) 
{
   

    key   a.PurchaseOrder,
    key   b.PurchaseOrderItem,
          b.Material as Material543,
          b.Material, 
          b.DocumentCurrency ,
    //      @Semantics.amount.currencyCode: 'DocumentCurrency' 
   //       b.NetPriceAmount    as NetPriceAmount,
          cast( b.NetPriceAmount as abap.dec( 15, 2 ) ) as NetPriceAmount,
          b.IsCompletelyDelivered ,
          b.PurchaseOrderQuantityUnit as BaseUnit,
          @Semantics.quantity.unitOfMeasure: 'BaseUnit'
          b.OrderQuantity,
          @Semantics.quantity.unitOfMeasure: 'BaseUnit'
          g.migoQty as grnqty ,
          @Semantics.quantity.unitOfMeasure: 'BaseUnit'
          case  
          when g.migoQty is null
          then b.OrderQuantity
          else       
          ( b.OrderQuantity - g.migoQty  )
          end  as OpenQty  ,
          a.Supplier,
          d.SupplierName,
          e.ProductDescription,
          f.YY1_Material_1_PRD,
//        f.YY1_Materialdes_1_PRD
//          ,
          f.ProductManufacturerNumber as    ManufacturerBookPartNumber

        
   
} 
  where ( b.PurchasingDocumentDeletionCode = ' ' ) 
//       and a.DebitCreditCode = 'S' and a.GoodsMovementIsCancelled = ''
union select from  ZMM_SHEDULCEAGRREMENT as SHE
left outer join I_SchedgAgrmtItmApi01 as a  on ( a.SchedulingAgreement = SHE.SchedulingAgreement and a.SchedulingAgreementItem = SHE.SchedulingAgreementItem )
left outer join I_Product as b on (a.Material = b.Product)
left outer join I_ProductDescription as f on ( f.Product = b.Product and f.Language = 'E' ) 
left outer join I_SchedgagrmthdrApi01 as d on (d.SchedulingAgreement  = a.SchedulingAgreement )
left outer join I_Supplier as e on (e.Supplier = d.Supplier )

{
    key SHE.SchedulingAgreement as PurchaseOrder,
    key SHE.SchedulingAgreementItem as PurchaseOrderItem,
        a.Material  as Material543,
        a.Material,
        a.DocumentCurrency,
    //        a.NetPriceAmount    as NetPriceAmount,
        cast( a.NetPriceAmount as abap.dec( 15, 2 ) ) as NetPriceAmount,
        '' as IsCompletelyDelivered,
        SHE.OrderQuantityUnit  as BaseUnit, 
        a.TargetQuantity as OrderQuantity,
        SHE.RoughGoodsReceiptQty as grnqty ,
        SHE.Qty as OpenQty,  
        d.Supplier,
        e.SupplierName,
        f.ProductDescription,
     //   a.OrderQuantityUnit,
        b.YY1_Material_1_PRD,
        b.ProductManufacturerNumber as    ManufacturerBookPartNumber
       
        
}
  where a.PurchasingDocumentDeletionCode = ''
 
