{*******************************************************}
{                                                       }
{                unDLII040_lot                          }
{                Author: kaikai                         }
{                Create date: 2015/11/23                }
{                Description: COC-CCL列印前批號選擇     }
{                             DLII040、DLIR050共用此單元}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII040_lot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmDLII040_lot = class(TFrmSTDI051)
    ImageList2: TImageList;
    TreeView1: TTreeView;
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    procedure AddLot(Dno, Ditem, Units:string);
    function GetLot:string;
    { Public declarations }
  end;

var
  FrmDLII040_lot: TFrmDLII040_lot;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

//添加批號到TreeView
procedure TFrmDLII040_lot.AddLot(Dno, Ditem, Units:string);
var
  cnt:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpSQL:='Select manfac,sum(qty) qty From Dli040'
         +' Where Dno='+Quotedstr(Dno)
         +' And Ditem='+Ditem
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' And Isnull(qty,0)<>0'
         +' Group By manfac Order By manfac';
  if QueryBySQL(tmpSQL, Data) then
  begin
    TreeView1.Items.BeginUpdate;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      TreeView1.Items.Clear;
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        TreeView1.Items.AddChild(nil, tmpCDS.Fields[0].AsString
                      +'('+FloatToStr(tmpCDS.Fields[1].AsFloat)+Units+')');
        cnt:=TreeView1.Items.Count-1;
        TreeView1.Items[cnt].ImageIndex:=1;
        TreeView1.Items[cnt].SelectedIndex:=1;
        TreeView1.Items[cnt].StateIndex:=0;
        tmpCDS.Next;
      end;
    finally
      TreeView1.Items.EndUpdate;
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//返回SQL語句的And條件
function TFrmDLII040_lot.GetLot:string;
var
  i:Integer;
  tmpStr:string;
begin
  Result:=Quotedstr('@');
  for i:=0 to TreeView1.Items.Count -1 do
  if TreeView1.Items[i].ImageIndex=1 then
  begin
    tmpStr:=TreeView1.Items[i].Text;
    tmpStr:=Copy(tmpStr, 1, Pos('(', tmpStr) -1);
    Result:=Result+','+Quotedstr(tmpStr);
  end;

  Result:=' And manfac in ('+Result+')';   
end;

//點擊項目變換選中/未選中圖片
procedure TFrmDLII040_lot.TreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ht:THitTests;
  fNode:TTreeNode;
begin
  inherited;
  if Button=mbLeft then
  begin
    ht:=TreeView1.GetHitTestInfoAt(X,Y);
    if htOnItem in ht then
    begin
      fNode:=TreeView1.GetNodeAt(X,Y);
      if fNode<>nil then
      begin
        if fNode.ImageIndex=0 then
           fNode.ImageIndex:=1
        else
           fNode.ImageIndex:=0;
        fNode.SelectedIndex:=fNode.ImageIndex;
      end;
    end;
  end;
end;

end.
