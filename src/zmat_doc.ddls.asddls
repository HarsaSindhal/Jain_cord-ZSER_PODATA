//@AbapCatalog.sqlViewName: 'ZMAT_DOC1'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'material document'
define view entity zmat_doc as select from I_MaterialDocumentHeader_2  as a
                      left outer join I_MaterialDocumentItem_2 as b on ( a.MaterialDocument = b.MaterialDocument )
                      left outer join I_Supplier as c on ( b.Supplier = c.Supplier )
{// key  a.ReferenceDocument as invoice_no,
  key  max( a.MaterialDocument ) as MaterialDocument,
  key  max(a.DocumentDate) as MaterialDocumentYear,
       a.ReferenceDocument as invoice_no,        
       b.ReversedMaterialDocument,
       case 
       when b.ReversedMaterialDocument = ''
       then ''
       when b.ReversedMaterialDocument is not initial or b.ReversedMaterialDocument <> ''
       then 'X'
       end as  migo,
       c.SupplierName
//       b.DebitCreditCode,
//     max( b.GoodsMovementType ) as GoodsMovementType 
//      b.GoodsMovementType
    
}
//where a.InventoryTransactionType = 'WE'
//
group by 
////// 
////// 
//  
  b.ReversedMaterialDocument,
  a.MaterialDocumentYear,
  a.ReferenceDocument,
  c.SupplierName
