unit unMPST090_Export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DB, DBClient;

type
  TFrmMPST090_Export = class(TFrmSTDI051)
    GroupBox1: TGroupBox;
    chb_mpst090_dgccl: TCheckBox;
    chb_mpst090_dgpp: TCheckBox;
    chb_mpst090_gzccl: TCheckBox;
    chb_mpst090_gzpp: TCheckBox;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure AddCCLHead(var xExcelApp:Variant; xRow:Integer);
    procedure AddPPHead(var xExcelApp:Variant; xRow:Integer);
    procedure AddCCLBody(var xExcelApp:Variant; xRow:Integer; data:TClientDataSet);
    procedure AddPPBody(var xExcelApp:Variant; xRow:Integer; data:TClientDataSet);
  private
    { Private declarations }
    l_DG_CCL_CDS: TClientDataSet;
    l_DG_PP_CDS: TClientDataSet;
    l_GZ_CCL_CDS: TClientDataSet;
    l_GZ_PP_CDS: TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmMPST090_Export: TFrmMPST090_Export;

implementation

uses unCommon, unGlobal, ComObj, StrUtils;

{$R *.dfm}

procedure TFrmMPST090_Export.FormCreate(Sender: TObject);
begin
  inherited;
  l_DG_CCL_CDS := TClientDataSet.Create(Self);
  l_DG_PP_CDS := TClientDataSet.Create(Self);
  l_GZ_CCL_CDS := TClientDataSet.Create(Self);
  l_GZ_PP_CDS := TClientDataSet.Create(Self);
end;

procedure TFrmMPST090_Export.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_DG_CCL_CDS);
  FreeAndNil(l_DG_PP_CDS);
  FreeAndNil(l_GZ_CCL_CDS);
  FreeAndNil(l_GZ_PP_CDS);
end;

procedure TFrmMPST090_Export.AddCCLHead(var xExcelApp:Variant; xRow:Integer);
var
  lp: Integer;
begin

  for lp:=1 to 20 do
    xExcelApp.Columns[lp].NumberFormatLocal:='@';

  // ��R���D
  xExcelApp.Cells[xRow,1].Value:= CheckLang('���x');
  xExcelApp.Cells[xRow,2].Value:= CheckLang('�Ͳ����');
  xExcelApp.Cells[xRow,3].Value:= CheckLang('�s�O�渹');
  xExcelApp.Cells[xRow,4].Value:= CheckLang('�q��渹');
  xExcelApp.Cells[xRow,5].Value:= CheckLang('����');
  xExcelApp.Cells[xRow,6].Value:= CheckLang('�ƥ�s��');
  xExcelApp.Cells[xRow,7].Value:= CheckLang('�q��ƶq');
  xExcelApp.Cells[xRow,8].Value:= CheckLang('�ƻs�ƶq');
  xExcelApp.Cells[xRow,9].Value:= CheckLang('���O');
  xExcelApp.Cells[xRow,10].Value:= CheckLang('�ͺޯS�O�Ƶ�');
  xExcelApp.Cells[xRow,11].Value:= CheckLang('�Ȥ�s��');
  xExcelApp.Cells[xRow,12].Value:= CheckLang('�Ȥ�²��');
  xExcelApp.Cells[xRow,13].Value:= CheckLang('PNL�Ƹ�');
  xExcelApp.Cells[xRow,14].Value:= CheckLang('PNL�ؤo1');
  xExcelApp.Cells[xRow,15].Value:= CheckLang('PNL�ؤo2');
  xExcelApp.Cells[xRow,16].Value:= CheckLang('�⨤�q��渹');
  xExcelApp.Cells[xRow,17].Value:= CheckLang('�⨤�q�涵��');
  xExcelApp.Cells[xRow,18].Value:= CheckLang('�w����');
  xExcelApp.Cells[xRow,19].Value:= CheckLang('���P');
  xExcelApp.Cells[xRow,20].Value:= CheckLang('DG�q��');
