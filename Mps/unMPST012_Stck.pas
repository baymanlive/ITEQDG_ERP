unit unMPST012_Stck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, unMPST012_ClsStock, DB, DBClient, StrUtils;

type
  TFrmMPST012_Stck = class(TFrmSTDI051)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    edit1: TEdit;
    CheckBoxE: TCheckBox;
    CheckBoxT: TCheckBox;
    CheckBoxB: TCheckBox;
    CheckBoxR: TCheckBox;
    CheckBoxP: TCheckBox;
    CheckBoxQ: TCheckBox;
    CheckBoxM: TCheckBox;
    CheckBoxN: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    btnStockQuery: TButton;
    Panel5: TPanel;
    GroupBox1: TGroupBox;
    DBGridEh1: TDBGridEh;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    DBGridEh2: TDBGridEh;
    Panel6: TPanel;
    btnImport: TButton;
    btnRemove: TButton;
    DS: TDataSource;
    CDS: TClientDataSet;
    CDS1: TClientDataSet;
    DS1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btnImportClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure btnStockQueryClick(Sender: TObject);
  private
    { Private declarations }
    l_isDG:Boolean;
    procedure InitDBGridEh1();
    procedure BindStockData(materialno:string);
  public
    { Public declarations }
    l_SelList:TStrings;
    clsStock:TMPST012_ClsStock;
  end;

const fstCode='ETBRPQMN';

var
  FrmMPST012_Stck: TFrmMPST012_Stck;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_Stck.FormCreate(Sender: TObject);
begin
  inherited;
  
  l_SelList:=TStringList.Create;

  l_isDG:=SameText(g_UInfo^.BU,'ITEQDG') or SameText(g_UInfo^.BU,'ITEQGZ');

  if not Assigned(clsStock) then
     clsStock:=TMPST012_ClsStock.Create;

  Label1.Caption:=CheckLang('物件編號：');
  GroupBox1.Caption:=CheckLang('物件庫存列表：');
  GroupBox2.Caption:=CheckLang('訂單與庫存關聯列表：');
  btnStockQuery.Caption:=CheckLang('查詢');
  CheckBox1.Caption:=CheckLang('1');
  CheckBox2.Caption:=CheckLang('普通原料倉');
  CheckBox3.Caption:=CheckLang('僅特產倉');
  CheckBoxE.Caption:=CheckLang('E');
  CheckBoxT.Caption:=CheckLang('T');
  CheckBoxB.Caption:=CheckLang('B');
  CheckBoxR.Caption:=CheckLang('R');
  CheckBoxP.Caption:=CheckLang('P');
  CheckBoxQ.Caption:=CheckLang('Q');
  CheckBoxM.Caption:=CheckLang('M');
  CheckBoxN.Caption:=CheckLang('N');

  btnImport.Caption:=CheckLang('導入勾選');
  btnRemove.Caption:=CheckLang('移除記錄');

  SetGrdCaption(DBGridEh2, 'MPS012_Stock');
  InitDBGridEh1();
end;

procedure TFrmMPST012_Stck.InitDBGridEh1();
begin
  with DBGridEh1 do
  begin
    FieldColumns['dbtype'].Title.Caption := CheckLang('廠別');
    FieldColumns['img01'].Title.Caption := CheckLang('物品料號');
    FieldColumns['img02'].Title.Caption := CheckLang('倉庫');
    FieldColumns['img03'].Title.Caption := CheckLang('儲位');
    FieldColumns['img04'].Title.Caption := CheckLang('批號');
    FieldColumns['img10'].Title.Caption := CheckLang('數量');
    FieldColumns['ta_img03'].Title.Caption := CheckLang('客戶');

    FieldColumns['dbtype'].Width := 60;
    FieldColumns['img01'].Width := 120;
    FieldColumns['img02'].Width := 70;
    FieldColumns['img03'].Width := 120;
    FieldColumns['img04'].Width := 120;
    FieldColumns['img10'].Width := 120;
    FieldColumns['ta_img03'].Title.Caption := CheckLang('客戶');

    ReadOnly := true;
  end;
end;

