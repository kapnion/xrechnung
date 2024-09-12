import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Component({
  selector: 'app-xslttransformer',
  standalone: true,
  imports: [],
  templateUrl: './xslttransformer.component.html',
  styleUrl: './xslttransformer.component.scss'
})
export class XSLTTransformerComponent {
  xmlContent: string | null = null;
  xsltContent: string | null = null;
  transformedContent: SafeHtml | null = null;
  defaultXsltPath = 'default.xsl';

  constructor(private sanitizer: DomSanitizer, private http: HttpClient) { }

  ngOnInit() {
    this.loadDefaultXslt();
  }

  loadDefaultXslt() {
    this.http.get(this.defaultXsltPath, { responseType: 'text' }).subscribe(
      (data) => {
        this.xsltContent = data;
      },
      (error: any) => {
        console.error('Error loading default XSLT:', error);
      }
    );
  }

  onXmlFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: ProgressEvent<FileReader>) => {
        this.xmlContent = e.target?.result as string;
      };
      reader.readAsText(file);
    }
  }

  onXsltFileSelected(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: ProgressEvent<FileReader>) => {
        this.xsltContent = e.target?.result as string;
      };
      reader.readAsText(file);
    } else {
      this.loadDefaultXslt();
    }
  }

  transform() {
    if (this.xmlContent && this.xsltContent) {
      const parser = new DOMParser();
      const xmlDoc = parser.parseFromString(this.xmlContent, 'text/xml');
      const xsltDoc = parser.parseFromString(this.xsltContent, 'text/xml');

      const xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsltDoc);
      const resultDoc = xsltProcessor.transformToDocument(xmlDoc);

      const serializer = new XMLSerializer();
      const resultString = serializer.serializeToString(resultDoc);

      // Sanitize the HTML to prevent XSS attacks
      this.transformedContent = this.sanitizer.bypassSecurityTrustHtml(resultString);
    }
  }
}
