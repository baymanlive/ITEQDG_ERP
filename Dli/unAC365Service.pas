// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.4.14/AC365Service.asmx?wsdl
// Encoding : utf-8
// Version  : 1.0
// (2020/8/28 下午 02:17:49 - 1.33.2.5)
// ************************************************************************ //

unit unAC365Service;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"



  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // binding   : AC365ServiceSoap
  // service   : AC365Service
  // port      : AC365ServiceSoap
  // URL       : http://192.168.4.14/AC365Service.asmx
  // ************************************************************************ //
  AC365ServiceSoap = interface(IInvokable)
  ['{D60A055B-AD0C-25BA-18E3-02792C6E4070}']
    function  AC365(const Bu: WideString; const Saleno: WideString; const UserId: WideString): WideString; stdcall;
    function  Check(const Bu: WideString; const Saleno: WideString): WideString; stdcall;
  end;

function GetAC365ServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): AC365ServiceSoap;


implementation

function GetAC365ServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): AC365ServiceSoap;
const
  defWSDL = 'http://192.168.4.14/AC365Service.asmx?wsdl';
  defURL  = 'http://192.168.4.14/AC365Service.asmx';
  defSvc  = 'AC365Service';
  defPrt  = 'AC365ServiceSoap';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as AC365ServiceSoap);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(AC365ServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterInvokeOptions(TypeInfo(AC365ServiceSoap), ioDocument); //自己添加
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(AC365ServiceSoap), 'http://tempuri.org/%operationName%');

end.