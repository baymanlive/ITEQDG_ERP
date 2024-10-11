unit unDLIT7XX_units;

interface

uses
  SysUtils, DateUtils, StrUtils, Variants, unGlobal, unCommon;

function GetNewCno(TableName,FormatStr:string; D:TDatetime):string;

implementation

//·s¸¹½X
function GetNewCno(TableName,FormatStr:string; D:TDatetime):string;
var
  tmpSQL,tmpStr,s,s1,s2:string;
  pos1:Integer;
  Data:OleVariant;
begin
  Result:='';
  if (Length(FormatStr)=0) or (D<EnCodeDate(2000,1,1)) then
     Exit;

  tmpStr:=UpperCase(Trim(FormatStr));
  pos1:=Pos('-',tmpStr);
  if pos1>0 then
     s:=LeftStr(tmpStr,pos1);

  pos1:=Pos('9',tmpStr);
  if pos1=0 then
  begin
    pos1:=Length(tmpStr)+1;
    tmpStr:=tmpStr+'9999';
  end;

  s1:=Copy(tmpStr,Length(s)+1,pos1-1-Length(s));
  s1:=StringReplace(s1,'YYYY',FormatDateTime('YYYY',D),[rfReplaceAll]);
  s1:=StringReplace(s1,'YY',FormatDateTime('YY',D),[rfReplaceAll]);
  s1:=StringReplace(s1,'MM',FormatDateTime('MM',D),[rfReplaceAll]);
  if pos('M',s1)>0 then
  begin
    case MonthOf(D) of
      10:s1:=StringReplace(s1,'M','A',[rfReplaceAll]);
      11:s1:=StringReplace(s1,'M','B',[rfReplaceAll]);
      12:s1:=StringReplace(s1,'M','C',[rfReplaceAll]);
      else
         s1:=StringReplace(s1,'M',FormatDateTime('M',D),[rfReplaceAll]);
    end;
  end;
  s1:=StringReplace(s1,'DD',FormatDateTime('DD',D),[rfReplaceAll]);
  s1:=StringReplace(s1,'D',FormatDateTime('D',D),[rfReplaceAll]);

  s2:=Copy(tmpStr,pos1,50);
  tmpStr:='';
  pos1:=1;
  while pos1<=Length(s2) do
  begin
    tmpStr:=tmpStr+'0';
    Inc(pos1);
  end;
  s2:=tmpStr;

  tmpSQL:='select top 1 cno from '+TableName+' where cno like '+Quotedstr(s+s1+'%')
         +' and bu='+Quotedstr(g_UInfo^.BU)
         +' and isnumeric(substring(cno,'+IntToStr(Length(s1)+1)+',50))=1'
         +' order by cno desc';
  if not QueryOneCR(tmpSQL, Data) then
     Exit;

  if VarIsNull(Data) then
     tmpStr:=''
  else
     tmpStr:=VarToStr(Data);
  if Length(tmpStr)=0 then
     Result:=s+s1+Copy(s2,1,Length(s2)-1)+'1'
  else begin
    tmpStr:=Copy(tmpStr,Length(s1)+1,50);
    Result:=s+s1+RightStr('000000000000000'+IntToStr(StrToInt(tmpStr)+1),Length(s2));
  end;
end;

end.
