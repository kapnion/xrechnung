import { ComponentFixture, TestBed } from '@angular/core/testing';

import { XSLTTransformerComponent } from './xslttransformer.component';

describe('XSLTTransformerComponent', () => {
  let component: XSLTTransformerComponent;
  let fixture: ComponentFixture<XSLTTransformerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [XSLTTransformerComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(XSLTTransformerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
