@AbapCatalog.sqlViewName: 'YPURDATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Valid TO From Date'
define view ZMM_DATE_VALID_TO_FORM as select from I_PurchaseOrderAPI01 as a 
                                    left outer join I_Supplier as b on a.Supplier = b.Supplier

{
    key a.PurchaseOrder,
    key a.PurchaseOrderType,
        a.PurchasingProcessingStatus,
        a.YY1_Valid_From_PDH,
        a.YY1_Valid_To_PDH,
        b.SupplierName
} 
union select from I_SchedgagrmthdrApi01 as a 
                 left outer join I_Supplier as b on a.Supplier = b.Supplier
{ 
   key a.SchedulingAgreement as PurchaseOrder,
   key a.PurchasingDocumentType as PurchaseOrderType,
       a.ScheduleAgreementHasReleaseDoc as PurchasingProcessingStatus,
       a.ValidityStartDate as YY1_Valid_From_PDH,
       a.ValidityEndDate   as  YY1_Valid_To_PDH,
        b.SupplierName
       
  }
