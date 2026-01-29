@AbapCatalog.sqlViewName: 'ZMIGODATA2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Migo Module Pool'
@Metadata.ignorePropagatedAnnotations: true
define view ZMAT_DOC1 as select from zmat_doc
{  
    key MaterialDocument,
    key left(MaterialDocumentYear,4) as MaterialDocumentYear,
    invoice_no,
    ReversedMaterialDocument,
    migo,
    SupplierName
}
