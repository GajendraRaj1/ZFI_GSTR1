//@AbapCatalog.sqlViewName: 'ZI_JOURNAL_SALES'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Direct FI for sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FI_JOURNAL_ENTRY
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem         as GetSupplier on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                                  and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                                  and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                                  and GetSupplier.FinancialAccountType =  'D'
                                                                  and GetSupplier.Customer             <> ''




  //  association


  //  association [1] to I_IN_ElectronicDocInvoice as jei_irn on JournalItem.ReferenceDocument = jei_irn.ElectronicDocSourceKey


  association [1]    to I_OperationalAcctgDocItem  as cgst_amo    on  JournalItem.AccountingDocument          = cgst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = cgst_amo.AmountInCompanyCodeCurrency
                                                                  and cgst_amo.AccountingDocumentItemType     = 'T'
                                                                  and cgst_amo.TransactionTypeDetermination   = 'JOC'

  association [1]    to I_OperationalAcctgDocItem  as sgst_amo    on  JournalItem.AccountingDocument          = sgst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = sgst_amo.AmountInCompanyCodeCurrency
                                                                  and sgst_amo.AccountingDocumentItemType     = 'T'
                                                                  and sgst_amo.TransactionTypeDetermination   = 'JOS'

  association [1]    to I_OperationalAcctgDocItem  as igst_amo    on  JournalItem.AccountingDocument          = igst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = igst_amo.AmountInCompanyCodeCurrency
                                                                  and igst_amo.AccountingDocumentItemType     = 'T'
                                                                  and igst_amo.TransactionTypeDetermination   = 'JOI'

  association [1]    to I_OperationalAcctgDocItem  as customer    on  JournalItem.AccountingDocument = customer.AccountingDocument
                                                                  and customer.FinancialAccountType  = 'D'

  association [0..1] to I_ProductPlantBasic            as HSNcode        on  HSNcode.Product = JournalItem.Product
                                                                         and HSNcode.Plant   = JournalItem.Plant
                                                                         
  association [0..1] to I_OperationalAcctgDocItem      as HSN    on JournalItem.AccountingDocument      = HSN.AccountingDocument
                                                                 and JournalItem.FiscalYear             = HSN.FiscalYear      
                                                                 and JournalItem.AccountingDocumentItem = HSN.AccountingDocumentItem


  //  association [1] to I_BillingDocumentBasic as BillingHeader  on  BillingHeader.BillingDocument = JournalItem.ReferenceDocument
  //                                                              and BillingHeader.AccountingPostingStatus = 'C'

  association [1]    to I_JournalEntry             as jeheader    on  JournalItem.AccountingDocument = jeheader.AccountingDocument

  //  association [1] to I_Customer as custo on  JournalItem.Customer = custo.Customer
  association [1]    to I_Customer                 as custo       on  JournalItem.OffsettingAccount = custo.Customer
                                                                  and custo.Language                = 'E'


  association [0..1] to I_BillingDocumentItemBasic as BillItem    on  BillItem.BillingDocument     = JournalItem.ReferenceDocument
  //                                                              and BillItem.BillingDocument = billingitem.BillingDocument
  //                                                                and BillItem.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                  and BillItem.BillingDocumentItem = JournalItem.ReferenceDocumentItem

  association [0..1] to I_GLAccountText            as GLDesc      on  $projection.GLAccount = GLDesc.GLAccount //(+)by Anurag on 23.05.2024
                                                                  and GLDesc.Language       = $session.system_language
{
  key JournalItem.AccountingDocument                            as AccountingDocument,
  key JournalItem.AccountingDocumentItem                        as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                            as PurchasingDocument,
  key JournalItem.FiscalYear                                    as FiscalYear,

      //      JournalItem.AccountingDocumentItem      as AccountingDocumentItem,
      jeheader.OriginalReferenceDocument                        as Oiginalreferencedocumentno,
      JournalItem.ReferenceDocument                             as referencedocno,
      jeheader.DocumentReferenceID                              as originalrefdocno,
      JournalItem.DocumentDate                                  as DocumentDate,
      JournalItem.PostingDate                                   as PostingDate,
      JournalItem.OffsettingAccount                             as OffsettingAccount,
      JournalItem.PurchasingDocumentItem                        as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                               as DebitCreditCode,
      JournalItem.ReferenceDocument                             as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem                         as ReferenceDocumentItem,
      JournalItem.TaxCode                                       as TaxCode,
      JournalItem.GLAccount                                     as GLAccount,
      GLDesc.GLAccountLongName                                  as GLDesc, //(+)by Anurag on 23.05.2024
//      JournalItem.AssignmentReference                           as hsncode,
      substring( HSNcode.ConsumptionTaxCtrlCode , 1 , 8 )       as HSN_Code,
      HSN.IN_HSNOrSACCode                                       as hsncode, 
      JournalItem.DebitCreditCode                               as debitcredetcode,
      JournalItem.TransactionCurrency                           as trasns_curreency,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'


      case when JournalItem.TransactionCurrency <> 'INR' and JournalItem.AmountInTransactionCurrency is not initial then
      cast((JournalItem.AmountInTransactionCurrency) as abap.dec( 16, 2 )) *
      jeheader.AbsoluteExchangeRate
      when JournalItem.TransactionCurrency = 'INR' and JournalItem.AmountInTransactionCurrency is not initial then
      cast((JournalItem.AmountInTransactionCurrency) as abap.dec( 16, 2 ))

      end                                                       as BaseAmount,
      JournalItem.GLAccountType                                 as GLAccountType,
      JournalItem.IsReversal                                    as IsReversal,
      JournalItem.CompanyCodeCurrency                           as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'trasns_curreency'
      case when JournalItem.DebitCreditCode = 'H' then
      abs(JournalItem.AmountInTransactionCurrency) else
      JournalItem.AmountInTransactionCurrency end               as amountintransactioncurrency,

      JournalItem.DistributionChannel                           as Distributionchannel,

      JournalItem.SalesOrder                                    as salesorder,
      JournalItem.SalesOrderItem                                as salorderitem,
      JournalItem.SalesDocument                                 as salesdocument,
      JournalItem.SalesDocumentItem                             as salesdocitem,
      JournalItem.Product                                       as product,
      
      case when JournalItem.AccountingDocumentType = 'RV' then 
      JournalItem.Plant 
      when JournalItem.AccountingDocumentType = 'DR' or JournalItem.AccountingDocumentType = 'DG' then
      substring( JournalItem.ProfitCenter , 7 ,  4 ) end as plant,

      JournalItem.DocumentDate                                  as doccumentadate,

      JournalItem.IsReversal                                    as is_reversal,
      JournalItem.IsReversed                                    as is_reversed,
      JournalItem.ReversalReferenceDocument                     as reversedocument, //added
      JournalItem.GLAccount                                     as gl_account, //added
      JournalItem.Customer                                      as customer_name, //added
      customer.Customer                                         as customer_name_,
      customer.CustomerGroup                                    as customer_group_,
      customer.Region                                           as region,
      JournalItem.CustomerGroup                                 as customer_group, //added
      custo.CustomerName                                        as custo_name,
      custo.Customer                                            as custo_number,

      case when JournalItem.IsReversal = 'X' and JournalItem.ReversalReferenceDocument <> ' ' then
      'Yes' else
      case when JournalItem.IsReversal = ' ' and JournalItem.ReversalReferenceDocument <> ' ' then
      'No'
      else 'Null'
      end end                                                   as ReversalDocument,

      //      JournalItem.PostingDate as postingdate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when JournalItem.AmountInCompanyCodeCurrency < 0 then
      ( JournalItem.AmountInCompanyCodeCurrency ) * ( -1 ) else
      ( JournalItem.AmountInCompanyCodeCurrency ) * (  1 )  end as amcomp, //(+) by Anurag on 23.05.2024
      JournalItem.MaterialGroup                                 as materialgroup,
      JournalItem.AccountingDocumentType                        as accdoctype,
      JournalItem.ShipToParty                                   as shiptoparty,
      JournalItem.TransactionCurrency                           as transactioncurrency,
      jeheader.AbsoluteExchangeRate                             as absoexchrate,
      BillItem.BillingDocumentItem                              as itemno,
      //      BillingHeader.DocumentReferenceID as GST_Invoice_No,



      //  jei_irn.IN_EDocEInvcEWbillNmbr                                                              as Ewaybillnumber,
      //  jei_irn.IN_EDocEInvcEWbillCreateDate                                                        as Ewaybilldate,
      //  jei_irn.IN_EDocEWbillStatus                                                                 as Ewaybillstatus,
      //  jei_irn.IN_ElectronicDocAcknNmbr                                                            as Acknum,
      //  jei_irn.IN_ElectronicDocAcknDate                                                            as Ackdate,
      //  //irn.IN_EDocEInvcBusinessPlace                                 as Bussiness_area,
      //  jei_irn.IN_ElectronicDocCancelDate                                                          as Einvcanceldate,
      //  jei_irn.IN_EDocCancelRemarksTxt                                                             as EinvcancelReason,
      //  jei_irn.ElectronicDocProcessStatus                                                          as Einvstatus,
      //  jei_irn.ElectronicDocCountry                                                                as Einvcity,
      //  jei_irn.ElectronicDocType                                                                   as Einvtype,
      //  jei_irn.IN_ElectronicDocInvcRefNmbr                                                         as IRN,






      //      JournalItem.ConsolidationUnit as unit,
      //      @Semantics.quantity.unitOfMeasure: 'unit'
      //      JournalItem.Quantity as quantity,

      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      //      JournalItem.Quantity as noofquan,

      //      JournalItem.ReferenceDocument as referencedocument,

      // JournalItem. as accexerate,

      //*************SGST
      //      case
      //      when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'B0'
      //        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      //      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
      //        or JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      //        or JournalItem.TaxCode = 'OA'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
      //        or JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'OB'
      //        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
      //        or JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      //        or JournalItem.TaxCode = 'F5' or JournalItem.TaxCode = 'OC'
      //        or JournalItem.TaxCode = 'F4'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
      //        or JournalItem.TaxCode = 'AE' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      //        or JournalItem.TaxCode = 'OD'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
      //        end                                   as SGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sgst_amo.AmountInCompanyCodeCurrency                      as SGST,

      //*************SGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'B0'
      or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      then (cast(100 as abap.fltp)*0.015)

      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
      or JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'B1'
      or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      or JournalItem.TaxCode = 'OA'
      then (cast(100 as abap.fltp)*0.025)

      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
      or JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'OB'
      or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      then (cast(100 as abap.fltp)*0.06)

      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
      or JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'B3'
      or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      or JournalItem.TaxCode = 'F5' or JournalItem.TaxCode = 'OC'
      or JournalItem.TaxCode = 'F4'
      then (cast(100 as abap.fltp)*0.09)

      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
      or JournalItem.TaxCode = 'AE' or JournalItem.TaxCode = 'B4'
      or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      or JournalItem.TaxCode = 'OD'
      then (cast(100 as abap.fltp)*0.14)

      end                                                       as SGST_PERC,

      //*************CGST
      //      case
      //      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
      //        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      //      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
      //        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      //        or JournalItem.TaxCode = 'OA'
      //      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
      //        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'OB'
      //        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      //      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
      //        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      //        or JournalItem.TaxCode = 'OC' or JournalItem.TaxCode = 'F4'
      //      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
      //        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      //        or JournalItem.TaxCode = 'OD'
      //      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
      //       end                                    as CGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cgst_amo.AmountInCompanyCodeCurrency                      as CGST,

      //*************CGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'B0'
       or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      then (cast(100 as abap.fltp)*0.015)

      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
       or JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'B1'
       or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
       or JournalItem.TaxCode = 'OA'
      then (cast(100 as abap.fltp)*0.025)

      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
       or JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'OB'
       or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      then (cast(100 as abap.fltp)*0.06)

      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
       or JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'B3'
       or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
       or JournalItem.TaxCode = 'F5' or JournalItem.TaxCode = 'OC'
       or JournalItem.TaxCode = 'F4'
      then (cast(100 as abap.fltp)*0.09)

      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
       or JournalItem.TaxCode = 'AE' or JournalItem.TaxCode = 'B4'
       or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
       or JournalItem.TaxCode = 'OD'
      then (cast(100 as abap.fltp)*0.14)
       end                                                      as CGST_PERC,

      //*************IGST
      //      case
      //      when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
      //        or JournalItem.TaxCode = 'C5' or JournalItem.TaxCode = 'D5'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.03)
      //      when JournalItem.TaxCode = 'G6' or JournalItem.TaxCode = 'H5'
      //        or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
      //        or JournalItem.TaxCode = 'C6' or JournalItem.TaxCode = 'D6'
      //        or JournalItem.TaxCode = 'PA'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      //      when JournalItem.TaxCode = 'G7' or JournalItem.TaxCode = 'H6'
      //        or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
      //        or JournalItem.TaxCode = 'C7' or JournalItem.TaxCode = 'D7'
      //        or JournalItem.TaxCode = 'PB'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      //      when JournalItem.TaxCode = 'G8' or JournalItem.TaxCode = 'H7'
      //        or JournalItem.TaxCode = 'G9' or JournalItem.TaxCode = 'H8'
      //        or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
      //        or JournalItem.TaxCode = 'C8' or JournalItem.TaxCode = 'D8'
      //        or JournalItem.TaxCode = 'F3' or JournalItem.TaxCode = 'F6'
      //        or JournalItem.TaxCode = 'PC'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      //      when JournalItem.TaxCode = 'A9' or JournalItem.TaxCode = 'B9'
      //        or JournalItem.TaxCode = 'C9' or JournalItem.TaxCode = 'D9'
      //        or JournalItem.TaxCode = 'PD'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
      //        end                                   as IGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      igst_amo.AmountInCompanyCodeCurrency                      as IGST,

      //*************IGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
      or JournalItem.TaxCode = 'C5' or JournalItem.TaxCode = 'D5'
      then (cast(100 as abap.fltp)*0.03)

      when JournalItem.TaxCode = 'G6' or JournalItem.TaxCode = 'H5'
      or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
      or JournalItem.TaxCode = 'C6' or JournalItem.TaxCode = 'D6'
      or JournalItem.TaxCode = 'PA'
      then (cast(100 as abap.fltp)*0.05)

      when JournalItem.TaxCode = 'G7' or JournalItem.TaxCode = 'H6'
      or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
      or JournalItem.TaxCode = 'C7' or JournalItem.TaxCode = 'D7'
      or JournalItem.TaxCode = 'PB'
      then (cast(100 as abap.fltp)*0.12)

      when JournalItem.TaxCode = 'G8' or JournalItem.TaxCode = 'H7'
      or JournalItem.TaxCode = 'G9' or JournalItem.TaxCode = 'H8'
      or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
      or JournalItem.TaxCode = 'C8' or JournalItem.TaxCode = 'D8'
      or JournalItem.TaxCode = 'F3' or JournalItem.TaxCode = 'F6'
      or JournalItem.TaxCode = 'PC'
      then (cast(100 as abap.fltp)*0.18)

      when JournalItem.TaxCode = 'A9' or JournalItem.TaxCode = 'B9'
      or JournalItem.TaxCode = 'C9' or JournalItem.TaxCode = 'D9'
      or JournalItem.TaxCode = 'PD'
      then (cast(100 as abap.fltp)*0.28)
      end                                                       as IGST_PERC,



      case
      when JournalItem.TaxCode = 'F5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
        end                                                     as UTGST,

      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
        end                                                     as RSGST,
      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
       end                                                      as RCGST,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.03)
      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'R9'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
        end                                                     as RIGST,

      case when JournalItem.Quantity is not initial and JournalItem.ReferenceDocumentType = 'VBRK' then
      'BaseAmt' else
      case when JournalItem.ReferenceDocumentType = 'BKPF' then
      'JOURNALENTRY_AMOUNT'
       end end                                                  as Qty,
      JournalItem.AccountingDocumentType                        as AccountingDocumentType,
      GetSupplier.Customer                                      as Customer,
      GetSupplier.Supplier                                      as supplier,
      JournalItem.OffsettingAccount                             as offsetting

}
where
  //      JournalItem.PurchasingDocument     <> ''
  //  and
  //       JournalItem.DebitCreditCode        =  'S'
  //  and
  //   gstr2.Billing_Doc_No is not initial

  //       JournalItem.IsReversal             <> 'X'
  //       JournalItem.IsReversed             <> 'X'

       JournalItem.OffsettingAccount           <> ''
  and  JournalItem.Ledger                      =  '0L'
  and  JournalItem.AmountInCompanyCodeCurrency <> 0
  and  JournalItem.FinancialAccountType        =  'S'
  //  and JournalItem.AccountingDocument <> '1900000021'
  and  JournalItem.ReferenceDocumentItem       <> '000000'
  and(
       JournalItem.AccountingDocumentType      =  'DR'
    or JournalItem.AccountingDocumentType      =  'DG'
    or JournalItem.AccountingDocumentType      =  'RV'
  )

  and  JournalItem.GLAccount                   <> '0066000130'
  and  JournalItem.GLAccount                   <> '0066000120'
  and  JournalItem.GLAccount                   <> '0066000140'
  and  JournalItem.GLAccount                   <> '0012605901'
  and  JournalItem.GLAccount                   <> '0012605900'
  and  JournalItem.GLAccount                   <> '0012605902'
  and  JournalItem.GLAccount                   <> '0012605903'
  and  JournalItem.GLAccount                   <> '0012605905'
  and  JournalItem.GLAccount                   <> '0012605904'
  and  JournalItem.GLAccount                   <> '0012605906'
  and  JournalItem.GLAccount                   <> '0012605907'
  and  JournalItem.GLAccount                   <> '0012605908'
  //     and JournalItem.GLAccount <> '0012605908'
  and  JournalItem.GLAccount                   <> '0012605909'
  and  JournalItem.GLAccount                   <> '0012605910'
  and  JournalItem.GLAccount                   <> '0012605911'
  and  JournalItem.GLAccount                   <> '0012605912'
  and  JournalItem.GLAccount                   <> '0012605913'
  and  JournalItem.GLAccount                   <> '0012605914'
  and  JournalItem.GLAccount                   <> '0012605915'
  and  JournalItem.GLAccount                   <> '0012605916'
  and  JournalItem.GLAccount                   <> '0012605917'
  and  JournalItem.GLAccount                   <> '0012605918'
  and  JournalItem.GLAccount                   <> '0012605919'
  and  JournalItem.GLAccount                   <> '0012605920'
  and  JournalItem.GLAccount                   <> '0012605921'
  and  JournalItem.GLAccount                   <> '0012605922'
  and  JournalItem.GLAccount                   <> '0012605923'
  and  JournalItem.GLAccount                   <> '0012605924'
  and  JournalItem.GLAccount                   <> '0012605925'
  and  JournalItem.GLAccount                   <> '0022005150'
  and  JournalItem.GLAccount                   <> '0022090100' //newly Added
  and  JournalItem.GLAccount                   <> '0022005104' //newly Added
  and  JournalItem.GLAccount                   <> '0022005103' //newly Added
  and  JournalItem.GLAccount                   <> '0022005112' //newly Added
  and  JournalItem.GLAccount                   <> '0022005113' //newly Added
  and  JournalItem.GLAccount                   <> '0022090600' //newly Added
  and  JournalItem.GLAccount                   <> '0022090200' //newly Added
  and  JournalItem.GLAccount                   <> '0012540000' //newly Added
  and  JournalItem.GLAccount                   <> '0065008320' //newly Added
  and  JournalItem.GLAccount                   <> '0051100900' //newly Added
  and  JournalItem.GLAccount                   <> '0041000120' //newly Added
  and  JournalItem.GLAccount                   <> '0022005100' //newly Added
  and  JournalItem.GLAccount                   <> '0022005101' //newly Added
  and  JournalItem.GLAccount                   <> '0022005110' //newly Added
  and  JournalItem.GLAccount                   <> '0022005109' //newly Added
  and  JournalItem.GLAccount                   <> '0022091100' //newly Added 22091100 0022005102
  and  JournalItem.GLAccount                   <> '0022005102' //newly Added
  and  JournalItem.GLAccount                   <> '0012605913' //newly Added
  and  JournalItem.GLAccount                   <> '0022510150' //newly Added
  and  JournalItem.GLAccount                   <> '0012543000' //newly Added
  and  JournalItem.GLAccount                   <> '0022005111' //newly Added
//  and  JournalItem.GLAccount                   <> '0051900000' //(+)by Anurag 06.09.2024
//  and  JournalItem.GLAccount                   <> '0041000120' //(+) by Anurag 
