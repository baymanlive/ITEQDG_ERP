program DLIR110;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'dlir110 email';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