procedure TFrmMPST012_Stck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  FreeAndNil(l_SelList);
    
  if Assigned(clsStock) then
     FreeAndNil(clsStock);

  FreeAndNil(CDS);
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmMPST012_Stck.FormShow(Sender: TObject);
begin
  inherited;
  if (Self.FindComponent('CheckBox' + UpperCase(copy(Edit1.Text,1,1)) )<>nil) then
      (Self.FindComponent('CheckBox' + UpperCase(copy(Edit1.Text,1,1)) ) as TCheckBox).Checked:=true;
end;

procedure TFrmMPST012_Stck.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr:string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr:=CDS.FieldByName('dbtype').AsString+'@'+
            CDS.FieldByName('img01').AsString+'@'+
            CDS.FieldByName('img02').AsString+'@'+
            CDS.FieldByName('img03').AsString+'@'+
            CDS.FieldByName('img04').AsString;
            
    if l_SelList.IndexOf(tmpStr) <>-1 then
       DBGridEh1.Canvas.TextOut(Round((Rect.Left+Rect.Right)/2)-6,
       Round((Rect.Top+Rect.Bottom)/2-6), 'V');
  end;
end;

procedure TFrmMPST012_Stck.btnImportClick(Sender: TObject);
var
  tmpStr:string;
begin
  inherited;

  if (l_SelList.Count=0) then
    Exit;

  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  CDS.First;
  while not CDS.Eof do
  begin

   tmpStr:=CDS.FieldByName('dbtype').AsString+'@'+
          CDS.FieldByName('img01').AsString+'@'+
          CDS.FieldByName('img02').AsString+'@'+
          CDS.FieldByName('img03').AsString+'@'+
          CDS.FieldByName('img04').AsString;

   // 1. 沒有勾選則下一輪
   if (l_SelList.IndexOf(tmpStr)=-1) then
   begin
      CDS.next;
      continue;
   end;

   // 2. 準備數據
    with CDS do
    begin
      clsStock.dbtype := FieldByName('dbtype').AsString;
      clsStock.materialno1 := FieldByName('img01').AsString;
      clsStock.wareHouseNo := FieldByName('img02').AsString;
      clsStock.storageNo := FieldByName('img03').AsString;
      clsStock.batchNo := FieldByName('img04').AsString;
      clsStock.stockQty := FieldByName('img10').AsFloat;
      clsStock.rStockQty := FieldByName('img10').AsFloat;
      clsStock.custom1 := FieldByName('ta_img03').AsString;
    end;

    // 3. 填充
    with CDS1 do
    begin

      // 3.1 判斷是否已存在
      if Locate('dbtype;materialno1;wareHouseNo;storageNo;batchNo',
        VarArrayOf([clsStock.dbtype, clsStock.materialno1, clsStock.wareHouseNo, clsStock.storageNo, clsStock.batchNo]), []) then
      begin
        CDS.next;
        continue;
      end;

      // 3.2 填充數據
      append;
      FieldByName('gid').Value := clsStock.GetGUID;
      FieldByName('uuid').Value := clsStock.uuid;
      FieldByName('orderBu').Value := clsStock.orderBu;
      FieldByName('orderno').Value := clsStock.orderno;
      FieldByName('orderitem').Value := clsStock.orderitem;
      FieldByName('materialno').Value := clsStock.materialno;
      FieldByName('orderQty').Value := clsStock.orderQty;
      FieldByName('sQty').Value := clsStock.orderQty;
      FieldByName('dbtype').Value := clsStock.dbtype;
      FieldByName('materialno1').Value := clsStock.materialno1;
      FieldByName('wareHouseNo').Value := clsStock.wareHouseNo;
      FieldByName('storageNo').Value := clsStock.storageNo;
      FieldByName('batchNo').Value := clsStock.batchNo;
      FieldByName('stockQty').Value := clsStock.stockQty;
      FieldByName('rStockQty').Value := clsStock.rStockQty;
      FieldByName('isActive').Value := 'N';
      FieldByName('custno1').Value := '';
      FieldByName('custom1').Value := clsStock.custom1;
      FieldByName('custno').Value := clsStock.custno;
      FieldByName('custom').Value := clsStock.custom;
      post;
    end;

    CDS.Next;

  end;

end;

procedure TFrmMPST012_Stck.btnRemoveClick(Sender: TObject);
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
    Exit;
   CDS1.Delete;
end;

