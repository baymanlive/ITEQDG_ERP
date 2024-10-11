//加密與解密, 加密結果長度: N*3+3
//kaikai
//2015

library Encrypt;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes;

{$R *.res}

const stringKey='kai4633kai';

//encrypt 加密
procedure EncryptX(SourceStr, DestStr:Pchar); stdcall;
var
  KeyLen,KeyPos,offset,SrcPos,SrcAsc :Integer;
  tmpstr,dest:string;
begin
  if Length(SourceStr)=0 then
  begin
    strcopy(DestStr,'');
    Exit;
  end;

  tmpstr:=strPas(SourceStr);
  KeyLen:=Length(stringKey);
  KeyPos:=0;
  Randomize;
  offset:=Random(1000);
  dest:=format('%1.3x',[offset]);
  for SrcPos := 1 to Length(tmpstr) do
  begin
    SrcAsc:=(Ord(tmpstr[SrcPos]) + offset) MOD 999;
    if KeyPos < KeyLen then
       KeyPos:= KeyPos + 1
     else
       KeyPos:=1;
    SrcAsc:= SrcAsc xor Ord(stringKey[KeyPos]);
    dest:=dest+format('%1.3x',[SrcAsc]) ;
    offset:=SrcAsc;
  end;
  
  strcopy(DestStr,Pchar(dest));
end;

//Decrypt 解密
procedure DecryptX(SourceStr, DestStr:Pchar); stdcall;
var
  KeyLen,KeyPos,offset,SrcPos,SrcAsc,TmpSrcAsc:Integer;
  dest:string;
begin
  dest:='';
  if Length(SourceStr)>3 then
  begin
  try
    KeyLen:=Length(stringKey);
    KeyPos:=0;
    offset:=StrToInt('$'+ copy(SourceStr,1,3));
    SrcPos:=4;
    repeat
      SrcAsc:=StrToInt('$'+ copy(SourceStr,SrcPos,3));
      if KeyPos < KeyLen Then
        KeyPos := KeyPos + 1
       else
         KeyPos := 1;
      TmpSrcAsc := SrcAsc xor Ord(stringKey[KeyPos]);
      if TmpSrcAsc <= offset then
        TmpSrcAsc := 999 + TmpSrcAsc - offset
      else
        TmpSrcAsc := TmpSrcAsc - offset;
      dest:=dest + chr(TmpSrcAsc);
      offset:=srcAsc;
      SrcPos:=SrcPos + 3;
    until SrcPos >= Length(SourceStr);
    except
      dest:='';
    end;
  end;
  strcopy(DestStr,Pchar(dest));
end;

exports
    EncryptX name 'Encrypt',
    DecryptX name 'Decrypt';

begin
end.
