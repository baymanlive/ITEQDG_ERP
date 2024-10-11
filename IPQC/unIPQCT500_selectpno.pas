unit unIPQCT500_selectpno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmIPQCT500_selectpno = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    l_fiber,l_breadth,l_vendor,l_RetCode,l_RetVendor:string;
    { Public declarations }
  end;

var
  FrmIPQCT500_selectpno: TFrmIPQCT500_selectpno;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT500_selectpno.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'MPS620');
end;

procedure TFrmIPQCT500_selectpno.FormShow(Sender: TObject);
var
  tmpStr:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpStr:='Select * From MPS620 Where Fiber='+Quotedstr(l_fiber)
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Order By Fiber,Breadth,Vendor';
  if QueryBySQL(tmpStr, Data) then
  begin
    CDS.Data:=Data;
    if not CDS.IsEmpty then
    begin
      tmpCDS:=TClientDataSet.Create(nil);
      try
        tmpCDS.Data:=Data;
        while not tmpCDS.Eof do
        begin
          if (Pos(l_breadth,tmpCDS.FieldByName('Breadth').AsString)>0) and
             (tmpCDS.FieldByName('Vendor').AsString=l_vendor) then
          begin
            CDS.RecNo:=tmpCDS.RecNo;
            Break;
          end;
          tmpCDS.Next;
        end;
      finally
        FreeAndNil(tmpCDS);
      end;
    end;
  end;
end;

procedure TFrmIPQCT500_selectpno.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmIPQCT500_selectpno.btn_okClick(Sender: TObject);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('µL¼Æ¾Ú!',48);
    Exit;
  end;

  l_RetCode:=CDS.FieldByName('code').AsString;
  l_RetVendor:=CDS.FieldByName('vendor').AsString;
  
  inherited;
end;

end.
