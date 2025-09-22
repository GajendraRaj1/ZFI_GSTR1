@AbapCatalog.sqlViewName: 'ZI_SALES_REPORT'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view ZI_SALES_DATA_TO_MI

  as select from ZI_FI_JOURNAL_ENTRY as jou_entry



  //  as select from I_BillingDocumentItemBasic as billingitem
  //association to I_BillingDocumentItemBasic as billingitem on billingitem.BillingDocument = jou_entry.referencedocno
  //as select from I_OperationalAcctgDocItem as billingitem


  association [0..1] to I_BillingDocumentItemBasic     as BillItem       on  BillItem.BillingDocument     = jou_entry.referencedocno
  //                                                                and BillItem.BillingDocument = billingitem.BillingDocument
  //                                                                and BillItem.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                         and BillItem.BillingDocumentItem = jou_entry.ReferenceDocumentItem

  //                                                                         and jou_entry.AccountingDocumentItem <> '005'


  association [0..1] to I_BillingDocumentBasic         as BillingHeader  on  BillingHeader.BillingDocument         = jou_entry.referencedocno
                                                                         and BillingHeader.AccountingPostingStatus = 'C'
 

  //and ( BillingHeader.SDDocumentCategory <>  'U' or BillingHeader.SDDocumentCategory <> 'N'
  //    or BillingHeader.BillingDocumentIsCancelled <> 'X' )

  //association [0..1] to i_ir
  association [0..1] to zgstr1_st                      as status         on  status.accounting_doc = jou_entry.AccountingDocument

  //association [0..1] to j_1ig_invrefnum as irn on irn.docno = billingitem.BillingDocument
  association [0..1] to I_BillingDocumentTypeText      as documenttype   on  documenttype.BillingDocumentType = jou_entry.referencedocno
                                                                         and documenttype.Language            = 'E'

  association [1]    to I_IN_ElectronicDocInvoice      as irn            on  irn.IN_EDocEInvcExtNmbr     = jou_entry.originalrefdocno
                                                                         and irn.ElectronicDocSourceType = 'FI_INVOICE'

  association [1]    to I_IN_ElectronicDocInvoice      as irn_bill       on  irn_bill.ElectronicDocSourceKey = jou_entry.referencedocno

  association [0..1] to ZI_PREC_INV_NO                 as PrecInv 
  //on PrecInv.SubsequentDocument = billingitem.SalesDocument
  //and billingitem.BillingDocumentItem = PrecInv.SubsequentDocumentItem
                                                                         on  PrecInv.BillingDocument        = jou_entry.referencedocno
                                                                         and PrecInv.SubsequentDocumentItem = jou_entry.ReferenceDocumentItem
  //association [0..1] to I_IN_InvcRefNmbrDet             as irn            on irn.IN_DocumentNumber = billingitem.BillingDocument
  association [0..1] to I_DistributionChannelText      as Distchannel    on  Distchannel.DistributionChannel = jou_entry.Distributionchannel
                                                                         and Distchannel.Language            = 'E'

  //  association [0..1] to I_DivisionText                 as Division      on  Division.Division = BillItem.Division
  //                                                                        and Division.Language = 'E'

  //  association [0..1] to I_BillingDocumentItemBasic     as billingitem1  on  billingitem1.BillingDocument     = billingitem.BillingDocument
  //                                                                        and billingitem1.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and billingitem1.Material <> ''
  //and billingitem1.BillingQuantity    not ' '
  //and billingitem1.

  association [0..1] to ZI_Customer_Details            as customer       on  customer.Billiing_Doc = jou_entry.referencedocno

  //24,
  //  association [0..1] to I_SalesOrderItmPrecdgProcFlow  as itemflow1      on  BillItem.SalesDocument              = jou_entry.salesorder
  //                                                                         and BillItem.SalesDocumentItem          = jou_entry.salorderitem
  //                                                                         and itemflow1.PrecedingDocumentCategory = 'G'

  //26,27,28,29
  association [0..1] to I_SalesOrder                   as salesdetails   on  salesdetails.SalesOrder = jou_entry.salesdocument


  //30,31
  //association [0..1] to I_SalesOrderItmSubsqntProcFlow as salesflow
  // on billingitem.SalesDocument = salesflow.SalesOrder
  // and billingitem.SalesDocumentItem = salesflow.SalesOrderItem
  // and salesflow.SubsequentDocumentCategory = 'J'

  //  association [0..1] to I_DeliveryDocument             as Delivery       on  Delivery.DeliveryDocument = BillItem.ReferenceSDDocument
  //
  //
  //  //32
  //  association [0..1] to I_AdditionalMaterialGroup1Text as Mattext        on  Mattext.AdditionalMaterialGroup1 = billingitem.additionalmaterialgroup1

  //36
  
//(-) 18.07.2024  
//  association [0..1] to I_ProductPlantBasic            as HSNcode        on  HSNcode.Product = jou_entry.product
//                                                                         and HSNcode.Plant   = jou_entry.plant
//                                                                         
//  association [0..1] to I_JournalEntryItem             as HSN          on  jou_entry.AccountingDocument  = HSN.AccountingDocument
//                                                                       and HSN.Ledger                     = '0L'  
//                                                                       and HSN.AssignmentReference        <> ''
//(-) 18.07.2024                                                                         

  //  association [0..1] to I_AdditionalCustomerGroup1Text as Custgrp       on  Custgrp.AdditionalCustomerGroup1 = BillItem.CustomerGroup
  //                                                                        and Custgrp.Language                 = 'E'


  //37,38,39,40
  // association [0..1] to I_Batch as Batchdetails
  //  on Batchdetails.Batch = billingitem.Batch
  //  association [0..1] to I_DeliveryDocumentItem         as batchdetails   on  batchdetails.DeliveryDocument         = BillItem.ReferenceSDDocument
  //                                                                         and batchdetails.HigherLvlItmOfBatSpltItm = BillItem.ReferenceSDDocumentItem
  //                                                                         and batchdetails.Product                  = BillItem.Product
  //41,42
  // association [0..1] to
  //
  // //43,44,45,46
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg       on  Itemprcg.BillingDocument         =  jou_entry.referencedocno
                                                                         and Itemprcg.BillingDocumentItem     =  jou_entry.ReferenceDocumentItem
                                                                         and Itemprcg.ConditionRateAmount     <> 0
                                                                         and Itemprcg.ConditionType           =  'PPR0'
                                                                         and Itemprcg.ConditionInactiveReason =  ''
  //     and Itemprcg.ConditionBaseQuantity = '84.00'

  //44
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg1      on  Itemprcg1.BillingDocument     = jou_entry.referencedocno
                                                                         and Itemprcg1.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and Itemprcg1.ConditionType       = 'YBHD'
  // and Itemprcg1.ConditionType       = 'ZASS'

  //
  //45
  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg2     on  Itemprcg2.BillingDocument     = billingitem.BillingDocument
  //                                                                        and Itemprcg2.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and Itemprcg2.ConditionType       = 'FIN1'
  //  //46
  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg3     on  Itemprcg3.BillingDocument     = billingitem.BillingDocument
  //                                                                        and Itemprcg3.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and Itemprcg3.ConditionType       = 'FPA1'
  //50-61                                                                       START  //GST Details
  association [1]    to I_BillingDocItemPrcgElmntBasic as CGSTdetails    on  CGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and CGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and CGSTdetails.ConditionType       = 'JOCG'
  //USD currency
  association [1]    to I_BillingDocItemPrcgElmntBasic as CGST_usd       on  CGST_usd.BillingDocument     = jou_entry.referencedocno
                                                                         and CGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and CGST_usd.ConditionType       = 'JOCG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as SGSTdetails    on  SGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and SGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and SGSTdetails.ConditionType       = 'JOSG'
  //USD
  association [1]    to I_BillingDocItemPrcgElmntBasic as SGST_usd       on  SGST_usd.BillingDocument     = jou_entry.referencedocno
                                                                         and SGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and SGST_usd.ConditionType       = 'JOSG'


  association [1]    to I_BillingDocItemPrcgElmntBasic as IGSTdetails    on  IGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and IGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and IGSTdetails.ConditionType       = 'JOIG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as IGST_usd       on  IGST_usd.BillingDocument     = jou_entry.referencedocno
  //                                                                         and IGST_usd.BillingDocumentItem = jou_entry.ReferenceDocumentItem //(+)Anurag
                                                                         and IGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and IGST_usd.ConditionType       = 'JOIG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as TGSTdetails    on  TGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and TGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and TGSTdetails.ConditionType       = 'ZSCR'

  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as VGSTdetails   on  VGSTdetails.BillingDocument     = billingitem.BillingDocument
  //                                                                        and VGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and VGSTdetails.ConditionType       = 'ZVAT'

  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as CSTdetails    on  CSTdetails.BillingDocument     = billingitem.BillingDocument
  //                                                                        and CSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and CSTdetails.ConditionType       = 'ZCST'



  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as TCURRENCY     on  TCURRENCY.BillingDocument     = billingitem.BillingDocument
  //                                                                        and TCURRENCY.BillingDocumentItem = billingitem.BillingDocumentItem
  //                                                                        and TCURRENCY.ConditionType       = 'ZPAC'


  //  END  //GST Details
  //Total Tax
  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as Total         on  Total.BillingDocument = billingitem.BillingDocument


  //64
  // association [0..1] to  I_FrtCostAllocItm as PONo
  // on PONo.SettlmtSourceDoc = billingitem.SalesDocument
  //65
  association [0..1] to I_BillingDocumentPartner       as Vendordetails  on  Vendordetails.BillingDocument = jou_entry.referencedocno
                                                                         and Vendordetails.PartnerFunction = 'U3'

 
  //69
  // association [0..1] to  I_FrtCostAllocItm as Freightexp
  // on Freightexp.SettlmtSourceDoc = billingitem.SalesDocument and
  //    Freightexp.SettlmtSourceDocItem = billingitem.BillingDocumentItem and
  //    Freightexp.FrtCostAllocItemNetAmount >= 0
  //ADDED ON 11.10.2023
  association [0..1] to ZI_PUR_AND_FREIGHT              as FREIGHTEXP     on  FREIGHTEXP.SettlmtSourceDoc          =  jou_entry.salesdocument
                                                                         and FREIGHTEXP.SettlmtSourceDocItem      =  jou_entry.salesdocitem
                                                                         and FREIGHTEXP.FrtCostAllocItemNetAmount >= 0
  //ADDED ON 11.10.2023

  //70
  association [0..1] to ZI_Customer_Details_R1         as Broker         on  Broker.Billiing_Doc = jou_entry.referencedocno

  // 74
  //association [0..1] to  I_JournalEntryItem as GLAcc
  association [0..1] to ZI_JournalEntry                as GLAcc

                                                                         on  GLAcc.BillingDocument = jou_entry.referencedocno
  //                                                                        and GLAcc.PostingKey      = '50'
  //                                                                        and GLAcc.DebitCreditCode = 'H'
  //
  ////75
  //association [0..1] to I_GLAccountTextRawData as GLName
  //on GLName.GLAccount =

  association [1]    to ZGSTR1_ADDITIONAL              as billi_doc_cube on  billi_doc_cube.BillingDocument     = jou_entry.referencedocno
                                                                         and billi_doc_cube.BillingDocumentItem = jou_entry.ReferenceDocumentItem
  //                                                                     and billi_doc_cube.ExchangeRateType = 'M'
  //  and billi_doc_cube.

  association [1]    to I_BillingDocItemPrcgElmntBasic as amortisation   on  amortisation.BillingDocument     = jou_entry.referencedocno
                                                                         and amortisation.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and amortisation.ConditionType       = 'ZAMO'

  association [1]    to I_BillingDocItemPrcgElmntBasic as roundoffvalue  on  roundoffvalue.BillingDocument     = jou_entry.referencedocno
                                                                         and roundoffvalue.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and roundoffvalue.ConditionType       = 'DRD1'


  association [0..1] to ZI_TRANS_DETAILS               as Trans          on  Trans.BillingDocument = jou_entry.referencedocno
                                                                         and Trans.PartnerFunction = 'U3'

  //association [0..1] to ZF4HELP_TEST as F4HELP on billingitem.BillingDocumentType = F4HELP.BILLING_TYPE
  association [0..1] to Z_I_BILLING_F4HELP             as _HELP          on  $projection.Billing_Type = _HELP.BillingDocumentType
  association [0..1] to Z_I_DIVISION_VH                as _DIV_HELP      on  $projection.Billing_Type = _DIV_HELP.Division

  //  association [1] to I_OperationalAcctgDocItem as FIdocs on FIdocs.AccountingDocumentType = 'DR'
  //                                                            and FIdocs.AccountingDocumentItemType <> 'T'
  //                                                            and FIdocs.FinancialAccountType = 'S'   

  //  association [1] to ZI_FI_JOURNAL_ENTRY as DFI on  ( DFI.AccountingDocumentType = 'DR'
  //                                                or DFI.AccountingDocumentType = 'DG' )


  //  association [0..1] to ZI_JOURNALENTRYITEM1 as comp_code_curr on comp_code_curr.

  //  association [1]    to I_OperationalAcctgDocItem      as Acctgdoc       on  jou_entry.AccountingDocument  = Acctgdoc.AccountingDocument
  //  //  and Acctgdoc.BusinessPlace <> ''
  //                                                                         and Acctgdoc.FinancialAccountType = 'K'
  //
  //  association [1]    to I_OperationalAcctgDocItem      as ProfitCenter   on  jou_entry.AccountingDocument =  ProfitCenter.AccountingDocument
  //                                                                         and ProfitCenter.ProfitCenter    <> ''

  association [1]    to I_OperationalAcctgDocItem      as Cgst_gl        on  jou_entry.AccountingDocument         = Cgst_gl.AccountingDocument
                                                                         and jou_entry.BaseAmount                 = Cgst_gl.TaxBaseAmountInCoCodeCrcy
