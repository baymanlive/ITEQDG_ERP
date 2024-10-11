unit unUtf8;

interface

uses
  Windows;

type
  UTF8String = AnsiString;

function AnsiToWide(const S: AnsiString): WideString;

function WideToUTF8(const WS: WideString): UTF8String;

function AnsiToUTF8(const S: AnsiString): UTF8String;

function UTF8ToWide(const US: UTF8String): WideString;

function WideToAnsi(const WS: WideString): AnsiString;

function UTF8ToAnsi(const S: UTF8String): AnsiString;

function BIG5ToGB(BIG5Str: string): AnsiString;

function GBToBIG5(GBStr: string): AnsiString;

function GBChs2Cht(GBStr: string): AnsiString;

function GBCht2Chs(GBStr: string): AnsiString;

function GBToBIG52(GBStr: string): AnsiString;

implementation

function AnsiToWide(const S: AnsiString): WideString;
var
  len: integer;
  ws: WideString;
begin
  Result := '';
  if (Length(S) = 0) then
    exit;
  len := MultiByteToWideChar(CP_ACP, 0, PChar(S), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_ACP, 0, PChar(S), -1, PWideChar(ws), len);
  Result := ws;
end;

function WideToUTF8(const WS: WideString): UTF8String;
var
  len: integer;
  us: UTF8String;
begin
  Result := '';
  if (Length(WS) = 0) then
    exit;
  len := WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(us, len);
  WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, PChar(us), len, nil, nil);
  Result := us;
end;

function AnsiToUTF8(const S: AnsiString): UTF8String;
begin
  Result := WideToUTF8(AnsiToWide(S));
end;

function UTF8To936(const str: UTF8String): AnsiString;
var
  len: integer;
  ws: WideString;
  s: AnsiString;
begin
  Result := '';
  if (Length(str) = 0) then
    exit;
  len := MultiByteToWideChar(CP_UTF8, 0, PChar(str), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_UTF8, 0, PChar(str), -1, PWideChar(ws), len);
  if (Length(ws) = 0) then
    exit;
  len := WideCharToMultiByte(950, 0, PWideChar(ws), -1, nil, 0, nil, nil);
  SetLength(s, len);
  WideCharToMultiByte(950, 0, PWideChar(ws), -1, PChar(s), len, nil, nil);
  Result := s;
end;

function UTF8ToAnsi(const S: UTF8String): AnsiString;
begin
  Result := WideToAnsi(UTF8ToWide(S));
end;

function UTF8ToWide(const US: UTF8String): WideString;
var
  len: integer;
  ws: WideString;
begin
  Result := '';
  if (Length(US) = 0) then
    exit;
  len := MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, PWideChar(ws), len);
  Result := ws;
end;

function WideToAnsi(const WS: WideString): AnsiString;
var
  len: integer;
  s: AnsiString;
