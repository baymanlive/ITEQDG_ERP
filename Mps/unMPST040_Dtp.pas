unit unMPST040_Dtp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmMPST040_Dtp = class(TFrmSTDI051)
    Panel1: TPanel;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    BtnMpst040Export: TButton;
    procedure BtnMpst040ExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmMPST040_Dtp: TFrmMPST040_Dtp;

implementation

uses unGlobal, unCommon, ComObj;

{$R *.dfm}

procedure TFrmMPST040_Dtp.BtnMpst040ExportClick(Sender: TObject);
var
  strFilter,tmpSQL: string;
  Data: OleVariant;
  isOK:Boolean;
  ExcelApp:Variant;
  i,row:Integer;
begin
  // 1.
  strFilter := ' And Indate=' + Quotedstr(DateToStr(dtp1.Date));

  tmpSQL :='select b.Pathname,(case when substring(a.Pno,1,1) in (''B'',''R'',''N'',''M'') then ''PP'' '
    + ' when substring(a.Pno,1,1) in (''T'',''E'') then ''CCL'' '
    + ' else ''other'' '
    + ' end) as ''CCL_PP'', '
    + ' a.Units,a.Notcount1 '
    + ' from dli010 a  '
    + ' left join DLI400 b on a.Custno=b.Custno and a.bu=b.bu  '
    + ' where a.bu=''ITEQDG'' '
    + strFilter
    + ' And IsNull(a.QtyColor,0)<>' + IntToStr(g_CocData)
    + ' And IsNull(a.GarbageFlag,0)=0' + ' And Len(IsNull(a.Dno_Ditem,''''))=0';

  tmpSQL:='select c.Pathname,c.CCL_PP,c.Units,sum(c.Notcount1) as tal from(' + tmpSQL + ')c group by c.Pathname,c.CCL_PP,c.Units';

  
  // 3.
  if QueryBySQL(tmpSQL, Data) then
      l_CDS.Data := Data;

  // 4.
  if (not l_CDS.Active) or (l_CDS.RecordCount=0) then
  begin
    ShowMsg('沒有查詢到任何記錄!', 48);
    exit;
  end;

  isOK := false;
  Application.ProcessMessages;

    try
      l_CDS.DisableControls;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=l_CDS.RecordCount;
      g_ProgressBar.Visible:=True;

      // a1: 初始 EXCEL
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
      except
        ShowMsg('Create Excel Application Error',16);
        Exit;
      end;
      // a1

      row := 1;

      ExcelApp.Columns[1].NumberFormatLocal:='@';
      ExcelApp.Columns[2].NumberFormatLocal:='@';
      ExcelApp.Columns[3].NumberFormatLocal:='@';
      ExcelApp.Columns[4].NumberFormatLocal:='@';

      // 標題
      ExcelApp.Cells[row,1].Value:='線路';
      ExcelApp.Cells[row,2].Value:='產品類別';
      ExcelApp.Cells[row,3].Value:='單位';
      ExcelApp.Cells[row,4].Value:='纍計數量';

      l_CDS.First;

      while not l_CDS.Eof do
      begin
        Inc(row);
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        ExcelApp.Cells[row,1].Value:=l_CDS.FieldByName('Pathname').AsString;
        ExcelApp.Cells[row,2].Value:=l_CDS.FieldByName('CCL_PP').AsString;
        ExcelApp.Cells[row,3].Value:=l_CDS.FieldByName('Units').AsString;
        ExcelApp.Cells[row,4].Value:=l_CDS.FieldByName('tal').AsFloat;

        l_CDS.Next;
      end;
      ExcelApp.Cells.Columns.autofit;
      ExcelApp.Visible:=True;
      isOK:=True;

    finally
      g_ProgressBar.Visible:=False;
      if not isOK then
        ExcelApp.Quit;
    end;

end;

procedure TFrmMPST040_Dtp.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption := CheckLang('出貨日期：');
  BtnMpst040Export.Caption := CheckLang('查詢導出');
  btn_ok.Visible:=false;

  l_CDS:= TClientDataSet.Create(Self);
end;

procedure TFrmMPST040_Dtp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

end.