end;

procedure TFrmMPST090_Export.AddPPHead(var xExcelApp:Variant; xRow:Integer);
var
  lp: Integer;
begin

  for lp:=1 to 21 do
    xExcelApp.Columns[lp].NumberFormatLocal:='@';

  // ��R���D
  xExcelApp.Cells[xRow,1].Value:= CheckLang('���O');
  xExcelApp.Cells[xRow,2].Value:= CheckLang('�Ͳ����');
  xExcelApp.Cells[xRow,3].Value:= CheckLang('�s�O�渹');
  xExcelApp.Cells[xRow,4].Value:= CheckLang('�q��渹');
  xExcelApp.Cells[xRow,5].Value:= CheckLang('����');
  xExcelApp.Cells[xRow,6].Value:= CheckLang('�ƥ�s��');
  xExcelApp.Cells[xRow,7].Value:= CheckLang('�q��ƶq');
  xExcelApp.Cells[xRow,8].Value:= CheckLang('�Ƶ{�ƶq');
  xExcelApp.Cells[xRow,9].Value:= CheckLang('�T�e');
  xExcelApp.Cells[xRow,10].Value:= CheckLang('����');
  xExcelApp.Cells[xRow,11].Value:= CheckLang('�ͺޯS�O�Ƶ�');
  xExcelApp.Cells[xRow,12].Value:= CheckLang('�Ȥ�s��');
  xExcelApp.Cells[xRow,13].Value:= CheckLang('�Ȥ�²��');
  xExcelApp.Cells[xRow,14].Value:= CheckLang('PNL�Ƹ�');
  xExcelApp.Cells[xRow,15].Value:= CheckLang('PNL�ؤo1');
  xExcelApp.Cells[xRow,16].Value:= CheckLang('PNL�ؤo2');
  xExcelApp.Cells[xRow,17].Value:= CheckLang('�⨤�q��渹');
  xExcelApp.Cells[xRow,18].Value:= CheckLang('�⨤�q�涵��');
  xExcelApp.Cells[xRow,19].Value:= CheckLang('�w����');
  xExcelApp.Cells[xRow,20].Value:= CheckLang('���P');
  xExcelApp.Cells[xRow,21].Value:= CheckLang('DG�q��');
end;

procedure TFrmMPST090_Export.AddCCLBody(var xExcelApp:Variant; xRow:Integer; data:TClientDataSet);
begin
  if data.IsEmpty then exit;

  data.First;
  while not data.Eof do
  begin
    xExcelApp.Cells[xRow,1].Value:= data.FieldByName('machine').AsString;
    xExcelApp.Cells[xRow,2].Value:= data.FieldByName('sdate').AsString;
    xExcelApp.Cells[xRow,3].Value:= data.FieldByName('Wono').AsString;
    xExcelApp.Cells[xRow,4].Value:= data.FieldByName('Orderno').AsString;
    xExcelApp.Cells[xRow,5].Value:= data.FieldByName('OrderItem').AsString;
    xExcelApp.Cells[xRow,6].Value:= data.FieldByName('Materialno').AsString;
    xExcelApp.Cells[xRow,7].Value:= data.FieldByName('orderqty').AsString;
    xExcelApp.Cells[xRow,8].Value:= data.FieldByName('Sqty').AsString;
    xExcelApp.Cells[xRow,9].Value:= data.FieldByName('Stealno').AsString;
    xExcelApp.Cells[xRow,10].Value:= data.FieldByName('Premark').AsString;
    xExcelApp.Cells[xRow,11].Value:= data.FieldByName('Custno').AsString;
    xExcelApp.Cells[xRow,12].Value:= data.FieldByName('Custom').AsString;
    xExcelApp.Cells[xRow,13].Value:= data.FieldByName('Materialno1').AsString;
    xExcelApp.Cells[xRow,14].Value:= data.FieldByName('PnlSize1').AsString;
    xExcelApp.Cells[xRow,15].Value:= data.FieldByName('PnlSize2').AsString;
    xExcelApp.Cells[xRow,16].Value:= data.FieldByName('Orderno2').AsString;
    xExcelApp.Cells[xRow,17].Value:= data.FieldByName('OrderItem2').AsString;
    xExcelApp.Cells[xRow,18].Value:= data.FieldByName('iscreate').AsString;
    xExcelApp.Cells[xRow,19].Value:= data.FieldByName('isdomestic').AsString;
    xExcelApp.Cells[xRow,20].Value:= data.FieldByName('isdg').AsString;

    inc(xRow);
    data.next();
  end;
