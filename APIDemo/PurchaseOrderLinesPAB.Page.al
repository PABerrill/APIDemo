namespace Berrill.API.Demo;

using Microsoft.Integration.Entity;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Integration.Graph;
using Microsoft.Inventory.Item;
using System.Reflection;

page 50901 "Purchase Order Lines PAB"
{
    DelayedInsert = true;
    APIVersion = 'v2.0';
    EntityCaption = 'Purchase Order Line';
    EntitySetCaption = 'Purchase Order Lines';
    PageType = API;
    APIGroup = 'demoApi';
    APIPublisher = 'blueSky';
    ODataKeyFields = SystemId;
    EntityName = 'purchaseOrderLine';
    EntitySetName = 'purchaseOrderLines';
    SourceTable = "Purch. Inv. Line Aggregate";
    SourceTableTemporary = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';

                    trigger OnValidate()
                    begin
                        if (not IsNullGuid(xRec."Document Id")) and (xRec."Document Id" <> Rec."Document Id") then
                            Error(this.CannotChangeDocumentIdNoErr);
                    end;
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';

                    trigger OnValidate()
                    begin
                        if (xRec."Line No." <> Rec."Line No.") and
                           (xRec."Line No." <> 0)
                        then
                            Error(this.CannotChangeLineNoErr);

                        this.RegisterFieldSet(Rec.FieldNo("Line No."));
                    end;
                }
                field(itemId; Rec."Item Id")
                {
                    Caption = 'Item Id';

                    trigger OnValidate()
                    begin
                        if not this.Item.GetBySystemId(Rec."Item Id") then
                            Error(this.ItemDoesNotExistErr);

                        this.RegisterFieldSet(Rec.FieldNo(Type));
                        this.RegisterFieldSet(Rec.FieldNo("No."));
                        this.RegisterFieldSet(Rec.FieldNo("Item Id"));

                        Rec."No." := this.Item."No.";
                    end;
                }
                field(accountId; Rec."Account Id")
                {
                    Caption = 'Account Id';

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                        EmptyGuid: Guid;
                    begin
                        if Rec."Account Id" <> EmptyGuid then
                            if this.Item."No." <> '' then
                                Error(this.BothItemIdAndAccountIdAreSpecifiedErr);

                        if not GLAccount.GetBySystemId(Rec."Account Id") then
                            Error(this.AccountDoesNotExistErr);

                        this.RegisterFieldSet(Rec.FieldNo(Type));
                        this.RegisterFieldSet(Rec.FieldNo("Account Id"));
                        this.RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(lineType; Rec."API Type")
                {
                    Caption = 'Line Type';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo(Type));
                    end;
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'Line Object No.';

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        if (xRec."No." <> Rec."No.") and (xRec."No." <> '') then
                            Error(this.CannotChangeLineObjectNoErr);

                        case Rec."API Type" of
                            Rec."API Type"::Item:
                                begin
                                    if not this.Item.Get(Rec."No.") then
                                        Error(this.ItemDoesNotExistErr);

                                    this.RegisterFieldSet(Rec.FieldNo("Item Id"));
                                    Rec."Item Id" := this.Item.SystemId;
                                end;
                            Rec."API Type"::Account:
                                begin
                                    if not GLAccount.Get(Rec."No.") then
                                        Error(this.AccountDoesNotExistErr);

                                    this.RegisterFieldSet(Rec.FieldNo("Account Id"));
                                    Rec."Account Id" := GLAccount.SystemId;
                                end;
                        end;
                        this.RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo(Description));
                    end;
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Description 2"));
                    end;
                }
                field(unitOfMeasureId; Rec."Unit of Measure Id")
                {
                    Caption = 'Unit Of Measure Id';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Unit of Measure Code"));
                    end;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Unit of Measure Code"));
                    end;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo(Quantity));
                    end;
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Direct Unit Cost"));
                    end;
                }
                field(discountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'Discount Amount';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Line Discount Amount"));
                    end;
                }
                field(discountPercent; Rec."Line Discount %")
                {
                    Caption = 'Discount Percent';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Line Discount %"));
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    Caption = 'Discount Applied Before Tax';
                    Editable = false;
                }
                field(amountExcludingTax; Rec."Line Amount Excluding Tax")
                {
                    Caption = 'Amount Excluding Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo(Amount));
                    end;
                }
                field(taxCode; Rec."Tax Code")
                {
                    Caption = 'Tax Code';

                    trigger OnValidate()
                    var
                        GeneralLedgerSetup: Record "General Ledger Setup";
                    begin
                        if GeneralLedgerSetup.UseVat() then begin
                            Rec.Validate("VAT Prod. Posting Group", COPYSTR(Rec."Tax Code", 1, 20));
                            this.RegisterFieldSet(Rec.FieldNo("VAT Prod. Posting Group"));
                        end else begin
                            Rec.Validate("Tax Group Code", COPYSTR(Rec."Tax Code", 1, 20));
                            this.RegisterFieldSet(Rec.FieldNo("Tax Group Code"));
                        end;
                    end;
                }
                field(taxPercent; Rec."VAT %")
                {
                    Caption = 'Tax Percent';
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Line Tax Amount")
                {
                    Caption = 'Total Tax Amount';
                    Editable = false;
                }
                field(amountIncludingTax; Rec."Line Amount Including Tax")
                {
                    Caption = 'Amount Including Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                    end;
                }
                field(invoiceDiscountAllocation; Rec."Inv. Discount Amount Excl. VAT")
                {
                    Caption = 'Invoice Discount Allocation';
                    Editable = false;
                }
                field(netAmount; Rec.Amount)
                {
                    Caption = 'Net Amount';
                    Editable = false;
                }
                field(netTaxAmount; Rec."Tax Amount")
                {
                    Caption = 'Net Tax Amount';
                    Editable = false;
                }
                field(netAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'Net Amount Including Tax';
                    Editable = false;
                }
                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Expected Receipt Date"));
                    end;
                }
                field(receivedQuantity; Rec."Quantity Received")
                {
                    Caption = 'Received Quantity';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Quantity Received"));
                    end;
                }
                field(invoicedQuantity; Rec."Quantity Invoiced")
                {
                    Caption = 'Invoiced Quantity';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Quantity Invoiced"));
                    end;
                }
                field(invoiceQuantity; Rec."Qty. to Invoice")
                {
                    Caption = 'Invoice Quantity';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Qty. to Invoice"));
                    end;
                }
                field(receiveQuantity; Rec."Qty. to Receive")
                {
                    Caption = 'Ship Quantity';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Qty. to Receive"));
                    end;
                }            
                field(itemVariant; Rec."Variant Code")
                {
                    Caption = 'Item Variant Code';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Variant Code"));
                    end;
                }
                field(itemVariantId; Rec."Variant Id")
                {
                    Caption = 'Item Variant Id';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Variant Code"));
                    end;
                }
                field(locationId; Rec."Location Id")
                {
                    Caption = 'Location Id';

                    trigger OnValidate()
                    begin
                        this.RegisterFieldSet(Rec.FieldNo("Location Code"));
                    end;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    var
        GraphMgtPurchOrderBuffer: Codeunit "Graph Mgt - Purch Order Buffer";
    begin
        GraphMgtPurchOrderBuffer.PropagateDeleteLine(Rec);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        GraphMgtPurchOrderBuffer: Codeunit "Graph Mgt - Purch Order Buffer";
        GraphMgtPurchInvLines: Codeunit "Graph Mgt - Purch. Inv. Lines";
        SysId: Guid;
        DocumentIdFilter: Text;
        IdFilter: Text;
        FilterView: Text;
    begin
        if not this.LinesLoaded then begin
            FilterView := Rec.GetView();
            IdFilter := Rec.GetFilter(SystemId);
            DocumentIdFilter := Rec.GetFilter("Document Id");
            if (IdFilter = '') and (DocumentIdFilter = '') then
                Error(this.IDOrDocumentIdShouldBeSpecifiedForLinesErr);
            if IdFilter <> '' then begin
                Evaluate(SysId, IdFilter);
                DocumentIdFilter := GraphMgtPurchInvLines.GetPurchaseOrderDocumentIdFilterFromSystemId(SysId);
            end else
                DocumentIdFilter := Rec.GetFilter("Document Id");
            GraphMgtPurchOrderBuffer.LoadLines(Rec, DocumentIdFilter);
            Rec.SetView(FilterView);
            if not Rec.FindFirst() then
                exit(false);
            this.LinesLoaded := true;
        end;

        exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GraphMgtPurchOrderBuffer: Codeunit "Graph Mgt - Purch Order Buffer";
    begin
        GraphMgtPurchOrderBuffer.PropagateInsertLine(Rec, this.TempFieldBuffer);
    end;

    trigger OnModifyRecord(): Boolean
    var
        GraphMgtPurchOrderBuffer: Codeunit "Graph Mgt - Purch Order Buffer";
    begin
        GraphMgtPurchOrderBuffer.PropagateModifyLine(Rec, this.TempFieldBuffer);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        this.ClearCalculatedFields();
        this.RegisterFieldSet(Rec.FieldNo(Type));
    end;

    var
        TempFieldBuffer: Record "Field Buffer" temporary;
        TempItemFieldSet: Record 2000000041 temporary;
        Item: Record "Item";
        LinesLoaded: Boolean;
        IDOrDocumentIdShouldBeSpecifiedForLinesErr: Label 'You must specify an Id or a Document Id to get the lines.';
        CannotChangeDocumentIdNoErr: Label 'The value for "documentId" cannot be modified.', Comment = 'documentId is a field name and should not be translated.';
        CannotChangeLineNoErr: Label 'The value for sequence cannot be modified. Delete and insert the line again.';
        BothItemIdAndAccountIdAreSpecifiedErr: Label 'Both "itemId" and "accountId" are specified. Specify only one of them.', Comment = 'itemId and accountId are field names and should not be translated.';
        ItemDoesNotExistErr: Label 'Item does not exist.';
        AccountDoesNotExistErr: Label 'Account does not exist.';
        CannotChangeLineObjectNoErr: Label 'The value for "lineObjectNumber" cannot be modified.', Comment = 'lineObjectNumber is a field name and should not be translated.';

    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if this.TempFieldBuffer.FindLast() then
            LastOrderNo := this.TempFieldBuffer.Order + 1;

        Clear(this.TempFieldBuffer);
        this.TempFieldBuffer.Order := LastOrderNo;
        this.TempFieldBuffer."Table ID" := Database::"Purch. Inv. Line Aggregate";
        this.TempFieldBuffer."Field ID" := FieldNo;
        this.TempFieldBuffer.Insert();
    end;

    local procedure ClearCalculatedFields()
    begin
        this.TempFieldBuffer.Reset();
        this.TempFieldBuffer.DeleteAll();
        this.TempItemFieldSet.Reset();
        this.TempItemFieldSet.DeleteAll();

        Clear(this.Item);
    end;
}