procedure TFrmMPST012_Stck.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    tmpStr:=CDS.FieldByName('dbtype').AsString+'@'+
            CDS.FieldByName('img01').AsString+'@'+
            CDS.FieldByName('img02').AsString+'@'+
            CDS.FieldByName('img03').AsString+'@'+
            CDS.FieldByName('img04').AsString;
    if l_SelList.IndexOf(tmpStr) =-1 then
       l_SelList.Add(tmpStr)
    else
       l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST012_Stck.btnStockQueryClick(Sender: TObject);
begin
  inherited;
  BindStockData(edit1.Text);
end;


procedure TFrmMPST012_Stck.BindStockData(materialno:string);
var
  i:Integer;
  Data:OleVariant;
  tmpStr:WideString;
  tmpSQL,tmpImgFilter,tmpOebFilter,tmpImg02:string;
  tmpCDS:TClientDataSet;
begin
  tmpStr:=Trim(Edit1.Text);
  if Length(tmpStr)<6 then
  begin
    ShowMsg('請輸入物品料號,最小長度6碼!',48);
    Edit1.SetFocus;
    Exit;
  end;

  Delete(tmpStr,1,1);
  for i:=1 to Length(fstCode) do
  begin
    if (Self.FindComponent('CheckBox'+fstCode[i])<>nil) and
       (Self.FindComponent('CheckBox'+fstCode[i]) as TCheckBox).Checked then
    begin
      tmpImgFilter:=tmpImgFilter+' or img01 Like '+Quotedstr(fstCode[i]+tmpStr+'%');
      tmpOebFilter:=tmpOebFilter+' or oeb04 Like '+Quotedstr(fstCode[i]+tmpStr+'%');
    end;
  end;

  // 1.
  if Length(tmpImgFilter)=0 then
  begin
    ShowMsg('請選擇E/T/B/R/P/Q/M/N/1,一個或多個!',48);
    Edit1.SetFocus;
    Exit;
  end;

  // 2.
  if CheckBox1.Checked then
  if CheckBoxE.Checked or CheckBoxT.Checked or
     CheckBoxB.Checked or CheckBoxR.Checked or
     CheckBoxP.Checked or CheckBoxQ.Checked or
     CheckBoxM.Checked or CheckBoxN.Checked then
  begin
    ShowMsg('E/T/B/R/P/Q/M/N與1不能同時選中!',48);
    Edit1.SetFocus;
    Exit;
  end;

  // 3.
  if CheckBox2.Checked and CheckBox3.Checked then
  begin
    ShowMsg('普通原料倉 與 僅特產倉 不能同時選中!',48);
    Edit1.SetFocus;
    Exit;
  end;

  // 4.
  if CheckBox2.Checked = CheckBox3.Checked then
  begin
    ShowMsg('普通原料倉 與 僅特產倉 至少有一項選中!',48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  Application.ProcessMessages;
  try

    if CheckBox2.Checked then
    begin
      //取庫別
      tmpImg02:='';
      if CheckBox1.Checked then
         tmpSQL:=' and qst=1'
      else
         tmpSQL:=' and sst=1';
      tmpSQL:='Select Depot From MPS330 Where Bu='+Quotedstr(g_UInfo^.BU)+tmpSQL;
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;
      with tmpCDS do
      while Not Eof do
      begin
        tmpImg02:=tmpImg02+','+Quotedstr(Fields[0].AsString);
        Next;
      end;
      if Length(tmpImg02)=0 then
      begin
        ShowMsg('MPS330無庫別,請確認!',48);
        Edit1.SetFocus;
        Exit;
      end;
      Delete(tmpImg02,1,1);
      tmpImg02:=' And img02 in ('+tmpImg02+')';
      //***
    end else
      tmpImg02:=' And img02 in (''Y2CF0'',''N2CF0'')';

    Data:=null;
    if l_isDG then
       tmpSQL:='Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,'
              +' ''DG'' dbtype,img04 as cjremark,img10 as bookingqty'
              +' From ITEQDG.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Union All'
              +' Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,'
              +' ''GZ'' as dbtype,img04 as cjremark,img10 as bookingqty'
              +' From ITEQGZ.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Order By img01,img02,img03,img04'
    else
       tmpSQL:='Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,'
              +Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype,img04 as cjremark,img10 as bookingqty'
              +' From '+g_UInfo^.BU+'.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Order By img01,img02,img03,img04';

    Data:=null;

    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      exit;

    tmpCDS.Data:=Data;
    CDS.Data:=tmpCDS.Data;

  finally
  end;
end;


end.