begin
  Result := '';
  if (Length(WS) = 0) then
    exit;
  len := WideCharToMultiByte(936, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(s, len);
  WideCharToMultiByte(936, 0, PWideChar(WS), -1, PChar(s), len, nil, nil);
  Result := s;
end;

function BIG5ToGB(BIG5Str: string): AnsiString;
var
  Len: Integer;
  pBIG5Char: PChar;
  pGBCHSChar: PChar;
  pGBCHTChar: PChar;
  pUniCodeChar: PWideChar;
begin
   //String -> PChar
  pBIG5Char := PChar(BIG5Str);
  Len := MultiByteToWideChar(950, 0, pBIG5Char, -1, nil, 0);
  GetMem(pUniCodeChar, Len * 2);
  ZeroMemory(pUniCodeChar, Len * 2);
   //Big5 -> UniCode
  MultiByteToWideChar(950, 0, pBIG5Char, -1, pUniCodeChar, Len);
  Len := WideCharToMultiByte(936, 0, pUniCodeChar, -1, nil, 0, nil, nil);
  GetMem(pGBCHTChar, Len * 2);
  GetMem(pGBCHSChar, Len * 2);
  ZeroMemory(pGBCHTChar, Len * 2);
  ZeroMemory(pGBCHSChar, Len * 2);
   //UniCode->GB CHT
  WideCharToMultiByte(936, 0, pUniCodeChar, -1, pGBCHTChar, Len, nil, nil);
   //GB CHT -> GB CHS
  LCMapString($804, LCMAP_SIMPLIFIED_CHINESE, pGBCHTChar, -1, pGBCHSChar, Len);
  Result := string(pGBCHSChar);
  FreeMem(pGBCHTChar);
  FreeMem(pGBCHSChar);
  FreeMem(pUniCodeChar);
end;

function GBChs2Cht(GBStr: string): AnsiString;
var
  Len: integer;
  pGBCHTChar: PChar;
  pGBCHSChar: PChar;
begin
  pGBCHSChar := PChar(GBStr);
  Len := MultiByteToWideChar(936, 0, pGBCHSChar, -1, Nil, 0);
  GetMem(pGBCHTChar, Len * 2 + 1);
  ZeroMemory(pGBCHTChar, Len * 2 + 1);
  LCMapString($804, LCMAP_TRADITIONAL_CHINESE, pGBCHSChar, -1, pGBCHTChar, Len * 2);
  result := string(pGBCHTChar);
  FreeMem(pGBCHTChar);
end;

function GBCht2Chs(GBStr: string): AnsiString;
var
  Len: integer;
  pGBCHTChar: PChar;
  pGBCHSChar: PChar;
begin
  pGBCHTChar := PChar(GBStr);
  Len := MultiByteToWideChar(936, 0, pGBCHTChar, -1, Nil, 0);
  GetMem(pGBCHSChar, Len * 2 + 1);
  ZeroMemory(pGBCHSChar, Len * 2 + 1);
  LCMapString($804, LCMAP_SIMPLIFIED_CHINESE, pGBCHTChar, -1, pGBCHSChar, Len * 2);
  result := string(pGBCHSChar);
  FreeMem(pGBCHSChar);
end;

function GBToBIG5(GBStr: string): AnsiString;
var
  Len: Integer;
  pGBCHTChar: PChar;
  pGBCHSChar: PChar;
  pUniCodeChar: PWideChar;
  pBIG5Char: PChar;
begin
  pGBCHSChar := PChar(GBStr);
  Len := MultiByteToWideChar(936, 0, pGBCHSChar, -1, nil, 0);
  GetMem(pGBCHTChar, Len * 2 + 1);
  ZeroMemory(pGBCHTChar, Len * 2 + 1);
   //GB CHS -> GB CHT
  LCMapString($804, LCMAP_TRADITIONAL_CHINESE, pGBCHSChar, -1, pGBCHTChar, Len * 2);
  GetMem(pUniCodeChar, Len * 2);
  ZeroMemory(pUniCodeChar, Len * 2);
   //GB CHT -> UniCode
  MultiByteToWideChar(936, 0, pGBCHTChar, -1, pUniCodeChar, Len * 2);
  Len := WideCharToMultiByte(950, 0, pUniCodeChar, -1, nil, 0, nil, nil);
  GetMem(pBIG5Char, Len);
  ZeroMemory(pBIG5Char, Len);
   //UniCode -> Big5
  WideCharToMultiByte(950, 0, pUniCodeChar, -1, pBIG5Char, Len, nil, nil);
  Result := string(pBIG5Char);
  FreeMem(pBIG5Char);
  FreeMem(pGBCHTChar);
  FreeMem(pUniCodeChar);
end;

function GBToBIG52(GBStr: string): AnsiString;
var
  Len: Integer;
  pGBCHTChar: PChar;
  pGBCHSChar: PChar;
  pUniCodeChar: PWideChar;
  pBIG5Char: PChar;
begin

  pGBCHSChar := PChar(GBStr);

  Len := MultiByteToWideChar(936, 0, pGBCHSChar, -1, nil, 0);

  GetMem(pGBCHTChar, Len * 2 + 1);

  ZeroMemory(pGBCHTChar, Len * 2 + 1);

   //GB CHS -> GB CHT

  LCMapString($804, LCMAP_TRADITIONAL_CHINESE, pGBCHSChar, -1, pGBCHTChar, Len * 2);

  GetMem(pUniCodeChar, Len * 2);

  ZeroMemory(pUniCodeChar, Len * 2);

   //GB CHT -> UniCode

  MultiByteToWideChar(936, 0, pGBCHTChar, -1, pUniCodeChar, Len * 2);

  Len := WideCharToMultiByte(950, 0, pUniCodeChar, -1, nil, 0, nil, nil);

  GetMem(pBIG5Char, Len);

  ZeroMemory(pBIG5Char, Len);

   //UniCode -> Big5

  WideCharToMultiByte(950, 0, pUniCodeChar, -1, pBIG5Char, Len, nil, nil);

  Result := string(pBIG5Char);

  FreeMem(pBIG5Char);
  FreeMem(pGBCHTChar);
  FreeMem(pUniCodeChar);
end;

end.