end;

procedure TFrmMPST090_Export.AddPPBody(var xExcelApp:Variant; xRow:Integer; data:TClientDataSet);
begin
  if data.IsEmpty then exit;

  data.First;
  while not data.Eof do
  begin
    xExcelApp.Cells[xRow,1].Value:= data.FieldByName('machine').AsString;
    xExcelApp.Cells[xRow,2].Value:= data.FieldByName('sdate').AsString;
    xExcelApp.Cells[xRow,3].Value:= data.FieldByName('Wono').AsString;
    xExcelApp.Cells[xRow,4].Value:= data.FieldByName('Orderno').AsString;
    xExcelApp.Cells[xRow,5].Value:= data.FieldByName('OrderItem').AsString;
    xExcelApp.Cells[xRow,6].Value:= data.FieldByName('Materialno').AsString;
    xExcelApp.Cells[xRow,7].Value:= data.FieldByName('orderqty').AsString;
    xExcelApp.Cells[xRow,8].Value:= data.FieldByName('Sqty').AsString;
    xExcelApp.Cells[xRow,9].Value:= data.FieldByName('Breadth').AsString;
    xExcelApp.Cells[xRow,10].Value:= data.FieldByName('Fiber').AsString;
    xExcelApp.Cells[xRow,11].Value:= data.FieldByName('Premark').AsString;
    xExcelApp.Cells[xRow,12].Value:= data.FieldByName('Custno').AsString;
    xExcelApp.Cells[xRow,13].Value:= data.FieldByName('Custom').AsString;
    xExcelApp.Cells[xRow,14].Value:= data.FieldByName('Materialno1').AsString;
    xExcelApp.Cells[xRow,15].Value:= data.FieldByName('PnlSize1').AsString;
    xExcelApp.Cells[xRow,16].Value:= data.FieldByName('PnlSize2').AsString;
    xExcelApp.Cells[xRow,17].Value:= data.FieldByName('Orderno2').AsString;
    xExcelApp.Cells[xRow,18].Value:= data.FieldByName('OrderItem2').AsString;
    xExcelApp.Cells[xRow,19].Value:= data.FieldByName('iscreate').AsString;
    xExcelApp.Cells[xRow,20].Value:= data.FieldByName('isdomestic').AsString;
    xExcelApp.Cells[xRow,21].Value:= data.FieldByName('isdg').AsString;

    inc(xRow);
    data.next();
  end;
end;

procedure TFrmMPST090_Export.btn_okClick(Sender: TObject);
var
  ExcelApp:Variant;
  isOK: Boolean;
  i,tab:Integer;
  Data: OleVariant;
