// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.4.14/AC172Service.asmx?wsdl
// Encoding : utf-8
// Version  : 1.0
// (2018-11-14 09:50:20 - 1.33.2.5)
// ************************************************************************ //

unit unAC172Service;

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
  // !:int             - "http://www.w3.org/2001/XMLSchema"



  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/AC172
  // transport : http://schemas.xmlsoap.org/soap/http
  // binding   : AC172ServiceSoap
  // service   : AC172Service
  // port      : AC172ServiceSoap
  // URL       : http://192.168.4.14/AC172Service.asmx
  // ************************************************************************ //
  AC172ServiceSoap = interface(IInvokable)
  ['{4947FB7A-BABC-929E-906F-F7842B2E92CA}']
    function  AC172(const Bu: WideString; const Saleno: WideString; const Saleitem: Integer): WideString; stdcall;
  end;

function GetAC172ServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): AC172ServiceSoap;


implementation

function GetAC172ServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): AC172ServiceSoap;
const
  defWSDL = 'http://192.168.4.14/AC172Service.asmx?wsdl';
  defURL  = 'http://192.168.4.14/AC172Service.asmx';
  defSvc  = 'AC172Service';
  defPrt  = 'AC172ServiceSoap';
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
    Result := (RIO as AC172ServiceSoap);
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
  InvRegistry.RegisterInterface(TypeInfo(AC172ServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterInvokeOptions(TypeInfo(AC172ServiceSoap), ioDocument); //¦Û¤v²K¥[
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(AC172ServiceSoap), 'http://tempuri.org/AC172');

end. 