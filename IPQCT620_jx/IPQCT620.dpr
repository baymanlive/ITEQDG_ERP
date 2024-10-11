program IPQCT620;

uses
  Forms,
  unIPQCT620 in 'unIPQCT620.pas' {FrmIPQCT620},
  unIPQCT620_login in 'unIPQCT620_login.pas' {FrmIPQCT620_login},
  unIPQCT620_waste_pno in 'unIPQCT620_waste_pno.pas' {FrmIPQCT620_waste_pno};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '調膠發工單';
  Application.CreateForm(TFrmIPQCT620, FrmIPQCT620);
  Application.Run;
end.
