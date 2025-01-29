namespace Berrill.API.Demo;

using Microsoft.Integration.Entity;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.Currency;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Integration.Graph;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Posting;
using Microsoft.Utilities;
using System.Reflection;

page 50900 "Purchase Orders PAB"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Purchase Order';
    EntitySetCaption = 'Purchase Orders';
    APIGroup = 'demoApi';
    APIPublisher = 'blueSky';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'purchaseOrder';
    EntitySetName = 'purchaseOrders';
    ODataKeyFields = Id;
    PageType = API;
    SourceTable = "Purchase Order Entity Buffer";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo(Id));
                    end;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(orderDate; Rec."Document Date")
                {
                    Caption = 'Order Date';

                    trigger OnValidate()
                    begin
                        this.DocumentDateVar := Rec."Document Date";
                        this.DocumentDateSet := true;

                        this.RegisterFieldSet(Rec.FieldNo("Document Date"));
                    end;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';

                    trigger OnValidate()
                    begin
                        this.PostingDateVar := Rec."Posting Date";
                        this.PostingDateSet := true;

                        this.RegisterFieldSet(Rec.FieldNo("Posting Date"));
                    end;
                }
                field(vendorId; Rec."Vendor Id")
                {
                    Caption = 'Vendor Id';

                    trigger OnValidate()
                    begin
                        if not this.BuyFromVendor.GetBySystemId(Rec."Vendor Id") then
                            Error(this.CouldNotFindBuyFromVendorErr);

                        Rec."Buy-from Vendor No." := this.BuyFromVendor."No.";
                        this.RegisterFieldSet(Rec.FieldNo("Vendor Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Vendor No."));
                    end;
                }
                field(vendorNumber; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';

                    trigger OnValidate()
                    begin
                        if this.BuyFromVendor."No." <> '' then begin
                            if this.BuyFromVendor."No." <> Rec."Buy-from Vendor No." then
                                Error(this.BuyFromVendorValuesDontMatchErr);
                            exit;
                        end;

                        if not this.BuyFromVendor.Get(Rec."Buy-from Vendor No.") then
                            Error(this.CouldNotFindBuyFromVendorErr);

                        Rec."Vendor Id" := this.BuyFromVendor.SystemId;
                        this.RegisterFieldSet(Rec.FieldNo("Vendor Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Vendor No."));
                    end;
                }
                field(vendorName; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(payToName; Rec."Pay-to Name")
                {
                    Caption = 'Pay-to Name';
                    Editable = false;
                }
                field(payToVendorId; Rec."Pay-to Vendor Id")
                {
                    Caption = 'Pay-to Vendor Id';

                    trigger OnValidate()
                    begin
                        if not this.PayToVendor.GetBySystemId(Rec."Pay-to Vendor Id") then
                            Error(this.CouldNotFindPayToVendorErr);

                        Rec."Pay-to Vendor No." := this.PayToVendor."No.";
                        this.RegisterFieldSet(Rec.FieldNo("Pay-to Vendor Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Pay-to Vendor No."));
                    end;
                }
                field(payToVendorNumber; Rec."Pay-to Vendor No.")
                {
                    Caption = 'Pay-to Vendor No.';

                    trigger OnValidate()
                    begin
                        if this.PayToVendor."No." <> '' then begin
                            if this.PayToVendor."No." <> Rec."Pay-to Vendor No." then
                                Error(this.PayToVendorValuesDontMatchErr);
                            exit;
                        end;

                        if not this.PayToVendor.Get(Rec."Pay-to Vendor No.") then
                            Error(this.CouldNotFindPayToVendorErr);

                        Rec."Pay-to Vendor Id" := this.PayToVendor.SystemId;
                        this.RegisterFieldSet(Rec.FieldNo("Pay-to Vendor Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Pay-to Vendor No."));
                    end;
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Name" <> Rec."Ship-to Name" then begin
                            Rec."Ship-to Code" := '';
                            this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                            this.RegisterFieldSet(Rec.FieldNo("Ship-to Name"));
                        end;
                    end;
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';

                    trigger OnValidate()
                    begin
                        if xRec."Ship-to Contact" <> Rec."Ship-to Contact" then begin
                            Rec."Ship-to Code" := '';
                            this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                            this.RegisterFieldSet(Rec.FieldNo("Ship-to Contact"));
                        end;
                    end;
                }
                field(buyFromAddressLine1; Rec."Buy-from Address")
                {
                    Caption = 'Buy-from Address Line 1';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Address"));
                    end;
                }
                field(buyFromAddressLine2; Rec."Buy-from Address 2")
                {
                    Caption = 'Buy-from Address Line 2';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Address 2"));
                    end;
                }
                field(buyFromCity; Rec."Buy-from City")
                {
                    Caption = 'Buy-from City';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from City"));
                    end;
                }
                field(buyFromCountry; Rec."Buy-from Country/Region Code")
                {
                    Caption = 'Buy-from Country/Region Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Country/Region Code"));
                    end;
                }
                field(buyFromState; Rec."Buy-from County")
                {
                    Caption = 'Buy-from State';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from County"));
                    end;
                }
                field(buyFromPostCode; Rec."Buy-from Post Code")
                {
                    Caption = 'Buy-from Post Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Buy-from Post Code"));
                    end;
                }
                field(payToAddressLine1; Rec."Pay-to Address")
                {
                    Caption = 'Pay-to Address Line 1';
                    Editable = false;
                }
                field(payToAddressLine2; Rec."Pay-to Address 2")
                {
                    Caption = 'Pay-to Address Line 2';
                    Editable = false;
                }
                field(payToCity; Rec."Pay-to City")
                {
                    Caption = 'Pay-to City';
                    Editable = false;
                }
                field(payToCountry; Rec."Pay-to Country/Region Code")
                {
                    Caption = 'Pay-to Country/Region Code';
                    Editable = false;
                }
                field(payToState; Rec."Pay-to County")
                {
                    Caption = 'Pay-to State';
                    Editable = false;
                }
                field(payToPostCode; Rec."Pay-to Post Code")
                {
                    Caption = 'Pay-to Post Code';
                    Editable = false;
                }
                field(shipToAddressLine1; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address Line 1';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Address"));
                    end;
                }
                field(shipToAddressLine2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address Line 2';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Address 2"));
                    end;
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to City"));
                    end;
                }
                field(shipToCountry; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Country/Region Code"));
                    end;
                }
                field(shipToState; Rec."Ship-to County")
                {
                    Caption = 'Ship-to State';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to County"));
                    end;
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';

                    trigger OnValidate()
                    begin
                        Rec."Ship-to Code" := '';
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Code"));
                        this.RegisterFieldSet(Rec.FieldNo("Ship-to Post Code"));
                    end;
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Shortcut Dimension 1 Code"));
                    end;
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Shortcut Dimension 2 Code"));
                    end;
                }
                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';

                    trigger OnValidate()
                    begin
                        if Rec."Currency Id" = this.BlankGUID then
                            Rec."Currency Code" := ''
                        else begin
                            if not this.Currency.GetBySystemId(Rec."Currency Id") then
                                Error(this.CurrencyIdDoesNotMatchACurrencyErr);

                            Rec."Currency Code" := this.Currency.Code;
                        end;

                        this.RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(currencyCode; this.CurrencyCodeTxt)
                {
                    Caption = 'Currency Code';

                    trigger OnValidate()
                    begin
                        Rec."Currency Code" :=
                          this.GraphMgtGeneralTools.TranslateCurrencyCodeToNAVCurrencyCode(
                            this.LCYCurrencyCode, COPYSTR(this.CurrencyCodeTxt, 1, MAXSTRLEN(this.LCYCurrencyCode)));

                        if this.Currency.Code <> '' then begin
                            if this.Currency.Code <> Rec."Currency Code" then
                                Error(this.CurrencyValuesDontMatchErr);
                            exit;
                        end;

                        if Rec."Currency Code" = '' then
                            Rec."Currency Id" := this.BlankGUID
                        else begin
                            if not this.Currency.Get(Rec."Currency Code") then
                                Error(this.CurrencyCodeDoesNotMatchACurrencyErr);

                            Rec."Currency Id" := this.Currency.SystemId;
                        end;

                        this.RegisterFieldSet(Rec.FieldNo("Currency Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Currency Code"));
                    end;
                }
                field(pricesIncludeTax; Rec."Prices Including VAT")
                {
                    Caption = 'Prices Include Tax';

                    trigger OnValidate()
                    var
                        PurchaseLine: Record "Purchase Line";
                    begin
                        if Rec."Prices Including VAT" then begin
                            PurchaseLine.SetRange("Document No.", Rec."No.");
                            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                            if PurchaseLine.FindFirst() then
                                if PurchaseLine."VAT Calculation Type" = PurchaseLine."VAT Calculation Type"::"Sales Tax" then
                                    Error(this.CannotEnablePricesIncludeTaxErr);
                        end;
                        this.RegisterFieldSet(Rec.FieldNo("Prices Including VAT"));
                    end;
                }
                field(paymentTermsId; Rec."Payment Terms Id")
                {
                    Caption = 'Payment Terms Id';

                    trigger OnValidate()
                    begin
                        if Rec."Payment Terms Id" = this.BlankGUID then
                            Rec."Payment Terms Code" := ''
                        else begin
                            if not this.PaymentTerms.GetBySystemId(Rec."Payment Terms Id") then
                                Error(this.PaymentTermsIdDoesNotMatchAPaymentTermsErr);

                            Rec."Payment Terms Code" := this.PaymentTerms.Code;
                        end;

                        this.RegisterFieldSet(Rec.FieldNo("Payment Terms Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Payment Terms Code"));
                    end;
                }
                field(shipmentMethodId; Rec."Shipment Method Id")
                {
                    Caption = 'Shipment Method Id';

                    trigger OnValidate()
                    begin
                        if Rec."Shipment Method Id" = this.BlankGUID then
                            Rec."Shipment Method Code" := ''
                        else begin
                            if not this.ShipmentMethod.GetBySystemId(Rec."Shipment Method Id") then
                                Error(this.ShipmentMethodIdDoesNotMatchAShipmentMethodErr);

                            Rec."Shipment Method Code" := this.ShipmentMethod.Code;
                        end;

                        this.RegisterFieldSet(Rec.FieldNo("Shipment Method Id"));
                        this.RegisterFieldSet(Rec.FieldNo("Shipment Method Code"));
                    end;
                }
                field(purchaser; Rec."Purchaser Code")
                {
                    Caption = 'Purchaser';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Purchaser Code"));
                    end;
                }
                field(requestedReceiptDate; Rec."Requested Receipt Date")
                {
                    Caption = 'Requested Receipt Date';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Requested Receipt Date"));
                    end;
                }
                part(purchaseOrderLines; "Purchase Order Lines PAB")
                {
                    Caption = 'Lines';
                    EntityName = 'purchaseOrderLine';
                    EntitySetName = 'purchaseOrderLines';
                    SubPageLink = "Document Id" = field(Id);
                }
                field(discountAmount; Rec."Invoice Discount Amount")
                {
                    Caption = 'Discount Amount';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Invoice Discount Amount"));
                        this.InvoiceDiscountAmount := Rec."Invoice Discount Amount";
                        this.DiscountAmountSet := true;
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    Caption = 'Discount Applied Before Tax';
                    Editable = false;
                }
                field(totalAmountExcludingTax; Rec.Amount)
                {
                    Caption = 'Total Amount Excluding Tax';
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Total Tax Amount")
                {
                    Caption = 'Total Tax Amount';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Total Tax Amount"));
                    end;
                }
                field(totalAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'Total Amount Including Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                    end;
                }
                field(fullyReceived; Rec."Completely Received")
                {
                    Caption = 'Fully Received';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Completely Received"));
                    end;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }

                // If these are needed add dependency to the API V2 app
                // part(attachments; "APIV2 - Attachments")
                // {
                //     Caption = 'Attachments';
                //     EntityName = 'attachment';
                //     EntitySetName = 'attachments';
                //     SubPageLink = "Document Id" = field(Id), "Document Type" = const("Purchase Order");
                // }
                // part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                // {
                //     Caption = 'Dimension Set Lines';
                //     EntityName = 'dimensionSetLine';
                //     EntitySetName = 'dimensionSetLines';
                //     SubPageLink = "Parent Id" = field(Id), "Parent Type" = const("Purchase Order");
                // }
                // part(documentAttachments; "APIV2 - Document Attachments")
                // {
                //     Caption = 'Document Attachments';
                //     EntityName = 'documentAttachment';
                //     EntitySetName = 'documentAttachments';
                //     SubPageLink = "Document Id" = field(Id), "Document Type" = const("Purchase Order");
                // }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        this.SetCalculatedFields();
        if this.HasWritePermission then
            this.GraphMgtPurchOrderBuffer.RedistributeInvoiceDiscounts(Rec);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        this.GraphMgtPurchOrderBuffer.PropagateOnDelete(Rec);

        exit(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        this.CheckBuyFromVendorSpecified();

        this.GraphMgtPurchOrderBuffer.PropagateOnInsert(Rec, this.TempFieldBuffer);
        this.SetDates();

        this.UpdateDiscount();

        this.SetCalculatedFields();

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Id <> Rec.Id then
            Error(this.CannotChangeIDErr);

        this.GraphMgtPurchOrderBuffer.PropagateOnModify(Rec, this.TempFieldBuffer);
        this.UpdateDiscount();

        this.SetCalculatedFields();

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        this.ClearCalculatedFields();
    end;

    trigger OnOpenPage()
    begin
        this.CheckPermissions();
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        BuyFromVendor: Record "Vendor";
        PayToVendor: Record "Vendor";
        Currency: Record "Currency";
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        GraphMgtPurchOrderBuffer: Codeunit "Graph Mgt - Purch Order Buffer";
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];
        CurrencyCodeTxt: Text;
        CannotChangeIDErr: Label 'The "id" cannot be changed.', Comment = 'id is a field name and should not be translated.';
        BuyFromVendorNotProvidedErr: Label 'A "vendorNumber" or a "vendorId" must be provided.', Comment = 'vendorNumber and vendorId are field names and should not be translated.';
        BuyFromVendorValuesDontMatchErr: Label 'The buy-from vendor values do not match to a specific Vendor.';
        PayToVendorValuesDontMatchErr: Label 'The pay-to vendor values do not match to a specific Vendor.';
        CouldNotFindBuyFromVendorErr: Label 'The buy-from vendor cannot be found.';
        CouldNotFindPayToVendorErr: Label 'The pay-to vendor cannot be found.';
        PurchaseOrderPermissionsErr: Label 'You do not have permissions to read Purchase Orders.';
        CurrencyValuesDontMatchErr: Label 'The currency values do not match to a specific Currency.';
        CurrencyIdDoesNotMatchACurrencyErr: Label 'The "currencyId" does not match to a Currency.', Comment = 'currencyId is a field name and should not be translated.';
        CurrencyCodeDoesNotMatchACurrencyErr: Label 'The "currencyCode" does not match to a Currency.', Comment = 'currencyCode is a field name and should not be translated.';
        CannotEnablePricesIncludeTaxErr: Label 'The "pricesIncludeTax" cannot be set to true if VAT Calculation Type is Sales Tax.', Comment = 'pricesIncludeTax is a field name and should not be translated.';
        PaymentTermsIdDoesNotMatchAPaymentTermsErr: Label 'The "paymentTermsId" does not match to a Payment Terms.', Comment = 'paymentTermsId is a field name and should not be translated.';
        ShipmentMethodIdDoesNotMatchAShipmentMethodErr: Label 'The "shipmentMethodId" does not match to a Shipment Method.', Comment = 'shipmentMethodId is a field name and should not be translated.';
        CannotFindOrderErr: Label 'The order cannot be found.';
        DiscountAmountSet: Boolean;
        InvoiceDiscountAmount: Decimal;
        BlankGUID: Guid;
        DocumentDateSet: Boolean;
        DocumentDateVar: Date;
        PostingDateSet: Boolean;
        PostingDateVar: Date;
        HasWritePermission: Boolean;

    local procedure SetCalculatedFields()
    begin
        this.CurrencyCodeTxt := this.GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(this.LCYCurrencyCode, Rec."Currency Code");
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(this.DiscountAmountSet);
        Clear(this.InvoiceDiscountAmount);

        this.TempFieldBuffer.DeleteAll();
    end;


    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if this.TempFieldBuffer.FindLast() then
            LastOrderNo := this.TempFieldBuffer.Order + 1;

        Clear(this.TempFieldBuffer);
        this.TempFieldBuffer.Order := LastOrderNo;
        this.TempFieldBuffer."Table ID" := Database::"Purchase Order Entity Buffer";
        this.TempFieldBuffer."Field ID" := FieldNo;
        this.TempFieldBuffer.Insert();
    end;

    local procedure CheckBuyFromVendorSpecified()
    begin
        if (Rec."Buy-from Vendor No." = '') and
           (Rec."Vendor Id" = this.BlankGUID)
        then
            Error(this.BuyFromVendorNotProvidedErr);
    end;

    local procedure CheckPermissions()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        if not PurchaseHeader.ReadPermission() then
            Error(this.PurchaseOrderPermissionsErr);

        this.HasWritePermission := PurchaseHeader.WritePermission();
    end;

    local procedure UpdateDiscount()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
    begin
        if not this.DiscountAmountSet then begin
            this.GraphMgtPurchOrderBuffer.RedistributeInvoiceDiscounts(Rec);
            exit;
        end;

        PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, Rec."No.");
        PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(this.InvoiceDiscountAmount, PurchaseHeader);
    end;

    local procedure SetDates()
    begin
        if not (this.DocumentDateSet or this.PostingDateSet) then
            exit;

        this.TempFieldBuffer.Reset();
        this.TempFieldBuffer.DeleteAll();

        if this.DocumentDateSet then begin
            Rec."Document Date" := this.DocumentDateVar;
            this.RegisterFieldSet(Rec.FieldNo("Document Date"));
        end;

        if this.PostingDateSet then begin
            Rec."Posting Date" := this.PostingDateVar;
            this.RegisterFieldSet(Rec.FieldNo("Posting Date"));
        end;

        this.GraphMgtPurchOrderBuffer.PropagateOnModify(Rec, this.TempFieldBuffer);
        Rec.Find();
    end;

    local procedure GetOrder(var PurchaseHeader: Record "Purchase Header")
    begin
        if not PurchaseHeader.GetBySystemId(Rec.Id) then
            Error(this.CannotFindOrderErr);
    end;

    local procedure PostInvoice(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        OrderNo: Code[20];
        OrderNoSeries: Code[20];
    begin
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader);
        OrderNo := PurchaseHeader."No.";
        OrderNoSeries := PurchaseHeader."No. Series";
        PurchaseHeader.Receive := true;
        PurchaseHeader.Invoice := true;
        PurchaseHeader.SendToPosting(Codeunit::"Purch.-Post");
        Commit(); // Purch.-Post does not always commit latest purchase invoice header
        PurchInvHeader.SetCurrentKey("Order No.");
        PurchInvHeader.SetRange("Order No.", OrderNo);
        PurchInvHeader.SetRange("Order No. Series", OrderNoSeries);
        PurchInvHeader.SetRange("Pre-Assigned No.", '');
        exit(PurchInvHeader.FindFirst());
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; DocumentId: Guid; ObjectId: Integer; ResultCode: WebServiceActionResultCode)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(ObjectId);
        ActionContext.AddEntityKey(Rec.FieldNo(Id), DocumentId);
        ActionContext.SetResultCode(ResultCode);
    end;
// If needed add ependency to the API V2 app
    // [ServiceEnabled]
    // [Scope('Cloud')]
    // procedure ReceiveAndInvoice(var ActionContext: WebServiceActionContext)
    // var
    //     PurchaseHeader: Record "Purchase Header";
    //     PurchInvHeader: Record "Purch. Inv. Header";
    //     PurchInvAggregator: Codeunit "Purch. Inv. Aggregator";
    //     Invoiced: Boolean;
    // begin
    //     this.GetOrder(PurchaseHeader);
    //     Invoiced := this.PostInvoice(PurchaseHeader, PurchInvHeader);
    //     if Invoiced then
    //         SetActionResponse(ActionContext, PurchInvAggregator.GetPurchaseInvoiceHeaderId(PurchInvHeader), Page::"APIV2 - Purchase Invoices", WebServiceActionResultCode::Deleted)
    //     else
    //         this.SetActionResponse(ActionContext, PurchaseHeader.SystemId, Page::"APIV2 - Purchase Orders", WebServiceActionResultCode::Updated);
    // end;
}