begin
  inherited;

  {	@index int,	--0:CCL 1:PP
	@isdg  int	--0:dg	1:gz	}

  ModalResult := mrNone;

  tab := 0;

  // 1. ��R�O����
  if (chb_mpst090_dgccl.Checked) then
  begin
    inc(tab);
    if QueryBySQL('exec dbo.proc_MPST090 0,0', Data) then
      l_DG_CCL_CDS.Data := Data;
  end;

  if (chb_mpst090_dgpp.Checked) then
  begin
     inc(tab);
    if QueryBySQL('exec dbo.proc_MPST090 1,0', Data) then
      l_DG_PP_CDS.Data := Data;
  end;

  if (chb_mpst090_gzccl.Checked) then
  begin
     inc(tab);
    if QueryBySQL('exec dbo.proc_MPST090 0,1', Data) then
      l_GZ_CCL_CDS.Data := Data;
  end;

  if (chb_mpst090_gzpp.Checked) then
  begin
     inc(tab);
    if QueryBySQL('exec dbo.proc_MPST090 1,1', Data) then
      l_GZ_PP_CDS.Data := Data;
  end;

  if(tab=0)then
  begin
    ShowMsg('�ܤֿ�ܤ@���I',48);
    exit;
  end;

  // ��l��
  ProgressBar1.Position:=0;
  ProgressBar1.Max:=tab;
  isOK := false;

  // 2. ��R Excel �ƾ�
  try

      // 2.1 �ͦ� Excel ��H
      try
        ExcelApp := CreateOleObject('Excel.Application');
        ExcelApp.Visible:=False;
        ExcelApp.DisplayAlerts:=False;
        ExcelApp.WorkBooks.Add;

        for i:=ExcelApp.WorkSheets.Count downto 2 do
        begin
          ExcelApp.WorkSheets[i].Select;
          ExcelApp.WorkSheets[i].Delete;
        end;
        ExcelApp.WorkSheets[1].Activate;
        for i:=1 to (tab-1) do
          ExcelApp.WorkSheets.Add;
      except
        ShowMsg('Create Excel Application Error',16);
        Exit;
      end;
      // a1

      tab := 1;

     // 2.2 ��R�F�� CCL
     if (chb_mpst090_dgccl.Checked) then
     begin
      Application.ProcessMessages;
      ExcelApp.WorkSheets[tab].Activate;
      ExcelApp.WorkSheets[tab].Name := chb_mpst090_dgccl.Caption;
      ProgressBar1.Position:=tab;
      inc(tab);
      AddCCLHead(ExcelApp,1);
      AddCCLBody(ExcelApp,2,l_DG_CCL_CDS);
     end;


     // 2.3 ��R�F�� PP
     if (chb_mpst090_dgpp.Checked) then
     begin
      Application.ProcessMessages;
      ExcelApp.WorkSheets[tab].Activate;
      ExcelApp.WorkSheets[tab].Name := chb_mpst090_dgpp.Caption;
      ProgressBar1.Position:=tab;
      inc(tab);
      AddPPHead(ExcelApp,1);
      AddPPBody(ExcelApp,2,l_DG_PP_CDS);
     end;


     // 2.4 ��R�s�{ CCL
     if (chb_mpst090_gzccl.Checked) then
     begin
      Application.ProcessMessages;
      ExcelApp.WorkSheets[tab].Activate;
      ExcelApp.WorkSheets[tab].Name := chb_mpst090_gzccl.Caption;
      ProgressBar1.Position:=tab;
      inc(tab);
      AddCCLHead(ExcelApp,1);
      AddCCLBody(ExcelApp,2,l_GZ_CCL_CDS);
     end;


     // 2.5 ��R�s�{ PP
     if (chb_mpst090_gzpp.Checked) then
     begin
      Application.ProcessMessages;
      ExcelApp.WorkSheets[tab].Activate;
      ExcelApp.WorkSheets[tab].Name := chb_mpst090_gzpp.Caption;
      ProgressBar1.Position:=tab;
      inc(tab);
      AddPPHead(ExcelApp,1);
      AddPPBody(ExcelApp,2,l_GZ_PP_CDS);
     end;

    Application.ProcessMessages;
    ExcelApp.WorkSheets[1].Activate;
    isOK := true;
    ExcelApp.Visible:=True;
  finally
    if not isOK then
      ExcelApp.Quit;
  end;

end;

end.
