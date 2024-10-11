unit unMPST070_Orderby;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, DBClient;

type
  TFrmMPST070_Orderby = class(TFrmSTDI051)
    Label1: TLabel;
    rgp1: TRadioGroup;
    rgp2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_machine:string;
    l_sdate:TDateTime;
    { Public declarations }
  end;

var
  FrmMPST070_Orderby: TFrmMPST070_Orderby;

implementation

uses unGlobal, unCommon, unMPST070;

{$R *.dfm}

procedure TFrmMPST070_Orderby.FormCreate(Sender: TObject);
begin
  inherited;
  rgp1.Caption:=CheckLang('布種');
  rgp1.Items.Strings[0]:=CheckLang('小->大');
  rgp1.Items.Strings[1]:=CheckLang('大->小');
  rgp2.Items.Strings[0]:=rgp1.Items.Strings[0];
  rgp2.Items.Strings[1]:=rgp1.Items.Strings[1];
end;

procedure TFrmMPST070_Orderby.FormShow(Sender: TObject);
begin
  inherited;
  rgp1.ItemIndex:=0;
  rgp2.ItemIndex:=0;
  Label1.Caption:=CheckLang('機台：'+l_machine+#13#10+'日期：')+DateToStr(l_sdate);
end;

procedure TFrmMPST070_Orderby.btn_okClick(Sender: TObject);
var
  tmpStr,tmpFiSno,tmpRc:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  if rgp1.ItemIndex=0 then
     tmpFiSno:='FISno Desc'
  else
     tmpFiSno:='FISno';

  if rgp2.ItemIndex=0 then
     tmpRC:='RC'
  else
     tmpRC:='RC Desc';

  tmpStr:='Select Bu,Simuver,Citem,Jitem From MPS070'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Sdate='+Quotedstr(DateToStr(l_sdate))
         +' And Machine='+Quotedstr(l_machine)
         +' And IsNull(ErrorFlag,0)=0 And IsNull(Case_ans2,0)=0'
         +' Order By Machine,Sdate,AD,'+tmpFiSno+','+tmpRC+',PG,Fiber,Simuver,Citem';
  if not QueryBySQL(tmpStr, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('當天排程無資料',48);
      Exit;
    end;

    with tmpCDS do
    while not Eof do
    begin
      if not FrmMPST070.CDS.Locate('Simuver;Citem',VarArrayOf([FieldByName('Simuver').AsString,
          FieldByName('Citem').AsInteger]),[]) then
      begin
        ShowMsg('資料不同步,請重新查詢資料再試!',48);
        Exit;
      end;
      Next;
    end;

    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        if not FrmMPST070.CDS.Locate('Simuver;Citem',VarArrayOf([FieldByName('Simuver').AsString,
            FieldByName('Citem').AsInteger]),[]) then
        begin
          if FrmMPST070.CDS.ChangeCount>0 then
             FrmMPST070.CDS.CancelUpdates;
          ShowMsg('定位數據失敗,請打開作業重試!',48);
          Exit;
        end;
        Edit;
        FieldByName('Jitem').AsInteger:=RecNo;
        Post;
        FrmMPST070.CDS.Edit;
        FrmMPST070.CDS.FieldByName('Jitem').AsInteger:=RecNo;
        FrmMPST070.CDS.Post;
        Next;
      end;
    end;

    if CDSPost(tmpCDS, 'MPS070') then
       FrmMPST070.CDS.MergeChangeLog
    else begin
      FrmMPST070.CDS.CancelUpdates;
      Exit;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  inherited;
end;

end.
