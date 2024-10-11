unit unIPQCT520_selectobj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, CheckLst, ImgList, Buttons, ExtCtrls;

type
  TFrmIPQCT520_objselect = class(TFrmSTDI051)
    clb1: TCheckListBox;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    clb2: TCheckListBox;
    clb3: TCheckListBox;
    clb4: TCheckListBox;
    clb5: TCheckListBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Setclb(clb: TCheckListBox; objIndex:Integer);
  public
    l_num:Integer;
    l_MinV,l_MaxV:Double;
    l_def:string;
    function getclb(clb: TCheckListBox):string;
    { Public declarations }
  end;

var
  FrmIPQCT520_objselect: TFrmIPQCT520_objselect;

implementation

uses unGlobal, unCommon, unIPQCT520_units;

{$R *.dfm}

procedure TFrmIPQCT520_objselect.Setclb(clb: TCheckListBox; objIndex:Integer);
var
  i:Integer;
begin
  clb.Items.BeginUpdate;
  clb.Items.DelimitedText:=g_ArrMachine[l_num].ArrObj[objIndex].AllObjName;
  clb.Items.EndUpdate;
  for i:=0 to clb.Items.Count-1 do
  if Pos(clb.Items.Strings[i],l_def)>0 then
     clb.Checked[i]:=True;
end;

function TFrmIPQCT520_objselect.getclb(clb: TCheckListBox):string;
var
  i:integer;
begin
  Result:='';
  for i:=0 to clb.Items.Count-1 do
  if clb.Checked[i] then
  begin
    if Length(Result)>0 then
       Result:=Result+',';
    Result:=Result+clb.Items.Strings[i];
  end;
end;

procedure TFrmIPQCT520_objselect.FormShow(Sender: TObject);
begin
  inherited;
  CheckBox1.Caption:=CheckLang('笆');
  Label2.Caption:=CheckLang('程');
  Label3.Caption:=CheckLang('程');
  Label4.Caption:=g_ArrMachine[l_num].ArrObj[0].Name;
  Label5.Caption:=g_ArrMachine[l_num].ArrObj[1].Name;
  Label6.Caption:=g_ArrMachine[l_num].ArrObj[2].Name;
  Label7.Caption:=g_ArrMachine[l_num].ArrObj[3].Name;
  Label8.Caption:=g_ArrMachine[l_num].ArrObj[4].Name;
  Setclb(clb1,0);
  Setclb(clb2,1);
  Setclb(clb3,2);
  Setclb(clb4,3);
  Setclb(clb5,4);
  if l_MinV<>-1 then
  begin
    Edit1.Text:=FloatToStr(l_MinV);
    Edit2.Text:=FloatToStr(l_MaxV);
    Edit1.Enabled:=True;
    Edit2.Enabled:=True;
    CheckBox1.Checked:=False;
  end else
  begin
    Edit1.Text:='';
    Edit2.Text:='';
    Edit1.Enabled:=False;
    Edit2.Enabled:=False;
    CheckBox1.Checked:=True;
  end;
end;

procedure TFrmIPQCT520_objselect.CheckBox1Click(Sender: TObject);
begin
  inherited;
  Edit1.Enabled:=not CheckBox1.Checked;
  Edit2.Enabled:=not CheckBox1.Checked;
  if Edit1.CanFocus then
     Edit1.SetFocus;
end;

procedure TFrmIPQCT520_objselect.btn_okClick(Sender: TObject);

function isCheck(clb: TCheckListBox):Boolean;
var
  i:integer;
begin
  Result:=False;
  for i:=0 to clb.Items.Count-1 do
  if clb.Checked[i] then
  begin
    Result:=True;
    Exit;
  end;
end;

begin
  l_MinV:=-1;
  l_MaxV:=-1;

  if not isCheck(clb1) then
  if not isCheck(clb2) then
  if not isCheck(clb3) then
  if not isCheck(clb4) then
  if not isCheck(clb5) then
  begin
    ShowMsg('叫匡拒兜ヘ!',48);
    Exit;
  end;

  if not CheckBox1.Checked then
  begin
    l_MinV:=StrToFloatDef(Trim(Edit1.Text),-1);
    l_MaxV:=StrToFloatDef(Trim(Edit2.Text),-1);
    if l_MinV<0 then
    begin
      ShowMsg('程ぃ0!',48);
      Edit1.SetFocus;
      Exit;
    end;
    if l_MaxV<=0 then
    begin
      ShowMsg('程ぃ单0!',48);
      Edit2.SetFocus;
      Exit;
    end;
    if l_MinV>=l_MaxV then
    begin
      ShowMsg('程惠程!',48);
      Edit2.SetFocus;
      Exit;
    end;
  end;

  inherited;
end;

end.
