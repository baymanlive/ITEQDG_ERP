// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.4.14/ACC58Service.asmx?wsdl
// Encoding : utf-8
// Version  : 1.0
// (2020/5/4 16:14:26 - 1.33.2.5)
// ************************************************************************ //

unit unACC58Service;

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
  // binding   : ACC58ServiceSoap
  // service   : ACC58Service
  // port      : ACC58ServiceSoap
  // URL       : http://192.168.4.14/ACC58Service.asmx
  // ************************************************************************ //
  ACC58ServiceSoap = interface(IInvokable)
  ['{1C183AFB-E0DE-6AF3-DB22-9DE68C8F7624}']
    function  ACC58(const Bu: WideString; const Saleno: WideString; const UserId: WideString): WideString; stdcall;
    function  ACC58_del(const Bu: WideString; const Saleno: WideString): WideString; stdcall;
  end;

function GetACC58ServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ACC58ServiceSoap;


implementation

function GetACC58ServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ACC58ServiceSoap;
const
  defWSDL = 'http://192.168.4.14/ACC58Service.asmx?wsdl';
  defURL  = 'http://192.168.4.14/ACC58Service.asmx';
  defSvc  = 'ACC58Service';
  defPrt  = 'ACC58ServiceSoap';
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
    Result := (RIO as ACC58ServiceSoap);
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
  InvRegistry.RegisterInterface(TypeInfo(ACC58ServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ACC58ServiceSoap), ioDocument); //¦Û¤v²K¥[
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ACC58ServiceSoap), 'http://tempuri.org/%operationName%');

end.
