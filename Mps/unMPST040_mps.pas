{*******************************************************}
{                                                       }
{                unMPST040_mps                          }
{                Author: kaikai                         }
{                Create date: 2016/05/13                }
{                Description: 查詢在製狀況              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_mps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, unMPS_IcoFlag;

type
  TFrmunMPST040_mps = class(TFrmSTDI051)
    lblpno: TLabel;
    Edit1: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_MPS_IcoFlag:TMPS_IcoFlag;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmunMPST040_mps: TFrmunMPST040_mps;

implementation

uses unGlobal, unCommon, unMPST040;

{$R *.dfm}

procedure TFrmunMPST040_mps.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_MPS_IcoFlag) then
     FreeAndNil(l_MPS_IcoFlag);
end;

procedure TFrmunMPST040_mps.btn_okClick(Sender: TObject);
var
  tmpStr,tmpSQL:string;
  Data:OleVariant;
begin
  tmpStr:=Trim(Edit1.Text);
  if tmpStr='' then
  begin
    ShowMsg('請輸入物品料號!', 48);
    Edit1.SetFocus;
    Exit;
  end;

  if Pos(Copy(tmpStr,1,1),'ET')>0 then
     tmpSQL:='select bu,simuver,citem,wono,sdate,machine,currentboiler,'
            +' custno,custom,sqty,adate_new,wostation,wostation_qtystr,'
            +' wostation_d1str,wostation_d2str,bz_date,sy_date,xy_date,cx_date'
            +' from mps010 where bu='+Quotedstr(g_UInfo^.BU)
            +' and isnull(wostation,0)<50'
            +' and materialno like '+Quotedstr('%'+tmpStr+'%')
            +' order by sdate,machine,simuver,citem'
  else
     tmpSQL:='select bu,simuver,citem,wono,sdate,machine,null currentboiler,'
            +' custno,custom,sqty,adate_new,wostation,wostation_qtystr,'
            +' wostation_d1str,wostation_d2str,bz_date,null sy_date,null xy_date,null cx_date'
            +' from mps070 where bu='+Quotedstr(g_UInfo^.BU)
            +' and isnull(wostation,0)<50'
            +' and materialno like '+Quotedstr('%'+tmpStr+'%')
            +' order by sdate,machine,simuver,citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    if not Assigned(l_MPS_IcoFlag) then
       l_MPS_IcoFlag:=TMPS_IcoFlag.Create;
    l_MPS_IcoFlag.Data:=Data;
    FrmMPST040.CDS2.Data:=l_MPS_IcoFlag.Data;
    inherited;
  end;
end;

end.
