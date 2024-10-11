unit unDLII060_set;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmDLII060_set = class(TFrmSTDI051)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII060_set: TFrmDLII060_set;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII060_set.btn_okClick(Sender: TObject);
var
  RTF,RTF2,VLP,HVLP,tmpSQL:string;
begin
 // inherited;
  RTF:=Trim(Edit1.Text);
  RTF2:=Trim(Edit2.Text);
  VLP:=Trim(Edit3.Text);
  HVLP:=Trim(Edit4.Text);

  if Length(RTF)=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label1.Caption));
    Edit1.SetFocus;
    Exit;
  end;

  if Length(RTF2)=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label2.Caption));
    Edit2.SetFocus;
    Exit;
  end;

  if Length(VLP)=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label3.Caption));
    Edit3.SetFocus;
    Exit;
  end;

  if Length(HVLP)=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label4.Caption));
    Edit4.SetFocus;
    Exit;
  end;

  tmpSQL:='declare @bu varchar(10)'
         +' set @bu='+Quotedstr(g_UInfo^.BU)
         +' if not exists(select 1 from dli061 where bu=@bu)'
         +' insert into dli061(bu,iuser,idate) values(@bu,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(DateToStr(Date))+')'
         +' update dli061 set rtf='+Quotedstr(RTF)
         +',rtf2='+Quotedstr(RTF2)
         +',vlp='+Quotedstr(VLP)
         +',hvlp='+Quotedstr(HVLP)
         +',muser='+Quotedstr(g_UInfo^.UserId)
         +',mdate='+Quotedstr(DateToStr(Date))
         +' where bu=@bu';
  if PostBySQL(tmpSQL) then
     ShowMsg('儲存完筆!',64);
end;

procedure TFrmDLII060_set.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
  Edit4.Text:='';
  tmpSQL:='select * from dli061 where bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        Edit1.Text:=tmpCDS.FieldByName('RTF').AsString;
        Edit2.Text:=tmpCDS.FieldByName('RTF2').AsString;
        Edit3.Text:=tmpCDS.FieldByName('VLP').AsString;
        Edit4.Text:=tmpCDS.FieldByName('HVLP').AsString;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

end.
