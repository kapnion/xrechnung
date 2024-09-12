<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">

    <!-- Output format as HTML -->
    <xsl:output method="html" encoding="UTF-8" indent="yes" />

    <!-- Template match for the root element -->
    <xsl:template match="/">
        <html>
            <head>
                <title>UBL Rechnung</title>
                <style>
                    body { font-family: Arial, sans-serif; }
                    table { border-collapse: collapse; width: 100%; }
                    th, td { border: 1px solid #ddd; padding: 8px; }
                    th { background-color: #f2f2f2; }
                    h2 { color: #4CAF50; }
                </style>
            </head>
            <body>
                <h1>Rechnungsdetails</h1>

                <h2>Grundinformation</h2>
                <table>
                    <tr><th>Customization ID</th><td><xsl:value-of select="ubl:Invoice/cbc:CustomizationID" /></td></tr>
                    <tr><th>Profile ID</th><td><xsl:value-of select="ubl:Invoice/cbc:ProfileID" /></td></tr>
                    <tr><th>Rechnungsnummer</th><td><xsl:value-of select="ubl:Invoice/cbc:ID" /></td></tr>
                    <tr><th>Ausstellungsdatum</th><td><xsl:value-of select="ubl:Invoice/cbc:IssueDate" /></td></tr>
                    <tr><th>Rechnungstypcode</th><td><xsl:value-of select="ubl:Invoice/cbc:InvoiceTypeCode" /></td></tr>
                    <tr><th>Währungscode</th><td><xsl:value-of select="ubl:Invoice/cbc:DocumentCurrencyCode" /></td></tr>
                    <tr><th>Käuferreferenz</th><td><xsl:value-of select="ubl:Invoice/cbc:BuyerReference" /></td></tr>
                </table>

                <h2>Informationen zum Lieferanten</h2>
                <table>
                    <tr><th>Lieferant E-Mail</th><td><xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" /></td></tr>
                    <tr><th>Lieferant Name</th><td><xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" /></td></tr>
                    <tr><th>Lieferant Adresse</th><td>
                        <xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
                    </td></tr>
                    <tr><th>Lieferant Steuer-ID</th><td><xsl:value-of select="ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" /></td></tr>
                </table>

                <h2>Informationen zum Kunden</h2>
                <table>
                    <tr><th>Kunde E-Mail</th><td><xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" /></td></tr>
                    <tr><th>Kunde Name</th><td><xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" /></td></tr>
                    <tr><th>Kunde Adresse</th><td>
                        <xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />,
                        <xsl:value-of select="ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
                    </td></tr>
                </table>

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
                        <xsl:for-each select="ubl:Invoice/cac:InvoiceLine">
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

                <h2>Steuerdetails</h2>
                <table>
                    <tr><th>Steuerbarer Betrag</th><td><xsl:value-of select="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" /> <xsl:value-of select="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/@currencyID" /></td></tr>
                    <tr><th>Steuerbetrag</th><td><xsl:value-of select="ubl:Invoice/cac:TaxTotal/cbc:TaxAmount" /> <xsl:value-of select="ubl:Invoice/cac:TaxTotal/cbc:TaxAmount/@currencyID" /></td></tr>
                    <tr><th>Steuersatz</th><td><xsl:value-of select="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent" />%</td></tr>
                </table>

                <h2>Zahlungsinformationen</h2>
                <table>
                    <tr><th>Zahlungsmittelcode</th><td><xsl:value-of select="ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" /></td></tr>
                    <tr><th>Zahlungsempfänger-Konto</th><td><xsl:value-of select="ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID" /></td></tr>
                    <tr><th>Zahlungsbedingungen</th><td><xsl:value-of select="ubl:Invoice/cac:PaymentTerms/cbc:Note" /></td></tr>
                </table>

                <h2>Summen</h2>
                <table>
                    <tr><th>Positionsbetrag</th><td><xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" /> <xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount/@currencyID" /></td></tr>
                    <tr><th>Betrag ohne Steuern</th><td><xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" /> <xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/@currencyID" /></td></tr>
                    <tr><th>SBetrag mit Steuern</th><td><xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" /> <xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/@currencyID" /></td></tr>
                    <tr><th>Zahlbarer Betrag</th><td><xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" /> <xsl:value-of select="ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount/@currencyID" /></td></tr>
                </table>

            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
