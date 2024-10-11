// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.4.14/DLIT802Service.asmx?wsdl
// Encoding : utf-8
// Version  : 1.0
// (2020-12-23 09:49:56 - 1.33.2.5)
// ************************************************************************ //

unit unDLIT802Service;

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
  // soapAction: http://tempuri.org/cimt324dw_add
  // transport : http://schemas.xmlsoap.org/soap/http
  // binding   : DLIT802ServiceSoap
  // service   : DLIT802Service
  // port      : DLIT802ServiceSoap
  // URL       : http://192.168.4.14/DLIT802Service.asmx
  // ************************************************************************ //
  DLIT802ServiceSoap = interface(IInvokable)
  ['{F1242CB9-45C9-BBF1-0B1B-BB758672BA5F}']
    function  cimt324dw_add(const oradb: WideString; const saleno: WideString; const stkarea: WideString; const userid: WideString): WideString; stdcall;
  end;

function GetDLIT802ServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): DLIT802ServiceSoap;


implementation

function GetDLIT802ServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): DLIT802ServiceSoap;
const
  defWSDL = 'http://192.168.4.14/DLIT802Service.asmx?wsdl';
  defURL  = 'http://192.168.4.14/DLIT802Service.asmx';
  defSvc  = 'DLIT802Service';
  defPrt  = 'DLIT802ServiceSoap';
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
    Result := (RIO as DLIT802ServiceSoap);
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
  InvRegistry.RegisterInterface(TypeInfo(DLIT802ServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterInvokeOptions(TypeInfo(DLIT802ServiceSoap), ioDocument); //¦Û¤v²K¥[
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(DLIT802ServiceSoap), 'http://tempuri.org/cimt324dw_add');

end.