//                                                                         and jou_entry.AccountingDocumentItem     = Cgst_gl.AccountingDocumentItem
                                                                         and Cgst_gl.AccountingDocumentItemType   = 'T'
                                                                         and Cgst_gl.TransactionTypeDetermination = 'JOC'

  association [1]    to I_OperationalAcctgDocItem      as sgst_gl        on  jou_entry.AccountingDocument         = sgst_gl.AccountingDocument
                                                                         and jou_entry.BaseAmount                     = sgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                         and sgst_gl.AccountingDocumentItemType   = 'T'
                                                                         and sgst_gl.TransactionTypeDetermination = 'JOS'

  association [1]    to I_OperationalAcctgDocItem      as igst_gl        on  jou_entry.AccountingDocument         = igst_gl.AccountingDocument
                                                                         and jou_entry.amcomp                     = igst_gl.TaxBaseAmountInCoCodeCrcy
                                                                         and igst_gl.AccountingDocumentItemType   = 'T'
                                                                         and igst_gl.TransactionTypeDetermination = 'JOI'

  //IS Tax Code
  //  association [1]    to I_OperationalAcctgDocItem      as igst_glis      on  jou_entry.AccountingDocument         = igst_glis.AccountingDocument
  //                                                                         and jou_entry.amcomp                     = igst_glis.TaxBaseAmountInCoCodeCrcy
  //                                                                         and igst_glis.AccountingDocumentItemType = 'T'
  //                                                                         and (
  //                                                                            igst_glis.AccountingDocumentItem      = '003'
  //                                                                            //                                                              or igst_glis.AccountingDocumentItem = '004'
  //                                                                            or igst_glis.AccountingDocumentItem   = '005'
  //                                                                            //                                                              or igst_glis.AccountingDocumentItem = '006'
  //                                                                            or igst_glis.AccountingDocumentItem   = '007'
  //                                                                            //                                                              or igst_glis.AccountingDocumentItem = '008'
  //                                                                            or igst_glis.AccountingDocumentItem   = '009'
  //                                                                          )

  //  association [1]    to I_OperationalAcctgDocItem      as RCM_Cgst_gl    on  jou_entry.AccountingDocument             = RCM_Cgst_gl.AccountingDocument
  //  //  and JournalItem.amcomp = RCM_Cgst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                         and RCM_Cgst_gl.AccountingDocumentItemType   = 'T'
  //                                                                         and RCM_Cgst_gl.TransactionTypeDetermination = 'JRC'
  //  association [1]    to I_OperationalAcctgDocItem      as RCM_sgst_gl    on  jou_entry.AccountingDocument             = RCM_sgst_gl.AccountingDocument
  //  //   and JournalItem.amcomp = RCM_sgst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                         and RCM_sgst_gl.AccountingDocumentItemType   = 'T'
  //                                                                         and RCM_sgst_gl.TransactionTypeDetermination = 'JRS'
  //  association [1]    to I_OperationalAcctgDocItem      as RCM_igst_gl    on  jou_entry.AccountingDocument             = RCM_igst_gl.AccountingDocument
  //  //   and JournalItem.amcomp = RCM_igst_gl.TaxBaseAmountInCoCodeCrcy
  //                                                                         and RCM_igst_gl.AccountingDocumentItemType   = 'T'
  //                                                                         and RCM_igst_gl.TransactionTypeDetermination = 'JRI'


  //  association [1]    to I_JournalEntryItem             as jei            on  jou_entry.AccountingDocument = jei.AccountAssignment

  //  association [1]    to I_OperationalAcctgDocItem      as baseamount     on  jou_entry.AccountingDocument            = baseamount.AccountingDocument
  //                                                                         and baseamount.AccountingDocumentItemType   = 'T'
  ////                                                                         and jou_entry.product = baseamount.Product
  //                                                                         and baseamount.TransactionTypeDetermination = 'JOC'

  // association [1] to I_OperationalAcctgDocItem as cgst_amount on jou_entry.AccountingDocument = cgst_amount.AccountingDocument
  //                                                             and jou_entry.amcomp = cgst_amount.AmountInCompanyCodeCurrency
  //                                                             and cgst_amount.AccountingDocumentItemType = 'T'
  //                                                             and cgst_amount.TransactionTypeDetermination = 'JOC'
  //
  // association [1] to I_OperationalAcctgDocItem as sgst_amount on jou_entry.AccountingDocument = sgst_amount.AccountingDocument
  //                                                             and jou_entry.amcomp = sgst_amount.AmountInCompanyCodeCurrency
  //                                                             and sgst_amount.AccountingDocumentItemType = 'T'
  //                                                             and sgst_amount.TransactionTypeDetermination = 'JOS'
  //
  // association [1] to I_OperationalAcctgDocItem as igst_amount on jou_entry.AccountingDocument = igst_amount.AccountingDocument
  //                                                             and jou_entry.amcomp = igst_amount.AmountInCompanyCodeCurrency
  //                                                             and igst_amount.AccountingDocumentItemType = 'T'
  //                                                             and igst_amount.TransactionTypeDetermination = 'JOI'

  association [1]    to I_Customer                     as cust           on  jou_entry.customer_name_ = cust.Customer

