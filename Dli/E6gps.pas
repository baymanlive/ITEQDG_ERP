// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.4.90:8088/E6gps.asmx?wsdl
// Encoding : utf-8
// Codegen  : [wfDebug,wfUseSerializerClassForAttrs]
// Version  : 1.0
// (2023-03-14 16:37:40 - 1.33.2.5)
// ************************************************************************ //

unit E6gps;

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
  // soapAction: http://tempuri.org/GetAddress
  // transport : http://schemas.xmlsoap.org/soap/http
  // binding   : E6gpsSoap
  // service   : E6gps
  // port      : E6gpsSoap
  // URL       : http://192.168.4.90:8088/E6gps.asmx
  // ************************************************************************ //
  E6gpsSoap = interface(IInvokable)
  ['{CDAF1520-E26B-624D-BFF9-86D694BBDA4B}']
    function  GetAddress(const CarCode: WideString): WideString; stdcall;
  end;

function GetE6gpsSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): E6gpsSoap;


implementation

function GetE6gpsSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): E6gpsSoap;
const
  defWSDL = 'http://192.168.4.19:8088/E6gps.asmx?wsdl';
  defURL  = 'http://192.168.4.19:8088/E6gps.asmx';
  defSvc  = 'E6gps';
  defPrt  = 'E6gpsSoap';
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
    RIO.HTTPWebNode.UseUTF8InHeader:= True;
  try
    Result := (RIO as E6gpsSoap);
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
  InvRegistry.RegisterInterface(TypeInfo(E6gpsSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterInvokeOptions(TypeInfo(E6gpsSoap), ioDocument);
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(E6gpsSoap), 'http://tempuri.org/GetAddress');

end. 