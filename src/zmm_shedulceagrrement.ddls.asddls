@AbapCatalog.sqlViewName: 'YSCHDULE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Shedule Data'
define view ZMM_SHEDULCEAGRREMENT 
//with parameters P_DATA : abap.datn 
as select from I_SchedglineApi01 as a 
{
    key a.SchedulingAgreement,
    key a.SchedulingAgreementItem,
        a.OrderQuantityUnit,
        sum(a.ScheduleLineOrderQuantity) -  sum(a.RoughGoodsReceiptQty) as Qty,
        sum(a.RoughGoodsReceiptQty)   as RoughGoodsReceiptQty
} 
   where   a.SchedLineStscDeliveryDate <= $session.system_date
      group by 
      
      a.SchedulingAgreement,
      a.SchedulingAgreementItem,
      a.OrderQuantityUnit