{

      @Consumption.valueHelpDefinition: [{entity: {element: 'Billing_Doc_No' , name: 'Z_I_BILLING_F4HELP'}}]

  key BillItem.BillingDocument                                                                                                                         as Billing_Doc_No,

      //  ltrim(billingitem.BillingDocument,'0')                                               as Billing_Doc_No, //1
      //  case when billingitem.BillingDocument is initial and FIdocs.AccountingDocument is not initial then
      //  FIdocs.AccountingDocument else
      //  case when billingitem.BillingDocument is not initial and FIdocs.AccountingDocument is initial then

      //  case when BillItem.BillingDocumentItem is not initial then
      //   ltrim(BillItem.BillingDocumentItem,'0')
      //   when jou_entry.ReferenceDocumentItem is not initial then
      //   jou_entry.ReferenceDocumentItem end as Item_No, //33


  key ltrim(jou_entry.itemno,'0')                                                                                                                      as Item_No,


      //      case when BillItem.BillingDocumentItem is not initial then
      //      ltrim(BillItem.BillingDocumentItem,'0')
      //      when jou_entry.ReferenceDocumentItem is not initial then
      //      ltrim(jou_entry.ReferenceDocumentItem,'0')
      //      end as Item_No,
      // key ltrim(BillItem.BillingDocumentItem,'0') as Item_No,
      // key ltrim(jou_entry.ReferenceDocumentItem,'0') as Item_No,
      //  case when  FIdocs.AccountingDocument is not initial and FIdocs.AccountingDocumentType = 'DR' then //BillingHeader.AccountingDocument is initial and
      //   FIdocs.AccountingDocument else
      // case when BillingHeader.AccountingDocument is not initial and  billingitem.BillingDocument is not initial then //and FIdocs.AccountingDocument is initial
      //   BillItem.AccountingDocument
      //   case when  FIdocs.AccountingDocument is not initial and billingitem.BillingDocument is initial then
      //   FIdocs.AccountingDocument
  key jou_entry.originalrefdocno                        as GST_Invoice_No,

      jou_entry.AccountingDocument                                                                                                                     as Accounting_Doc_No, //8


      //  case when FIdocs.BillingDocument is initial and FIdocs.AccountingDocument is not initial then
      //  FIdocs.AccountingDocument end as DPAccdocno,
      //  case when BillingHeader.AccountingDocument is not initial and BillingHeader.BillingDocument is initial then
      //  BillingHeader.AccountingDocument end as DPBillingdocno,
      jou_entry.trasns_curreency,
      jou_entry.transactioncurrency,
      jou_entry.amcomp,
      Cgst_gl.AmountInCompanyCodeCurrency,
      // billingitem.i
      case when jou_entry.materialgroup is not initial then
      jou_entry.materialgroup
      when BillItem.MaterialGroup is not initial then
      BillItem.MaterialGroup   end                                                                                                                     as Material_Group,

      jou_entry.FiscalYear                                                                                                                             as Fiscal_Year,
      //  jou_entry.AccountingExchangeRate                                                    as Exchange_Rate,

      case when jou_entry.accdoctype is not initial then
      jou_entry.accdoctype
      when BillItem.BillingDocumentType is not initial then
      BillItem.BillingDocumentType     end                                                                                                             as Doc_type,
      // BillingHeader.
      // BillingHeader.
      //  Delivery.ShipToParty as Ship_to_party,
      //FIdocs.AccountingDocument   as FIDoc,
      //FIdocs.AccountingDocumentType as FIDoctype,
      //      case when jou_entry.Ewaybillnumber is not initial then
      //      jou_entry.Ewaybillnumber
      //      when irn.IN_EDocEInvcEWbillNmbr is not initial then
      //      irn.IN_EDocEInvcEWbillNmbr    end                                                                                                                as Ewaybill_no,
      case when irn.IN_EDocEInvcEWbillNmbr is not initial then
      irn.IN_EDocEInvcEWbillNmbr
      when irn_bill.IN_EDocEInvcEWbillNmbr is not initial then
      irn_bill.IN_EDocEInvcEWbillNmbr
      end                                                                                                                                              as Ewaybill_no,
      case when irn.IN_EDocEInvcEWbillCreateDate is not initial then
      irn.IN_EDocEInvcEWbillCreateDate
      when irn_bill.IN_EDocEInvcEWbillCreateDate is not initial then
      irn_bill.IN_EDocEInvcEWbillCreateDate
      end                                                                                                                                              as Ewaybill_Date,
      case when irn.IN_EDocEWbillStatus is not initial then
      irn.IN_EDocEWbillStatus
      when irn_bill.IN_EDocEWbillStatus is not initial then
      irn_bill.IN_EDocEWbillStatus
      end                                                                                                                                              as Ewaybill_Status,
      case when irn.IN_ElectronicDocAcknNmbr is not initial then
      irn.IN_ElectronicDocAcknNmbr
      when irn_bill.IN_ElectronicDocAcknNmbr is not initial then
      irn_bill.IN_ElectronicDocAcknNmbr
      end                                                                                                                                              as Ack_num,
      case when irn.IN_ElectronicDocAcknDate is not initial then
      irn.IN_ElectronicDocAcknDate
      when irn_bill.IN_ElectronicDocAcknDate is not initial then
      irn_bill.IN_ElectronicDocAcknDate
      end                                                                                                                                              as Ack_date,
      case when irn.IN_ElectronicDocCancelDate is not initial then
      irn.IN_ElectronicDocCancelDate
      when irn_bill.IN_ElectronicDocCancelDate is not initial then
      irn_bill.IN_ElectronicDocCancelDate
      end                                                                                                                                              as Einv_Canceldate,
      case when irn.IN_EDocCancelRemarksTxt is not initial then
      irn.IN_EDocCancelRemarksTxt
      when irn_bill.IN_EDocCancelRemarksTxt is not initial then
      irn_bill.IN_EDocCancelRemarksTxt
      end                                                                                                                                              as Einv_CancelReason,
      case when irn.ElectronicDocProcessStatus is not initial then
      irn.ElectronicDocProcessStatus
      when irn_bill.ElectronicDocProcessStatus is not initial then
      irn_bill.ElectronicDocProcessStatus
      end                                                                                                                                              as Einv_Status,
      case when irn.ElectronicDocCountry is not initial then
      irn.ElectronicDocCountry
      when irn_bill.ElectronicDocCountry is not initial then
      irn_bill.ElectronicDocCountry
      end                                                                                                                                              as Einv_City,
      case when irn.ElectronicDocType is not initial then
      irn.ElectronicDocType
      when irn_bill.ElectronicDocType is not initial then
      irn_bill.ElectronicDocType
      end                                                                                                                                              as Einv_type,
      case when irn.IN_ElectronicDocInvcRefNmbr is not initial then
      irn.IN_ElectronicDocInvcRefNmbr
      when irn_bill.IN_ElectronicDocInvcRefNmbr is not initial then
      irn_bill.IN_ElectronicDocInvcRefNmbr
      end                                                                                                                                              as IRN,
      //      case when jou_entry.Ewaybilldate is not initial then
      //      jou_entry.Ewaybilldate
      //      when irn.IN_EDocEInvcEWbillCreateDate is not initial then
      //      irn.IN_EDocEInvcEWbillCreateDate        end                                                                                                      as Ewaybill_Date,
      //
      //      case when jou_entry.Ewaybillstatus is not initial then
      //      jou_entry.Ewaybillstatus
      //      when irn.IN_EDocEWbillStatus is not initial then
      //      irn.IN_EDocEWbillStatus     end                                                                                                                     as Ewaybill_Status,
      //
      //      case when jou_entry.Acknum is not initial then
      //      jou_entry.Acknum
      //      when irn.IN_ElectronicDocAcknNmbr is not initial then
      //      irn.IN_ElectronicDocAcknNmbr     end                                                                                                                as Ack_num,
      //
      //      case when jou_entry.Ackdate is not initial then
      //      jou_entry.Ackdate
      //      when irn.IN_ElectronicDocAcknDate is not initial then
      //      irn.IN_ElectronicDocAcknDate    end                                                                                                                 as Ack_date,
      //      //irn.IN_EDocEInvcBusinessPlace                                 as Bussiness_area,
      //
      //      case when jou_entry.Einvcanceldate is not initial then
      //      jou_entry.Einvcanceldate
      //      when irn.IN_ElectronicDocCancelDate is not initial then
      //      irn.IN_ElectronicDocCancelDate      end                                                                                                             as Einv_Canceldate,
      //
      //      case when jou_entry.EinvcancelReason is not initial then
      //      jou_entry.EinvcancelReason
      //      when irn.IN_EDocCancelRemarksTxt is not initial then
      //      irn.IN_EDocCancelRemarksTxt   end                                                                                                                    as Einv_CancelReason,
      //
      //      case when jou_entry.Einvstatus is not initial then
      //      jou_entry.Einvstatus
      //      when irn.ElectronicDocProcessStatus is not initial then
      //      irn.ElectronicDocProcessStatus   end                                                                                                                as Einv_Status,
      //
      //      case when jou_entry.Einvcity is not initial then
      //      jou_entry.Einvcity
      //      when irn.ElectronicDocCountry is not initial then
      //      irn.ElectronicDocCountry    end                                                                                                                     as Einv_City,
      //
      //      case when jou_entry.Einvtype is not initial then
      //      jou_entry.Einvtype
      //      when irn.ElectronicDocType is not initial then
      //      irn.ElectronicDocType   end                                                                                                                         as Einv_type,
      //
      //      case when jou_entry.IRN is not initial then
      //      jou_entry.IRN
      //      when irn.IN_ElectronicDocInvcRefNmbr is not initial then
      //      irn.IN_ElectronicDocInvcRefNmbr    end                                                                                                              as IRN,

      //      case when GLAcc.GLAccount is not initial then
      //      GLAcc.GLAccount
      //      when jou_entry.gl_account is not initial then
      //      jou_entry.gl_account            end as GL_Code,
      jou_entry.gl_account                                                                                                                             as GL_Code,
      jou_entry.GLDesc                                                                                                                                 as GLDesc, //(+)by Anurag on 23.05.2024

      //      case when GLAcc.IsReversal is not initial then
      //      GLAcc.IsReversal
      //      when jou_entry.is_reversal is not initial then
      //      jou_entry.is_reversal  end    as Is_Reversal,

      jou_entry.is_reversed                                                                                                                            as Is_Reversal,

      //      case when GLAcc.ReversalReferenceDocument is not initial then
      //      GLAcc.ReversalReferenceDocument
      //      when jou_entry.reversedocument is not initial then
      //      jou_entry.reversedocument end as Reverse_doc,
      jou_entry.reversedocument                                                                                                                        as Reverse_doc,
      //      jou_entry.CompanyCodeCurrency                                                               as comp_code_curr,

      case when BillItem.Plant is not initial then
      BillItem.Plant
      when jou_entry.plant is not initial then
      jou_entry.plant end                                                                                                                              as Bussiness_area,

      //newly added
      billi_doc_cube.AccountingExchangeRate                                                                                                            as AccountingExchangeRate,
      billi_doc_cube.Product                                                                                                                           as Product,
      //  billi_doc_cube.BillingDocumentItem as BillingDocumentItem,
      //  billi_doc_cube.BillingDocument as BillingDocument,

      case when billi_doc_cube.ShipToParty is not initial then
      billi_doc_cube.ShipToParty
      when jou_entry.shiptoparty is not initial then
      jou_entry.shiptoparty  end                                                                                                                       as ShipToParty,

      billi_doc_cube.ShipToPartyName                                                                                                                   as ShipToPartyName,
      billi_doc_cube.BillToParty                                                                                                                       as BillToParty,
      billi_doc_cube.BillToPartyName                                                                                                                   as BillToPartyName,
      billi_doc_cube.BillToPartyRegion                                                                                                                 as BillToPartyRegion,
      billi_doc_cube.BillToPartyCountry                                                                                                                as BillToPartyCountry,
      amortisation.ConditionAmount                                                                                                                     as amortisation,
      //      amortisation.conditionb
      roundoffvalue.ConditionAmount                                                                                                                    as roundoffval,






      //  billi_doc_cube.ShipToParty as ShipToParty,
      //  billi_doc_cube.ShipToPartyName as ShipToPartyName,
      //  billi_doc_cube.BillToParty as BillToParty,
      //  billi_doc_cube.BillToPartyName as BillToPartyName,
      //  billi_doc_cube.BillToPartyRegion as BillToPartyRegion,
      //  billi_doc_cube.BillToPartyCountry as BillToPartyCountry,
      //billi_prcg_bsic.r


      // @Semantics.calendar.yearMonth: true
      //  cast( cast( billingitem.BillingDocumentDate  as abap.char(12)) as abap.dats)          as billingdate,         //2
      //// cast(
      ////      concat(
      ////        concat(
      ////          concat(substring(billingitem.BillingDocumentDate, 7, 2), '.' ),
      ////          concat(substring(billingitem.BillingDocumentDate, 5, 2), '.' )
      ////        ),
      ////        substring(billingitem.BillingDocumentDate, 1, 4)
      ////      )
      ////    as char10 preserving type) as Billing_date,


      //  case when BillItem.BillingDocument is initial then
      ////  and jou_entry.AccountingDocument is not initial then
      //  jou_entry.DocumentDate else
      //  BillItem.BillingDocumentDate                                                      end   as Billing_date,

      case when BillItem.BillingDocumentDate is not initial then
      BillItem.BillingDocumentDate
      when jou_entry.DocumentDate is not initial then
      jou_entry.DocumentDate         end                                                                                                               as Billing_date,

      jou_entry.PostingDate                                                                                                                            as posting_date,

      BillItem.BillingDocumentType                                                                                                                     as Billing_Type, //3
      //billingitem.SalesDocument as Sales_Doc,
      //  BillingHeader.AccountingPostingStatus as posting_status,
      //  BillingHeader.BillingDocumentIsCancelled as cancelled,
      documenttype.BillingDocumentTypeName                                                                                                             as Billing_Description, //4
      ltrim(PrecInv.SubsequentDocument,'0')                                                                                                            as Preceding_Invoice_No,
      case PrecInv.CreationDate

      when '0000-00-00' then ' '
      else
      //  PrecInv.CreationDate as Preceding_Invoice_date,
      cast(
          concat(
            concat(
              concat(substring(PrecInv.CreationDate, 7, 2), '.' ),
              concat(substring(PrecInv.CreationDate, 5, 2), '.' )
            ),
            substring(PrecInv.CreationDate, 1, 4)
          )
        as char10 preserving type) end                                                                                                                 as Preceding_Invoice_date,


      //  itemflow.SalesOrder      as Preceding_Invoice_No,         //5
      //  billingitem.BillingDocumentDate           as billingDocumentDate,         //6


//      case when BillingHeader.DocumentReferenceID is not initial then
//      BillingHeader.DocumentReferenceID
//      when jou_entry.originalrefdocno is not initial then
//      jou_entry.originalrefdocno    end                                                                                                                as GST_Invoice_No, //7


      //BillingHeader.



      case when jou_entry.Distributionchannel is not initial then
      jou_entry.Distributionchannel
      when BillItem.SalesOrderDistributionChannel is not initial then
      BillItem.SalesOrderDistributionChannel end                                                                                                       as Distribution_Channel, //9

      Distchannel.DistributionChannelName                                                                                                              as Dist_Channel_Desc, //10
      BillItem.Division                                                                                                                                as Division, //11
      //  Division.DivisionName                                                                   as Division_Desc, //12
      BillItem.SalesOrderCustomerPriceGroup                                                                                                            as Price_Group,
      BillItem.CustomerGroup                                                                                                                           as Customer_Group, //16
      //  Custgrp.AdditionalCustomerGroup1Name                                                    as Customer_Group_Desc,

      ltrim(BillingHeader.PayerParty,'0')                                                                                                              as Customer_No, //17

      //status.status                             as zgstr1_st,
      status.status                                                                                                                                    as status,


      //case billingitem.BillingQuantity not null

      //  key ltrim(billingitem.BillingDocumentItem,'0')                                              as Item_No, //33
      ltrim(BillItem.Product,'0')                                                                                                                      as Material_COde, //34
      BillItem.BillingDocumentItemText                                                                                                                 as Material_Description, //35

      case when customer.Customer is not initial then
      customer.Customer
      when jou_entry.Customer is not initial then
      jou_entry.Customer end                                                                                                                           as customer_number,


      case when customer.CustomerName is not initial then
      customer.CustomerName
      when jou_entry.custo_name is not initial then
      jou_entry.custo_name    end                                                                                                                      as Customer_Name, //18

      case when customer.TaxNumber3 is not initial then
      customer.TaxNumber3
      when cust.TaxNumber3 is not initial then
      cust.TaxNumber3 end                                                                                                                              as Customer_GSTIN_No, //19
      //customer.OrganizationBPName1             as Customer_Pan,         //20

      case when customer.Customer_Pan is not initial then
      customer.Customer_Pan   end                                                                                                                      as Customer_Pan,


      customer.TaxNumber2                                                                                                                              as Customer_Tin, //21

      case when customer.Region is not initial then
      customer.Region
      when jou_entry.region is not initial then
      jou_entry.region end                                                                                                                             as Region, //22


      //  ltrim(itemflow1.PrecedingDocument,'0')                                                  as Sales_Contract_No,
      ltrim(BillItem.SalesDocument,'0')                                                                                                                as sales_order_no,
      salesdetails.PurchaseOrderByCustomer                                                                                                             as Customer_PO_No, // 26
      //salesdetails.CustomerPurchaseOrderDate as Customer_PO_Date,  // 27
      cast(
         concat(
           concat(
             concat(substring(salesdetails.CustomerPurchaseOrderDate, 7, 2), '.' ),
             concat(substring(salesdetails.CustomerPurchaseOrderDate, 5, 2), '.' )
           ),
           substring(salesdetails.CustomerPurchaseOrderDate, 1, 4)
         )
       as char10 preserving type)                                                                                                                      as Customer_PO_Date,
      //salesdetails.ReferenceSDDocument                as Sales_Order_No,     // 28

      //  salesdetails.CreationDate                       as Sales_Order_Date,   // 29
      cast(
           concat(
             concat(
               concat(substring(salesdetails.CreationDate, 7, 2), '.' ),
               concat(substring(salesdetails.CreationDate, 5, 2), '.' )
             ),
             substring(salesdetails.CreationDate, 1, 4)
           )
         as char10 preserving type)                                                                                                                    as Sales_Order_Date,
      //  ltrim(salesflow.SubsequentDocument,'0')                    as Delivery_No,        //30
      ltrim(BillItem.ReferenceSDDocument,'0')                                                                                                          as Delivery_No,

      //  cast(
      //   concat(
      //     concat(
      //       concat(substring(Delivery.CreationDate, 7, 2), '.' ),
      //       concat(substring(Delivery.CreationDate, 5, 2), '.' )
      //     ),
      //     substring(Delivery.CreationDate, 1, 4)
      //   )
      //  as char10 preserving type)                                                              as Delivery_Date,
      //  Mattext.AdditionalMaterialGroup1Name                                                 as Material_Group, //32
      
      case when jou_entry.HSN_Code is not initial then
      jou_entry.HSN_Code else
      jou_entry.hsncode end as HSN_Code,
      //  ltrim(batchdetails.Batch,'0')                                                           as Batch_NO, //37
      // batchdetails.ManufactureDate                     as Manufacturing_Date,  //38

      //  cast(
      //     concat(
      //       concat(
      //         concat(substring(batchdetails.ManufactureDate, 7, 2), '.' ),
      //         concat(substring(batchdetails.ManufactureDate, 5, 2), '.' )
      //       ),
      //       substring(batchdetails.ManufactureDate, 1, 4)
      //     )
      //   as char10 preserving type)                                                             as Manufacturing_Date,

      //batchdetails.ShelfLifeExpirationDate            as Expiry_Date,        //39

      //  cast(
      //     concat(
      //       concat(
      //         concat(substring(batchdetails.ShelfLifeExpirationDate, 7, 2), '.' ),
      //         concat(substring(batchdetails.ShelfLifeExpirationDate, 5, 2), '.' )
      //       ),
      //       substring(batchdetails.ShelfLifeExpirationDate, 1, 4)
      //     )
      //   as char10 preserving type)                                                             as Expiry_Date,


      @Semantics.quantity.unitOfMeasure: 'Unit'
      //floor(billingitem.BillingQuantity)                    as Invoice_Qty ,       //40
      BillItem.BillingQuantity                                                                                                                         as Invoice_Qty, //Invoice_Qty ,       //40
      //  @Consumption.hidden: true
      BillItem.BillingQuantityUnit                                                                                                                     as Unit,
      case BillItem.SalesDocumentItemCategory
        when 'TANN' then floor(BillItem.BillingQuantity)
      //  else '000000'
        end                                                                                                                                            as Free_Quantity,

      case BillItem.BillingQuantityUnit
        when 'ZQT' then 'QTL'
        else BillItem.BillingQuantityUnit
        end                                                                                                                                            as UOM,

      cast((Itemprcg.ConditionRateAmount) as abap.dec(15,2))                                                                                           as Unit_Rate, //43
      @DefaultAggregation:#NONE
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      Itemprcg1.ConditionAmount  * -1
      //      else Itemprcg1.ConditionAmount end          as Freight_Amount, //44
      Itemprcg1.ConditionAmount                                                                                                                        as Freight_Amount,

      //  TCURRENCY.TransactionCurrency                                                        as TransactionCurrency,

      //  case Itemprcg1.TransactionCurrency
      //  WHEN 'USD' then 'ERU' else
      //    Itemprcg1.TransactionCurrency


      //      @Semantics.currencyCode: true
      //      @ObjectModel.foreignKey.association: '_Currency'
      //      Itemprcg1.TransactionCurrency                                                                                                                    as TransactionCurrency,
      //      Itemprcg1._Currency,

      GLAcc.CompanyCodeCurrency                                                                                                                        as comp_code_curr,



      case when Itemprcg1.TransactionCurrency <> 'INR' then
      cast(BillItem.TaxAmount as abap.fltp ) + cast( BillItem.NetAmount as abap.fltp ) * cast( BillingHeader.AccountingExchangeRate as abap.fltp ) end as TESTCURRENCY,
      //      cast(BillItem.TaxAmount as abap.fltp ) + cast( BillItem.NetAmount as abap.fltp ) * cast( jou_entry.absoexchrate as abap.fltp ) end as TESTCURRENCY,

      //  @Semantics.amount.currencyCode: 'TransactionCurrency'
      //    currency_conversion( amount => Itemprcg.ConditionRateAmount,
      //                         source_currency => cast(Itemprcg1.TransactionCurrency as abap.cuky),
      //                         target_currency => cast('INR' as abap.cuky),
      //                         exchange_rate_date => billingitem.BillingDocumentDate ) as TransactionCurrencytest,

      //case when Itemprcg1.TransactionCurrency = 'USD' then
      //cast( Itemprcg1.TransactionCurrency as abap.fltp ) * cast( BillingHeader.AccountingExchangeRate as abap.cuky( 16 ))  as TransactionCurrencytest,

      //case when Itemprcg1.TransactionCurrency = 'USD' then
      //cast( Itemprcg1.TransactionCurrency as abap.fltp ) * cast( BillingHeader.AccountingExchangeRate as abap.cuky( 16 ))  as TransactionCurrencytest,


      Itemprcg.ConditionAmount                                                                                                                         as Insurance_Amount, //45 needs to be comment
      Itemprcg.ConditionAmount                                                                                                                         as Packaging_Cost, //46  needs to be comment
      //Itemprcg1.
      //BillingHeader.
      //

      @Semantics.amount.currencyCode: 'comp_code_curr' //TransactionCurrency >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2'  then
      //      cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity * -1 ) as abap.dec( 16, 2 )) else

      //      case when baseamount.TaxBaseAmountInCoCodeCrcy is not initial then
      //     abs( cast((baseamount.TaxBaseAmountInCoCodeCrcy) as abap.dec( 16, 2 )) ) else

      //      case when jou_entry.BaseAmount is not initial then
      //      cast((jou_entry.BaseAmount) as abap.dec( 16, 2 )) else

      //      case when jou_entry.amcomp is not initial and amortisation.ConditionAmount is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      case when jou_entry.amcomp is not initial then
      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      //      case when jou_entry.amcomp is not initial and amortisation.ConditionAmount is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      //      case when Itemprcg1.TransactionCurrency <> 'INR' and amortisation.ConditionAmount is not initial then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      //      case when Itemprcg1.TransactionCurrency = 'INR' and amortisation.ConditionAmount is not initial then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      case when Itemprcg1.TransactionCurrency <> 'INR' then
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) else
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(jou_entry.absoexchrate as abap.dec( 16, 2 ))) else
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )))
       end end                                                                                                                                         as Basic_Amount,

      //   case when BillingHeader.BillingDocumentType = 'G2'  then
      //   cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity * -1 ) as abap.dec( 16, 2 ))
      //   when Itemprcg1.TransactionCurrency <> 'INR' then
      //   cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 ))
      //   * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 )) else
      //   cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 ))
      //   case
      cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 ))                                                             as Basic_Amount_test,

      // billingitem.NetAmount                                                                   as Taxable_Value_In_RS, //48
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      cast((BillItem.NetAmount * -1) as abap.dec( 16, 2 )) else

      //      case when BillItem.NetAmount is not initial then
      //      abs(cast((BillItem.NetAmount) as abap.dec( 16, 2 ))) else
      //
      //      case when jou_entry.amcomp is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else
      //
      ////      case when jou_entry.BaseAmount is not initial then
      ////      cast((jou_entry.BaseAmount) as abap.dec( 16, 2 )) else
      //
      ////      case when jou_entry.transactioncurrency <> 'INR' and jou_entry.BaseAmount is not initial then
      ////      cast(( jou_entry.BaseAmount * jou_entry.absoexchrate ) as abap.dec( 16, 2 )) else
      //
      //      case when Itemprcg1.TransactionCurrency <> 'INR' and Itemprcg.ConditionRateAmount is not initial
      //      and BillItem.BillingQuantity is not initial and BillingHeader.AccountingExchangeRate is not initial then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) *
      //      cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 )))
      //      end end end   as Taxable_Value_In_RS,

      case when jou_entry.amcomp is not initial and amortisation.ConditionAmount is not initial then
      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) +
      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      case when jou_entry.amcomp is not initial then
      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      case when Itemprcg1.TransactionCurrency <> 'INR' and amortisation.ConditionAmount is not initial then
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(jou_entry.absoexchrate as abap.dec( 16, 2 ))) +
      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      case when Itemprcg1.TransactionCurrency = 'INR' and amortisation.ConditionAmount is not initial then
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(jou_entry.absoexchrate as abap.dec( 16, 2 ))) +
      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      case when Itemprcg1.TransactionCurrency <> 'INR' then
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) else
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(jou_entry.absoexchrate as abap.dec( 16, 2 ))) else
      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )))
      end end end end end                                                                                                                              as Taxable_Value_In_RS,


      //  case when jou_entry.referencedocno is initial and jou_entry.AccountingDocument is not initial then

      case when CGSTdetails.ConditionRateValue is not initial
      then
      cast((CGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.CGST_PERC is not initial
      then
      fltp_to_dec (jou_entry.CGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as CGST_RATE,

      case when SGSTdetails.ConditionRateValue is not initial
      then
      cast((SGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.SGST_PERC is not initial
      then
      fltp_to_dec (jou_entry.SGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as SGST_Rate, //52

      case when IGSTdetails.ConditionRateValue is not initial
      then
      cast((IGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.IGST_PERC is not initial then
      fltp_to_dec (jou_entry.IGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as IGST_Rate, //54


      //    case when BillItem.BillingDocument is initial and jou_entry.AccountingDocument is not initial
      //    and BillItem.BillingDocumentItem is initial then
      //    jou_entry.CGST
      //
      //     when BillingHeader.BillingDocumentType = 'G2' and
      //    BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is not initial then
      //    CGSTdetails.ConditionAmount * -1
      //
      //     when BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is not initial then
      //    CGSTdetails.ConditionAmount  end as CGST,


      //     case when cgst_amount.AmountInCompanyCodeCurrency is not initial then
      //     cgst_amount.AmountInCompanyCodeCurrency end as CGST,
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      CGSTdetails.ConditionAmount * -1 else
      //      case when CGSTdetails.ConditionAmount is not initial then
      //      cast((CGSTdetails.ConditionAmount) as abap.dec( 16, 2 )) else
      //      case when Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and ( Cgst_gl.AccountingDocumentType = 'DR' or jou_entry.AccountingDocumentType = 'DG' ) then
      //      Cgst_gl.AmountInCompanyCodeCurrency end end end as cgst,
      // case when BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is
      //      fltp_to_dec (jou_entry.CGST as abap.dec( 16, 2 ) ) end

      //     case when BillItem.BillingDocument is initial and jou_entry.AccountingDocument is not initial then
      //      case when ( jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG') then
      //      abs(Cgst_gl.AmountInCompanyCodeCurrency)  else
      //     case when BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is not initial then
      //     abs(cast((CGSTdetails.ConditionAmount) as abap.dec( 16, 2 ))) else



      //      case when jou_entry.is_reversed = 'X' and jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial
      //      and CGSTdetails.ConditionAmount is not initial and CGSTdetails.ConditionAmount < 0 then
      //      CGSTdetails.ConditionAmount  * -1
      //      else
      //
      //      case when jou_entry.is_reversal = 'X' and jou_entry.is_reversed = ''
      //     and jou_entry.reversedocument is not initial and
      //     CGSTdetails.ConditionAmount is not initial and CGSTdetails.ConditionAmount > 0   then
      //     CGSTdetails.ConditionAmount

      //      case when  jou_entry.reversedocument is initial and CGSTdetails.ConditionAmount is not initial then
      //       abs( CGSTdetails.ConditionAmount )
      //       else
      //
      //       case when CGSTdetails.ConditionAmount is not initial then
      //        abs(cast((CGSTdetails.ConditionAmount) as abap.dec( 16, 2 )))
      //       end end end
      //      end end as CGST,

      //    *****CGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      then
      abs(Cgst_gl.AmountInCompanyCodeCurrency) else
      
      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      then
      abs(cast((CGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' then
      abs(CGSTdetails.ConditionAmount) end end end                                                                                                    as CGST,
      //cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )))




      //Cgst_gl.AmountInCompanyCodeCurrency as CGST,

      //      case when  GLAcc.IsReversal is not initial then
      //      cast((CGSTdetails.ConditionAmount) as abap.dec( 16, 2 ))  end  end end end as CGST,

      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      SGSTdetails.ConditionAmount * -1 else
      //      case when SGSTdetails.ConditionAmount is not initial then
      //      cast((SGSTdetails.ConditionAmount) as abap.dec( 16, 2 )) else
      //      case when sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and ( sgst_gl.AccountingDocumentType = 'DR' or jou_entry.AccountingDocumentType = 'DG' ) then
      //      sgst_gl.AmountInCompanyCodeCurrency end   end end   as sgst,
      //      sgst_gl.AmountInCompanyCodeCurrency as sgst,

      //      case when BillItem.BillingDocument is initial and jou_entry.AccountingDocument is not initial then
      //      case when ( jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG') then
      //      abs(sgst_gl.AmountInCompanyCodeCurrency)  else
      //      case when BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is not initial then
      //      abs(cast((SGSTdetails.ConditionAmount) as abap.dec( 16, 2 ))) else
      //      case when jou_entry.is_reversal = 'YES' and jou_entry.reversedocument is not initial then
      //     abs( sgst_gl.AmountInCompanyCodeCurrency ) else
      //      case when jou_entry.is_reversal = 'NO' and jou_entry.reversedocument is not initial then
      //      Cgst_gl.AmountInCompanyCodeCurrency else
      //      case when  GLAcc.IsReversal is not initial then
      //      cast((SGSTdetails.ConditionAmount) as abap.dec( 16, 2 )) end end end end end  as SGST,
      //      abs(sgst_gl.AmountInCompanyCodeCurrency) end end as SGST,

      //        case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and
      //     Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //     abs( sgst_gl.AmountInCompanyCodeCurrency ) else
      //      case when jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial
      //      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      sgst_gl.AmountInCompanyCodeCurrency  else
      //      case when  jou_entry.reversedocument is initial then
      //       abs( sgst_gl.AmountInCompanyCodeCurrency ) end end end as SGST,

      //         case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and
      //     sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      sgst_gl.AmountInCompanyCodeCurrency  else
      //      case when jou_entry.is_reversed = 'X' and jou_entry.reversedocument is not initial
      //      and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      sgst_gl.AmountInCompanyCodeCurrency  else
      //      case when  jou_entry.reversedocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //       abs( sgst_gl.AmountInCompanyCodeCurrency ) else
      //       case when SGSTdetails.ConditionAmount is not initial then
      //        abs(cast((SGSTdetails.ConditionAmount) as abap.dec( 16, 2 )))
      //        end end end end as SGST,


      //    *****SGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      then
      abs(sgst_gl.AmountInCompanyCodeCurrency) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      then
      abs(cast((SGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' then
      abs(SGSTdetails.ConditionAmount) end end end                                                                                                     as SGST,

      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      IGSTdetails.ConditionAmount * -1 else
      //      case when IGSTdetails.ConditionAmount is not initial then
      //      cast((IGSTdetails.ConditionAmount) as abap.dec( 16, 2 )) else
      //      case when igst_gl.AmountInCompanyCodeCurrency is not initial
      //      and ( igst_gl.AccountingDocumentType = 'DR' or jou_entry.AccountingDocumentType = 'DG' ) then
      //      igst_gl.AmountInCompanyCodeCurrency end end end as igst,
      //      igst_gl.AmountInCompanyCodeCurrency as igst,
      //      fltp_to_dec (jou_entry.IGST as abap.dec( 16, 2 ) ) end

      //      case when BillItem.BillingDocument is initial and jou_entry.AccountingDocument is not initial then
      //      case when ( jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG') then
      //      abs(igst_gl.AmountInCompanyCodeCurrency)  else
      //      case when BillItem.BillingDocument is not initial and jou_entry.AccountingDocument is not initial then
      ////      abs(cast((IGSTdetails.ConditionAmount) as abap.dec( 16, 2 ))) end end as IGST,
      //      abs(igst_gl.AmountInCompanyCodeCurrency) end end as IGST,
      //        case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial then
      //     abs( igst_gl.AmountInCompanyCodeCurrency ) else
      //      case when jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency  else
      //      case when  jou_entry.reversedocument is initial then
      //       abs( igst_gl.AmountInCompanyCodeCurrency )  end end end as IGST,

      //case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and
      //     igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency  else
      //      case when jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial
      //      and igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency  else
      //      case when  jou_entry.reversedocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial then
      //       abs( igst_gl.AmountInCompanyCodeCurrency ) else
      //       case when IGSTdetails.ConditionAmount is not initial then
      //        abs(cast((IGSTdetails.ConditionAmount) as abap.dec( 16, 2 )))
      //        end end end end as IGST,


      //      *****IGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' then
      abs(igst_gl.AmountInCompanyCodeCurrency) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.trasns_curreency <> 'INR' then
      abs(cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else

      //      case when jou_entry.accdoctype = 'RV' then
      //    IGSTdetails.ConditionAmount
      //    abs(igst_gl.AmountInCompanyCodeCurrency) end end end as IGST, (-)by Anurag on 23.05.2024
      abs(IGSTdetails.ConditionAmount) end end                                                                                                         as IGST, //(+)by Anurag on 23.05.2024

      //      baseamount.TaxBaseAmountInCoCodeCrcy                                                                                                             as base,


      //    case when jou_entry.referencedocno is initial
      //    and jou_entry.AccountingDocument is not initial
      //    and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //    ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp)) else
      ////    ceil(cast(jou_entry.SGST as abap.fltp)) else
      //    case when BillingHeader.BillingDocumentType = 'G2' then
      //    CGSTdetails.ConditionAmount * -1 else                                                  //as CGST, //51
      //    CGSTdetails.ConditionAmount  end   end                                                       as CGST, //51

      //  cast((SGSTdetails.ConditionRateValue) as abap.dec(5,2))                                 as SGST_Rate, //52

      //    case when jou_entry.referencedocno is initial and jou_entry.AccountingDocument is not initial then
      //    ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp)) else
      ////    ceil(cast(jou_entry.CGST as abap.fltp)) else
      //    case when BillingHeader.BillingDocumentType = 'G2' then
      //    SGSTdetails.ConditionAmount * -1 else // end                                                 as SGST, //53
      //  SGSTdetails.ConditionAmount    end     end                                                    as SGST, //53

      //  jou_entry.SGST as sgst,

      //  cast((IGSTdetails.ConditionRateValue) as abap.dec(5,2))                                 as IGST_Rate, //54

      //  case when jou_entry.referencedocno is initial and jou_entry.AccountingDocument is not initial then
      //  IGSTdetails.ConditionAmount else
      //    case when BillingHeader.BillingDocumentType = 'G2' then
      //    IGSTdetails.ConditionAmount * -1 else // end                                                 as IGST, //55
      //  IGSTdetails.ConditionAmount     end  end                                                      as IGST, //55

      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as TCS_Rate, //56
      TGSTdetails.ConditionAmount                                                                                                                      as TCS, //57
      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as VAT_Rate, //58 needs to be commented
      TGSTdetails.ConditionAmount                                                                                                                      as VAT, //59   needs to be commented
      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as CST_Rate, //60  needs to be commented
      TGSTdetails.ConditionAmount                                                                                                                      as CST, //61  needs to be commented


      cast(CGSTdetails.ConditionRateValue as abap.fltp )
               +
      cast( SGSTdetails.ConditionRateValue as abap.fltp )
               +
      cast( IGSTdetails.ConditionRateValue as abap.fltp  )                                                                                             as GST_RATE,

      //  cast((Itemprcg.ConditionRateAmount * billingitem.BillingQuantity * CGSTdetails.ConditionRateValue ) / 100  as abap.dec( 16, 4 )) as CGST,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( CGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as CGST,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( SGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as SGST,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( IGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as IGST,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( TGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as TCS,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( VGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as VAT,
      //  cast( Itemprcg.ConditionRateAmount as abap.fltp ) * cast( billingitem.BillingQuantity as abap.fltp ) * cast( CGSTdetails.ConditionRateValue as abap.fltp ) / cast( 100 as abap.fltp ) as CST,


      //      case when jou_entry.CGST is not initial and jou_entry.SGST is not initial then
      //      //  jou_entry.CGST + jou_entry.SGST else
      ////      fltp_to_dec (jou_entry.CGST as abap.dec( 16, 2 ) ) + fltp_to_dec (jou_entry.SGST as abap.dec( 16, 2 ) ) else
      //      jou_entry.CGST + jou_entry.SGST else
      //      case when jou_entry.IGST is not initial then
      //      //  jou_entry.IGST else
      ////      fltp_to_dec (jou_entry.IGST as abap.dec( 16, 2 ) ) else
      //      jou_entry.IGST else
      //      case when Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial then

      //      case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and
      //      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      abs(Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency) else
      //
      //      case when jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial and
      //      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  else
      ////      case when igst_gl.AmountInCompanyCodeCurrency is not initial then
      //
      //      case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and
      //      igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency else
      //
      //      case when jou_entry.is_reversal = '' and jou_entry.reversedocument is not initial and
      //      igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency  else
      //
      //      case when  jou_entry.reversedocument is initial and
      //      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      abs(Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency) else
      //
      //      case when jou_entry.reversedocument is initial and
      //      igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      igst_gl.AmountInCompanyCodeCurrency
      //      end end end end end end as Totaltax,

      @Semantics.amount.currencyCode: 'comp_code_curr'
      case when ( jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' ) and
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      ( igst_gl.AmountInCompanyCodeCurrency * -1 ) else

      case when ( jou_entry.accdoctype = 'DG' or jou_entry.accdoctype = 'DR' ) and
      igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency else

      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      then
      abs(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) + cast(sgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 ))) else

      //        case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' then
      //        abs(cast(IGST_usd.ConditionAmount as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial then
      cast(IGST_usd.ConditionAmount * ( jou_entry.absoexchrate ) as abap.dec( 16, 2 )) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial then
      //      abs(cast((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate) ) as abap.dec( 16, 2 )))  else //(-) by Anurag on 23.05.2024
      abs(cast((((CGST_usd.ConditionAmount) + (SGST_usd.ConditionAmount)) * (jou_entry.absoexchrate) ) as abap.dec( 16, 2 )))  else   //(+) by Anurag on 23.05.2024

      //        cast((CGSTdetails.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) + cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial then
      //      abs(igst_gl.AmountInCompanyCodeCurrency) //(-) by Anurag on 23.05.2024
        abs(IGSTdetails.ConditionAmount)
      end end end end end end end                                                                                                                      as Totaltax,

      //        case when igst_gl.AmountInCompanyCodeCurrency is not initial then
      //        igst_gl.AmountInCompanyCodeCurrency end end as Totaltax,
      //      else
      //      case when BillingHeader.BillingDocumentType = 'G2' then
      //      BillItem.TaxAmount * -1 else BillItem.TaxAmount end  end  end           as Totaltax,    //62


      case when BillItem.TaxCode is not initial then
      BillItem.TaxCode
      when jou_entry.TaxCode is not initial then
      jou_entry.TaxCode end                                                                                                                            as Tax_Code,

      BillItem.ShipToParty                                                                                                                             as Ship_To_Prty,


      //      case when jou_entry.is_reversal = 'X' and jou_entry.reversedocument is not initial and

      //      case when jou_entry.BaseAmount is not initial
      //      and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      abs( cast(( jou_entry.BaseAmount ) as abap.dec( 16, 2 ) ) +
      //      cast(( Cgst_gl.AmountInCompanyCodeCurrency ) as abap.dec( 16, 2 ) ) +
      //      cast(( sgst_gl.AmountInCompanyCodeCurrency ) as abap.dec( 16, 2 ) ) ) else
      //      case when jou_entry.BaseAmount is not initial
      //      and igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      abs( cast(( jou_entry.BaseAmount ) as abap.dec( 16, 2 ) ) +
      //      cast(( igst_gl.AmountInCompanyCodeCurrency ) as abap.dec( 16, 2 ) ) )
      //      else
      ////      case when BillingHeader.BillingDocumentType = 'G2'
      ////      then (BillItem.TaxAmount + BillItem.NetAmount)*-1 else
      //      BillItem.TaxAmount + BillItem.NetAmount  end end  as Gross_Value, //63

      //        case when CGSTdetails.ConditionAmount is initial and SGSTdetails.ConditionAmount is initial and
      //        IGSTdetails.ConditionAmount is initial and
      //        igst_gl.AmountInCompanyCodeCurrency is initial and Cgst_gl.AmountInCompanyCodeCurrency is initial and
      //        sgst_gl.AmountInCompanyCodeCurrency is initial then
      //        abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else
      //
      //        case when
      //        CGSTdetails.ConditionRateValue is initial and
      //        jou_entry.CGST_PERC is initial and
      //        SGSTdetails.ConditionRateValue is initial and
      //        jou_entry.SGST_PERC is initial and
      //        IGSTdetails.ConditionRateValue is initial and
      //        jou_entry.IGST_PERC is initial then
      //        abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      ////Anurag
      //      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      //      BillItem.TaxCode is initial and jou_entry.TaxCode is initial and amortisation.ConditionAmount is not initial then
      //      abs((cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      ////Anurag

      //Anurag
      case when jou_entry.accdoctype = 'RV' and
      BillItem.TaxCode is initial and jou_entry.TaxCode is initial and amortisation.ConditionAmount is not initial then
      abs((cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      //Anurag

      ////Anurag
      //      case when
      //      jou_entry.TaxCode = 'F0' or BillItem.TaxCode = 'F0' or
      //      jou_entry.TaxCode = 'OZ' or jou_entry.TaxCode = 'OZ' and
      //      CGSTdetails.ConditionRateValue is initial and jou_entry.CGST_PERC is initial
      //      and amortisation.ConditionAmount is not initial then
      //      abs((cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      ////Anurag

      ////Anurag
      //      case when
      //      jou_entry.accdoctype = 'DG' and (jou_entry.TaxCode is initial or BillItem.TaxCode is initial)
      //      and amortisation.ConditionAmount is not initial then
      //      abs((cast((jou_entry.amcomp) as abap.dec( 16, 2 )) + ( amortisation.ConditionAmount ) ) ) else
      //////Anurag


      //////Anurag
      ////      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      ////      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      ////      and amortisation.ConditionAmount is not initial then
      ////      abs((cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      ////      cast(sgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      ////      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) - ( amortisation.ConditionAmount ) ) else
      //////Anurag

      ////Anurag
      //      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      //      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and amortisation.ConditionAmount is not initial then
      //      abs((cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      //      cast(sgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      //      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      ////Anurag

      //Anurag
      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial
      and amortisation.ConditionAmount is not initial then
      abs((cast(((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate)) + jou_entry.amcomp ) as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      //Anurag
      //Anurag
      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial and amortisation.ConditionAmount is not initial then
      abs((cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      //Anurag
      //Anurag
      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial
      and amortisation.ConditionAmount is not initial then
      abs((cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      //Anurag

      ////Anurag
      //      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      //      igst_gl.AmountInCompanyCodeCurrency is not initial and amortisation.ConditionAmount is not initial then
      //      abs((cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      //      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      ////Anurag

      //Anurag
      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial and amortisation.ConditionAmount is not initial then
      abs((cast(IGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) + ( amortisation.ConditionAmount ) ) else
      //Anurag

      ////Anurag(+)
      case when jou_entry.accdoctype = 'DR'  // or jou_entry.accdoctype = 'DG' )
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else

      case when jou_entry.accdoctype = 'DG'  // or jou_entry.accdoctype = 'DG' )
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else
      ////Anurag(+)

      //      abs(cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else //(-)Anurag

      case when jou_entry.accdoctype = 'RV' and
      BillItem.TaxCode is initial and jou_entry.TaxCode is initial then
      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      //      case when jou_entry.accdoctype = 'RV' and
      //      BillItem.TaxCode is initial and jou_entry.TaxCode is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      //      case when jou_entry.accdoctype = 'RV' and
      //      BillItem.TaxCode is not initial and jou_entry.TaxCode is initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      ////Anurag(+)
      case when jou_entry.accdoctype = 'DR' and //or jou_entry.accdoctype = 'DG' ) and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then //and CGSTdetails.ConditionRateValue is initial and jou_entry.CGST_PERC is initial then
      jou_entry.amcomp else
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'DG' and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then //and CGSTdetails.ConditionRateValue is initial and jou_entry.CGST_PERC is initial then
      jou_entry.amcomp else
      ////Anurag(+)

      //      case when
      //      jou_entry.accdoctype = 'DG' and (jou_entry.TaxCode is initial or BillItem.TaxCode is initial) then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else
      ////Anurag(-)

      //          case when Cgst_gl.AmountInCompanyCodeCurrency is initial and igst_gl.AmountInTransactionCurrency is initial then
      //          abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else


      //        case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG' and
      //        BillItem.TaxCode is initial and jou_entry.TaxCode is initial and
      //        Cgst_gl.AmountInCompanyCodeCurrency is initial and sgst_gl.AmountInCompanyCodeCurrency is initial and
      //        igst_gl.AmountInTransactionCurrency is initial and
      //        CGSTdetails.ConditionAmount is initial and SGSTdetails.ConditionAmount is initial and
      //        IGSTdetails.ConditionAmount is initial then
      //        abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      //        case when jou_entry.accdoctype = 'RV' and
      //        BillItem.TaxCode is initial and jou_entry.TaxCode is initial and
      //        Cgst_gl.AmountInCompanyCodeCurrency is initial and sgst_gl.AmountInCompanyCodeCurrency is initial and
      //        igst_gl.AmountInTransactionCurrency is initial and
      //        CGSTdetails.ConditionAmount is initial and SGSTdetails.ConditionAmount is initial and
      //        IGSTdetails.ConditionAmount is initial then
      //        abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

// BOC by Anurag (+) 11.10.2024
      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and // and sgst_gl.AmountInCompanyCodeCurrency is not initial
      TGSTdetails.ConditionAmount is not initial
      and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG' ) and
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial 
      and TGSTdetails.ConditionAmount is not initial then //and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      //Anurag
      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 
      and TGSTdetails.ConditionAmount is not initial  then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and TGSTdetails.ConditionAmount is not initial  then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

// EOC by Anurag (+) 11.10.2024

      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial // and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG' ) and
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then //and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      //Anurag
      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      jou_entry.amcomp else
      //Anurag

// BOC by Anurag (+) 11.10.2024
      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast(((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate)) + jou_entry.amcomp ) as abap.dec( 16, 2 )) + 
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)))  else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else  //remove * -1 from amcomp by anurag on 23.05.2024

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial and
      SGSTdetails.ConditionAmount < 0 and TGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
      
// EOC by Anurag (+) 11.10.2024      
      
      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial then
      abs(cast(((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate)) + jou_entry.amcomp ) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial then
      abs(cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else  //remove * -1 from amcomp by anurag on 23.05.2024

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial and
      SGSTdetails.ConditionAmount < 0 then
      abs(cast(CGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
      

// BOC by Anurag (+) 11.10.2024         
      case when jou_entry.accdoctype = 'DR' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency * -1 as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else      
      
      case when jou_entry.accdoctype = 'DR' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and TGSTdetails.ConditionAmount is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
            
      case when jou_entry.accdoctype = 'DG' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and TGSTdetails.ConditionAmount is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else         
      
      case when jou_entry.accdoctype = 'DG' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency * -1 as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
      
// EOC by Anurag (+) 11.10.2024               
      
      case when jou_entry.accdoctype = 'DR' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency * -1 as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else      
      
      case when jou_entry.accdoctype = 'DR' and
      igst_gl.AmountInCompanyCodeCurrency is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
            
      case when jou_entry.accdoctype = 'DG' and
      igst_gl.AmountInCompanyCodeCurrency is not initial then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else         
      
      case when jou_entry.accdoctype = 'DG' and
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency * -1 as abap.dec( 16, 2 )) +
//      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else      
      
      //        case when jou_entry.accdoctype = 'RV' and
      //        IGSTdetails.ConditionAmount is not initial then
      //        IGSTdetails.ConditionAmount + jou_entry.amcomp end end end end end as Gross_Value,

// BOC by Anurag (+) 11.10.2024
      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial and IGSTdetails.ConditionAmount < 0 
      and TGSTdetails.ConditionAmount is not initial then
      abs(cast(IGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
      //Anurag

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial and TGSTdetails.ConditionAmount is not initial then
      abs(cast(IGSTdetails.ConditionAmount as abap.dec( 16, 2 )) + cast(TGSTdetails.ConditionAmount as abap.dec(16, 2)) +   //igst_gl.AmountInCompanyCodeCurrency >> igstdetails.conditionamount by Anurag 23.05.2024
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

// EOC by Anurag (+) 11.10.2024


      //Anurag
      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial and IGSTdetails.ConditionAmount < 0 then
      abs(cast(IGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else
      //Anurag

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial then
      abs(cast(IGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +    //igst_gl.AmountInCompanyCodeCurrency >> igstdetails.conditionamount by Anurag 23.05.2024
      cast(jou_entry.amcomp as abap.dec( 16, 2 )))
      end end end end end end end end end end end end end end end end end end end end end end end end end end
      end end end end end end end end end end end end as Gross_Value,

      //  case when BillingHeader.BillingDocumentType = 'G2'
      //  then (billingitem.TaxAmount + billingitem.NetAmount)*-1 end                          as g1val,


      //case when billin
      //billingitem.TaxAmount + billingitem.NetAmount                                        as g1val,

      //      case when jou_entry.AccountingDocumentType = 'DR' or jou_entry.AccountingDocumentType = 'DG'
      //      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      //      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) + jou_entry.amcomp end as grs,

      FREIGHTEXP.PurchaseOrder                                                                                                                         as Transporter_Purchase_Doc_No, //64

      ltrim(Vendordetails.Supplier, '0')                                                                                                               as Freight_vendor, //65

      FREIGHTEXP.FrtCostAllocItemNetAmount                                                                                                             as Freight_Exp, //69
      //@DefaultAggregation: #SUM
      case when ( FREIGHTEXP.FrtCostAllocItemNetAmount is null and Itemprcg1.ConditionAmount is not null ) then Itemprcg1.ConditionAmount

      else
      Itemprcg1.ConditionAmount - FREIGHTEXP.FrtCostAllocItemNetAmount end                                                                             as Freight_Margin,
      BillItem.SalesOffice                                                                                                                             as Sales_Office,

      ltrim(BillingHeader.SoldToParty,'0')                                                                                                             as Broker_Code, //72
      //      ltrim(Broker.Payer,'0') as Broker_Code,
      Broker.CustomerName                                                                                                                              as Broker_Name, //73
      Trans.SupplierName                                                                                                                               as Transporter_Name,
      jou_entry.ReversalDocument,
      //   F4HELP.BILLING_TYPE as BILL_TYPE_HELP,
      _HELP,
      _DIV_HELP,
      igst_gl.AmountInCompanyCodeCurrency                                                                                                              as IGHT_TST,
      Cgst_gl.AmountInCompanyCodeCurrency                                                                                                              as CGS,
      sgst_gl.AmountInCompanyCodeCurrency                                                                                                              as SGS

      //  case when BillingHeader.BillingDocumentType <> 'CBD2' and BillingHeader.BillingDocumentType <> 'CBRE'
      //  and BillingHeader.BillingDocumentType <> 'F2' and BillingHeader.BillingDocumentType <> 'G2'
      //  and BillingHeader.BillingDocumentType <> 'JSP' and BillingHeader.BillingDocumentType <> 'JSTO'
      //  and BillingHeader.BillingDocumentType <> 'L2' then
      //  DFI.AccountingDocument end as DFIAccDocNo


      //     currency_conversion


}
where
           jou_entry.ReversalDocument <> 'Yes'
  and(
    (
           jou_entry.Qty              =  'BaseAmt'
      and  jou_entry.accdoctype       =  'RV'
    )
    or(
           jou_entry.Qty              =  'JOURNALENTRY_AMOUNT'
      and(
           jou_entry.accdoctype       =  'DR'
        or jou_entry.accdoctype       =  'DG'
      )
    )
  )
//where BillItem.BillingDocumentItem = jou_entry.ReferenceDocumentItem
//where
//      BillItem.BillingQuantity              is not initial
//      and BillItem.BillingDocumentItem = BillItem.BillingDocumentItem
//  and BillingHeader.AccountingPostingStatus    =  'C'
// // and BillingHeader.BillingDocumentIsCancelled <> 'X'
//  and BillingHeader.BillingDocumentType        <> 'S1'
//  and BillingHeader.BillingDocumentType        <> 'S2'

//and Freightexp.FrtCostAllocItemNetAmount >= 0      //To restrict negative amount


group by
  BillItem.BillingDocument,
  BillItem.MaterialGroup,
  BillingHeader.FiscalYear,
  BillingHeader.AccountingExchangeRate,
  //  BillingHeader.BillingDocumentType,
  irn.IN_EDocEInvcEWbillNmbr,
  irn_bill.IN_EDocEInvcEWbillNmbr,
  irn.IN_EDocEInvcEWbillCreateDate,
  irn_bill.IN_EDocEInvcEWbillCreateDate,
  irn.IN_EDocEWbillStatus,
  irn_bill.IN_EDocEWbillStatus,
  irn.IN_ElectronicDocAcknNmbr,
  irn_bill.IN_ElectronicDocAcknNmbr,
  irn.IN_ElectronicDocAcknDate,
  irn_bill.IN_ElectronicDocAcknDate,
  irn.IN_ElectronicDocCancelDate,
  irn_bill.IN_ElectronicDocCancelDate,
  irn.IN_EDocCancelRemarksTxt,
  irn_bill.IN_EDocCancelRemarksTxt,
  irn.ElectronicDocProcessStatus,
  irn_bill.ElectronicDocProcessStatus,
  irn.ElectronicDocCountry,
  irn_bill.ElectronicDocCountry,
  irn.ElectronicDocType,
  irn_bill.ElectronicDocType,
  irn.IN_ElectronicDocInvcRefNmbr,
  irn_bill.IN_ElectronicDocInvcRefNmbr,
  GLAcc.GLAccount,
  jou_entry.GLDesc, //(+)by Anurag on 23.05.2024
  GLAcc.IsReversal,
  GLAcc.ReversalReferenceDocument,
  BillItem.Plant,
  BillItem.BillingDocumentDate,
  BillItem.BillingDocumentType,
  BillItem.NetAmount,
  documenttype.BillingDocumentTypeName,
  PrecInv.SubsequentDocument,
  PrecInv.CreationDate,

  BillingHeader.DocumentReferenceID,
  //  BillingHeader.AccountingDocument,

  BillItem.SalesOrderDistributionChannel,
  Distchannel.DistributionChannelName,
  BillItem.Division,
  //Division.DivisionName ,
  BillItem.SalesOrderCustomerPriceGroup,
  BillItem.CustomerGroup,
  //Custgrp.AdditionalCustomerGroup1Name,

  BillingHeader.PayerParty,

  status.status,
  BillItem.BillingDocumentItem,
  BillItem.Product,
  BillItem.BillingDocumentItemText,
  customer.CustomerName,
  customer.TaxNumber3,
  customer.Customer_Pan,
  customer.TaxNumber2,
  customer.Region,
  //itemflow1.PrecedingDocument,
  BillItem.SalesDocument,
  salesdetails.PurchaseOrderByCustomer,
  salesdetails.CustomerPurchaseOrderDate,
  salesdetails.CreationDate,
  BillItem.ReferenceSDDocument,
  //Delivery.CreationDate,
  jou_entry.HSN_Code,  
  
//  HSN.AssignmentReference,
//  HSNcode.ConsumptionTaxCtrlCode,
  //batchdetails.Batch,
  //batchdetails.ManufactureDate,
  //batchdetails.ShelfLifeExpirationDate,
  BillItem.BillingQuantity,
  BillItem.BillingQuantityUnit,
  BillItem.SalesDocumentItemCategory,
  Itemprcg.ConditionRateAmount,
  Itemprcg1.ConditionAmount,
  Itemprcg1.TransactionCurrency,
  GLAcc.CompanyCodeCurrency,
  BillItem.NetAmount,
  BillItem.TaxAmount,
  Itemprcg.ConditionAmount,
  CGSTdetails.ConditionRateValue,
  CGSTdetails.ConditionAmount,
  SGSTdetails.ConditionRateValue,
  SGSTdetails.ConditionAmount,
  IGSTdetails.ConditionRateValue,
  IGSTdetails.ConditionAmount,
  TGSTdetails.ConditionRateValue,
  TGSTdetails.ConditionAmount,
  BillItem.TaxCode,
  BillItem.ShipToParty,
  Vendordetails.Supplier,
  FREIGHTEXP.PurchaseOrder,
  FREIGHTEXP.FrtCostAllocItemNetAmount,
  BillItem.SalesOffice,

  BillingHeader.SoldToParty,

  Broker.CustomerName,
  Trans.SupplierName,
  billi_doc_cube.AccountingExchangeRate,
  billi_doc_cube.Product,
  //billi_doc_cube.BillingDocumentItem,
  //billi_doc_cube.BillingDocument,
  billi_doc_cube.ShipToParty,
  billi_doc_cube.ShipToPartyName,
  billi_doc_cube.BillToParty,
  billi_doc_cube.BillToPartyName,
  billi_doc_cube.BillToPartyRegion,
  billi_doc_cube.BillToPartyCountry,
  amortisation.ConditionAmount, //Anurag
  //  amortisation.ConditionType,  //Anurag
  roundoffvalue.ConditionAmount,
  jou_entry.AccountingDocument,
  jou_entry.FiscalYear,
  jou_entry.referencedocno,
  Cgst_gl.AmountInCompanyCodeCurrency,
  jou_entry.SGST,
  jou_entry.CGST,
  jou_entry.doccumentadate,
  jou_entry.DocumentDate,
  jou_entry.PostingDate,
  jou_entry.TaxCode,
  jou_entry.IGST,
  //  baseamount.AmountInCompanyCodeCurrency,
  //  baseamount.TaxBaseAmountInCoCodeCrcy,
  jou_entry.CGST_PERC,
  jou_entry.SGST_PERC,
  jou_entry.IGST_PERC,
  jou_entry.AccountingDocumentType,
  jou_entry.accdoctype,
  jou_entry.Distributionchannel,
  //  jou_entry.Ewaybillnumber,
  //  jou_entry.Ewaybilldate,
  //  jou_entry.Ewaybillstatus,
  //  jou_entry.Acknum,
  //  jou_entry.Ackdate,
  //  jou_entry.Einvcanceldate,
  //  jou_entry.EinvcancelReason,
  //  jou_entry.Einvstatus,
  //  jou_entry.Einvcity,
  //  jou_entry.Einvtype,
  //  jou_entry.IRN,
  jou_entry.materialgroup,
  jou_entry.amcomp,
  //  cgst_amount.AmountInCompanyCodeCurrency,
  //  sgst_amount.AmountInCompanyCodeCurrency,
  //  igst_amount.AmountInCompanyCodeCurrency,
  Cgst_gl .AccountingDocumentType,
  sgst_gl.AmountInCompanyCodeCurrency,
  igst_gl.AmountInCompanyCodeCurrency,
  sgst_gl.AccountingDocumentType,
  igst_gl.AccountingDocumentType,
  jou_entry.BaseAmount,
  jou_entry.originalrefdocno,
  customer.Customer,
  jou_entry.Customer,
  jou_entry.gl_account,
  jou_entry.is_reversal,
  jou_entry.shiptoparty,
  jou_entry.customer_name,
  jou_entry.region,
  jou_entry.plant,
  jou_entry.trasns_curreency,
  jou_entry.transactioncurrency,
  jou_entry.absoexchrate,
  jou_entry.hsncode,
  cust.TaxNumber3,
  jou_entry.ReferenceDocumentItem,
  jou_entry.reversedocument,
  jou_entry.customer_name_,
  jou_entry.custo_name,
  jou_entry.is_reversed,
  CGST_usd.ConditionAmount,
  SGST_usd.ConditionAmount,
  jou_entry.itemno,
  igst_gl.AmountInTransactionCurrency,
  IGST_usd.ConditionAmount,
  jou_entry.ReversalDocument
//DFI.AccountingDocument
//BillingHeader.BillingDocument
//FIdocs.BillingDocument,
//FIdocs.AccountingDocument
//FIdocs.AccountingDocument
//FIdocs.AccountingDocument,
//FIdocs.AccountingDocumentType
//billi_doc_cube.AccountingExchangeRate
