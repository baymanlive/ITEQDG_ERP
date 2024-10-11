unit unMPST040_units;

interface

uses
  SysUtils, unGlobal, unCommon;

function CheckConfirm(Indate:TDateTime):Boolean;
function GetOraSQL(xBu,xFilter: string): string;
function GetMPSSno(Indate:TDateTime):Integer;

implementation

//�d�߽T�{
//DateToStr(Indate)���G������|���P��,�����ҿ�
function CheckConfirm(Indate:TDateTime):Boolean;
var
  tmpSQL:string;
  isExists:Boolean;
begin
  Result:=False;
  tmpSQL:=DateToStr(Indate);
  tmpSQL:=StringReplace(tmpSQL, '�P���@', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P���G', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P���T', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P���|', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P����', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P����', '', [rfReplaceAll]);
  tmpSQL:=StringReplace(tmpSQL, '�P����', '', [rfReplaceAll]);
  tmpSQL:='Select Top 1 Bu From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(Trim(tmpSQL));
  if QueryExists(tmpSQL, isExists) then
     Result:=isExists;
end;

//�q��
function GetOraSQL(xBu,xFilter: string): string;
begin
  Result:='select Y.*,ocd221 from'
         +' (select X.*,oao06 from'
         +' (select B.*,ima021,ima18 from'
         +' (select A.*,occ02 from'
         +' (select oea01,oea02,oea04,oea044,oea10,oeaconf,oeb03,oeb04,oeb05,'
         +'        oeb06,oeb11,oeb12,oeb15,oeb24,oeb70,ta_oeb01,ta_oeb02,'
         +'        ta_oeb10,ta_oeb22,oeb12-oeb24 notqty from '+xBu+'.oea_file'
         +' inner join '+xBu+'.oeb_file on oea01=oeb01 where 1=1 '+xFilter+') A'
         +' left join '+xBu+'.occ_file on oea04=occ01) B'
         +' left join '+xBu+'.ima_file on oeb04=ima01) X'
         +' left join '+xBu+'.oao_file on oea01=oao01 and oeb03=oao03) Y'
         +' left join '+xBu+'.ocd_file on oea04=ocd01 and oea044=ocd02';
end;

function GetMPSSno(Indate:TDateTime):Integer;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Result:=-1;
  tmpSQL:='Select IsNull(Max(Sno),0)+1 Sno From Dli010'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(Indate))
         +' And IsNull(GarbageFlag,0)=0'
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
  if QueryOneCR(tmpSQL, Data) then
     Result:=Data;
end;

end.
