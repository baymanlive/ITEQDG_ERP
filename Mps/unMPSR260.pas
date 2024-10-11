unit unMPSR260;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, ADODB;

type
  TFrmMPSR260 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR260: TFrmMPSR260;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR260.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPSR260';
  p_GridDesignAns := True;
  inherited;

end;

procedure TFrmMPSR260.btn_queryClick(Sender: TObject);
var data:OleVariant;
sql:string;
begin
  {(*}
  sql := 'select distinct ima01,ima02,ima021,'+
         '(case when substr(ima01,1,1) in (''E'',''T'') then ''CCL'' else ''PP'' end)kind,'+
         'img03,img04,img09,img10,'+
         'oea01,oeb03,oea02,oeb12,oeb24,oeb12-oeb24 notqty,'+
         'oeb15,ta_sfb15,occ02,'+
         'img02,imd02,img15,round(sysdate-img15)overday '+
         'from img_file,ima_file,imd_file,oea_file,occ_file,oeb_file,sfb_file where '+
         'ta_img03=occ02 and occ01=oea04 and oea01=oeb01 and '+
         'oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')<>''Y'' and '+
         'img10>0 and oeb04=img01 and '+
         'sfb22=oeb01 and sfb221=oeb03 and '+               
         'img02=imd01 and ima01=img01 order by ima01,img04,oea01,oeb03';      {*)}
  if QueryBySQL(sql,data,'ORACLE') then
   CDS.data:=data;
end;

end.
