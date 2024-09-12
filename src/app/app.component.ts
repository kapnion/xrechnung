import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { XSLTTransformerComponent } from './xslttransformer/xslttransformer.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, XSLTTransformerComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'edoc_xtra';
}
