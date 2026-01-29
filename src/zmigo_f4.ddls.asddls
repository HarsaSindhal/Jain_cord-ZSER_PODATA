@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'migo f4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIGO_F4 as select from YGATE_HEADER
{
    key Gateno,
        Invoice
        
}  
where EntryType = 'WPO'and   
      Cancelled = '' 
      
      
