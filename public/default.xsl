<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
    xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
    xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Rechnung</title>
                <style>
                    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                    h1, h2 { color: #2c3e50; }
                    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; }
                    .section { margin-bottom: 30px; }
                    .attachment { margin-top: 10px; }
                </style>
            </head>
            <body>
                <h1>Rechnung</h1>
                <xsl:choose>
                    <xsl:when test="//rsm:CrossIndustryInvoice">
                        <xsl:apply-templates select="//rsm:CrossIndustryInvoice"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="//ubl:Invoice"/>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <!-- UN/CEFACT CrossIndustryInvoice Templates -->
    <xsl:template match="rsm:CrossIndustryInvoice">
        <!-- Document Information -->
        <div class="section">
            <h2>Dokumentinformationen</h2>
            <table>
                <tr><th>Dokument-ID</th><td><xsl:value-of select="rsm:ExchangedDocument/ram:ID"/></td></tr>
                <tr><th>Dokumenttyp</th><td><xsl:value-of select="rsm:ExchangedDocument/ram:TypeCode"/></td></tr>
                <tr><th>Ausstellungsdatum</th><td><xsl:value-of select="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"/></td></tr>
            </table>
            <xsl:if test="rsm:ExchangedDocument/ram:IncludedNote">
                <h3>Hinweis</h3>
                <p><xsl:value-of select="rsm:ExchangedDocument/ram:IncludedNote/ram:Content"/></p>
            </xsl:if>
        </div>

        <!-- Seller Information -->
        <div class="section">
            <h2>Verkäuferinformationen</h2>
            <xsl:apply-templates select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"/>
        </div>

        <!-- Buyer Information -->
        <div class="section">
            <h2>Käuferinformationen</h2>
            <xsl:apply-templates select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"/>
        </div>

        <!-- Line Items -->
        <div class="section">
            <h2>Einzelposten</h2>
            <xsl:apply-templates select="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem"/>
        </div>

        <!-- Payment Information -->
        <div class="section">
            <h2>Zahlungsinformationen</h2>
            <xsl:apply-templates select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement"/>
        </div>

        <!-- Attachments -->
        <div class="section">
            <h2>Anhänge</h2>
            <xsl:apply-templates select="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument"/>
        </div>
    </xsl:template>

    <!-- UBL Invoice Templates -->
    <xsl:template match="ubl:Invoice">
        <!-- Basic Information -->
        <h2>Grundinformation</h2>
        <table>
            <tr><th>Customization ID</th><td><xsl:value-of select="cbc:CustomizationID" /></td></tr>
            <tr><th>Profile ID</th><td><xsl:value-of select="cbc:ProfileID" /></td></tr>
            <tr><th>Rechnungsnummer</th><td><xsl:value-of select="cbc:ID" /></td></tr>
            <tr><th>Ausstellungsdatum</th><td><xsl:value-of select="cbc:IssueDate" /></td></tr>
            <tr><th>Rechnungstypcode</th><td><xsl:value-of select="cbc:InvoiceTypeCode" /></td></tr>
            <tr><th>Währungscode</th><td><xsl:value-of select="cbc:DocumentCurrencyCode" /></td></tr>
            <tr><th>Käuferreferenz</th><td><xsl:value-of select="cbc:BuyerReference" /></td></tr>
        </table>

        <!-- Supplier Information -->
        <h2>Informationen zum Lieferanten</h2>
        <table>
            <tr><th>Lieferant E-Mail</th><td><xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" /></td></tr>
            <tr><th>Lieferant Name</th><td><xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" /></td></tr>
            <tr><th>Lieferant Adresse</th><td>
                <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />,
                <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />,
                <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />,
                <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
            </td></tr>
            <tr><th>Lieferant Steuer-ID</th><td><xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" /></td></tr>
        </table>

        <!-- Customer Information -->
        <h2>Informationen zum Kunden</h2>
        <table>
            <tr><th>Kunde E-Mail</th><td><xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" /></td></tr>
            <tr><th>Kunde Name</th><td><xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" /></td></tr>
            <tr><th>Kunde Adresse</th><td>
                <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />,
                <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />,
                <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />,
                <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
            </td></tr>
        </table>

        <!-- Invoice Lines -->
        <h2>Rechnungszeilen</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Beschreibung</th>
                    <th>Menge</th>
                    <th>Preis</th>
                    <th>Positionsbetrag</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="cac:InvoiceLine">
                    <tr>
                        <td><xsl:value-of select="cbc:ID" /></td>
                        <td><xsl:value-of select="cac:Item/cbc:Description" /></td>
                        <td><xsl:value-of select="cbc:InvoicedQuantity" /> <xsl:value-of select="cbc:InvoicedQuantity/@unitCode" /></td>
                        <td><xsl:value-of select="cac:Price/cbc:PriceAmount" /> <xsl:value-of select="cac:Price/cbc:PriceAmount/@currencyID" /></td>
                        <td><xsl:value-of select="cbc:LineExtensionAmount" /> <xsl:value-of select="cbc:LineExtensionAmount/@currencyID" /></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>

        <!-- Tax Details -->
        <h2>Steuerdetails</h2>
        <table>
            <tr><th>Steuerbarer Betrag</th><td><xsl:value-of select="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" /> <xsl:value-of select="cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/@currencyID" /></td></tr>
            <tr><th>Steuerbetrag</th><td><xsl:value-of select="cac:TaxTotal/cbc:TaxAmount" /> <xsl:value-of select="cac:TaxTotal/cbc:TaxAmount/@currencyID" /></td></tr>
            <tr><th>Steuersatz</th><td><xsl:value-of select="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent" />%</td></tr>
        </table>

        <!-- Payment Information -->
        <h2>Zahlungsinformationen</h2>
        <table>
            <tr><th>Zahlungsmittelcode</th><td><xsl:value-of select="cac:PaymentMeans/cbc:PaymentMeansCode" /></td></tr>
            <tr><th>Zahlungsempfänger-Konto</th><td><xsl:value-of select="cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID" /></td></tr>
            <tr><th>Zahlungsbedingungen</th><td><xsl:value-of select="cac:PaymentTerms/cbc:Note" /></td></tr>
        </table>

        <!-- Totals -->
        <h2>Summen</h2>
        <table>
            <tr><th>Positionsbetrag</th><td><xsl:value-of select="cac:LegalMonetaryTotal/cbc:LineExtensionAmount" /> <xsl:value-of select="cac:LegalMonetaryTotal/cbc:LineExtensionAmount/@currencyID" /></td></tr>
            <tr><th>Betrag ohne Steuern</th><td><xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" /> <xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/@currencyID" /></td></tr>
            <tr><th>Betrag mit Steuern</th><td><xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" /> <xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID" /></td></tr>
            <tr><th>Zahlbarer Betrag</th><td><xsl:value-of select="cac:LegalMonetaryTotal/cbc:PayableAmount" /> <xsl:value-of select="cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID" /></td></tr>
        </table>
    </xsl:template>

    <!-- Cross Industry Invoice Templates -->
    <xsl:template match="ram:SellerTradeParty|ram:BuyerTradeParty">
        <table>
            <tr><th>Name</th><td><xsl:value-of select="ram:Name"/></td></tr>
            <xsl:if test="ram:GlobalID">
                <tr><th>Globale ID</th><td><xsl:value-of select="ram:GlobalID"/></td></tr>
            </xsl:if>
            <xsl:if test="ram:Description">
                <tr><th>Beschreibung</th><td><xsl:value-of select="ram:Description"/></td></tr>
            </xsl:if>
            <xsl:if test="ram:PostalTradeAddress">
                <tr><th>Adresse</th><td>
                    <xsl:value-of select="ram:PostalTradeAddress/ram:LineOne"/><br/>
                    <xsl:value-of select="ram:PostalTradeAddress/ram:CityName"/>,
                    <xsl:value-of select="ram:PostalTradeAddress/ram:PostcodeCode"/><br/>
                    <xsl:value-of select="ram:PostalTradeAddress/ram:CountryID"/>
                </td></tr>
            </xsl:if>
        </table>
    </xsl:template>

    <xsl:template match="ram:IncludedSupplyChainTradeLineItem">
        <h3>Einzelposten <xsl:value-of select="ram:AssociatedDocumentLineDocument/ram:LineID"/></h3>
        <table>
            <tr><th>Produktname</th><td><xsl:value-of select="ram:SpecifiedTradeProduct/ram:Name"/></td></tr>
            <tr><th>Menge</th><td><xsl:value-of select="ram:SpecifiedLineTradeDelivery/ram:BilledQuantity"/></td></tr>
            <tr><th>Stückpreis</th><td><xsl:value-of select="ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount"/></td></tr>
            <tr><th>Zeilensumme</th><td><xsl:value-of select="ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount"/></td></tr>
        </table>
    </xsl:template>

    <xsl:template match="ram:ApplicableHeaderTradeSettlement">
        <table>
            <tr><th>Zahlungsreferenz</th><td><xsl:value-of select="ram:PaymentReference"/></td></tr>
            <tr><th>Währung</th><td><xsl:value-of select="ram:InvoiceCurrencyCode"/></td></tr>
            <tr><th>Zahlungsbedingungen</th><td><xsl:value-of select="ram:SpecifiedTradePaymentTerms/ram:Description"/></td></tr>
            <tr><th>Gesamtbetrag</th><td><xsl:value-of select="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount"/></td></tr>
        </table>
    </xsl:template>

    <xsl:template match="ram:AdditionalReferencedDocument">
        <div class="attachment">
            <h3><xsl:value-of select="ram:Name"/></h3>
            <p>Typ: <xsl:value-of select="ram:TypeCode"/></p>
            <xsl:if test="ram:AttachmentBinaryObject">
                <object>
                    <xsl:attribute name="data">
                        data:<xsl:value-of select="ram:AttachmentBinaryObject/@mimeCode"/>;base64,<xsl:value-of select="ram:AttachmentBinaryObject"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="ram:AttachmentBinaryObject/@mimeCode"/>
                    </xsl:attribute>
                    <xsl:attribute name="width">50%</xsl:attribute>
                    <xsl:attribute name="height">600px</xsl:attribute>
                </object>
            </xsl:if>
        </div>
    </xsl:template>

</xsl:stylesheet>
