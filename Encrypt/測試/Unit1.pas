unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure EncryptXX(SourceStr, DestStr:Pchar);stdcall;
  external 'Encrypt.dll' name 'Encrypt';
procedure DecryptXX(SourceStr, DestStr:Pchar);stdcall;
  external 'Encrypt.dll' name 'Decrypt';

procedure TForm1.Button1Click(Sender: TObject);
var
  P:Pchar;
begin
  P:=stralloc(1024);
  try
   EncryptXX(Pchar(Edit1.Text),P);
   Edit2.Text:=P;
  finally
    strdispose(P);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  P:Pchar;
begin
  if Trim(Edit2.Text)='' then
     Exit;
     
  P:=stralloc(1024);
  try
    DecryptXX(Pchar(Edit2.Text),P);
    Edit1.Text:=P;
  finally
    strdispose(P);
  end;
end; 

end.
