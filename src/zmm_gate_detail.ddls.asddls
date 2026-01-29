@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Purchase Order Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_GATE_DETAIL as 
  select from 
  YGATE_HEADER as Q inner join 
  YGATEITM_CDS as T  on  ( Q.Gateno  = T.Gateno  )
  inner  join  I_PurchaseOrderItemAPI01 as b 
      on ( T.Ebeln =  b.PurchaseOrder  and T.Ebelp = b.PurchaseOrderItem )
 left outer join
   I_PurchaseOrderAPI01 as a on ( b.PurchaseOrder =  a.PurchaseOrder  )
      left outer join
      I_PurOrdAccountAssignmentAPI01  as c on  ( c.PurchaseOrder = b.PurchaseOrder  and c.PurchaseOrderItem = b.PurchaseOrderItem ) 
      left outer join I_Supplier as d on ( d.Supplier = a.Supplier )                                                
      left outer join I_ProductDescription as e on ( e.Product = b.Material and e.Language = 'E' ) 
      left outer join I_Product as f on ( f.Product = b.Material  )  
      left outer join zmatdoc_data as g on (                 g.PurchaseOrder = b.PurchaseOrder 
                                                         and g.PurchaseOrderItem = b.PurchaseOrderItem ) 
{
    
    key   T.Gateno ,
    key   T.GateItem ,
    key   a.PurchaseOrder,
    key   b.PurchaseOrderItem,
          T.asn ,
          T.asn_line ,
          T.batch ,
          T.Noofpackage,
          b.Material as Material543,
          b.Material, 
          Q.Invoice,
          Q.Invdt ,
          b.DocumentCurrency,
          Q.Plant ,
      //    @Semantics.amount.currencyCode: 'DocumentCurrency'
        cast(  b.NetPriceAmount as abap.dec( 13, 2 ) )  as NetPriceAmount,
          T.GateQty as ACCEPTED_QTY ,
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
          c.SalesOrder,
//          c.SalesOrderItem,
          a.Supplier,
          d.SupplierName,
          e.ProductDescription,
          f.YY1_Material_1_PRD,
//        f.YY1_Materialdes_1_PRD
//          ,
          f.ProductManufacturerNumber as    ManufacturerBookPartNumber

        
   
} 
 where ( b.PurchasingDocumentDeletionCode = ' ' ) 
union
 select from 
  YGATE_HEADER as Q inner join 
  YGATEITM_CDS as T  on  ( Q.Gateno  = T.Gateno  )
  inner  join  I_SchedgAgrmtItmApi01 as b 
      on ( T.Ebeln =  b.SchedulingAgreement  and T.Ebelp = b.SchedulingAgreementItem )
 left outer join
   I_SchedgagrmthdrApi01 as a on ( b.SchedulingAgreement =  a.SchedulingAgreement  )
//      left outer join
//      I_PurOrdAccountAssignmentAPI01  as c on  ( c.PurchaseOrder = b.PurchaseOrder  and c.PurchaseOrderItem = b.PurchaseOrderItem ) 
      left outer join I_Supplier as d on ( d.Supplier = a.Supplier )                                                
      left outer join I_ProductDescription as e on ( e.Product = b.Material and e.Language = 'E' ) 
      left outer join I_Product as f on ( f.Product = b.Material  )  
//      left outer join zmatdoc_data as g on (                 g.SchedulingAgreement = b.SchedulingAgreement 
//                                                         and g.PurchaseOrderItem = b.PurchaseOrderItem ) 
{
    
    key   T.Gateno ,
    key   T.GateItem ,
    key   a.SchedulingAgreement as PurchaseOrder,
    key   b.SchedulingAgreementItem as PurchaseOrderItem,
          T.asn ,
          T.asn_line ,
          T.batch ,
          T.Noofpackage,
          b.Material as Material543,
          b.Material, 
//          T.Zinvoice as  Invoice,
          Q.Invoice ,
          Q.Invdt ,
          b.DocumentCurrency,
          Q.Plant ,
       //   @Semantics.amount.currencyCode: 'DocumentCurrency'
          cast( b.NetPriceAmount  as abap.dec( 13, 2 ) ) as NetPriceAmount,
//          cast( b.NetPriceAmount as abap.dec( 15, 2 ) ) as  NetPriceAmount,
          T.GateQty as ACCEPTED_QTY ,
          ' ' as IsCompletelyDelivered ,
          b.OrderQuantityUnit as BaseUnit,
          b.TargetQuantity as OrderQuantity,
          0 as grnqty ,
          0 as  OpenQty  ,
          '1000000' as SalesOrder,
//          cast('000001' as abap.numc( 6 ) ) as SalesOrderItem,
          a.Supplier,
          d.SupplierName,
          e.ProductDescription,
          f.YY1_Material_1_PRD,
          f.ProductManufacturerNumber as    ManufacturerBookPartNumber

        
   
} 


 
