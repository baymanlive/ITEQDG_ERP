unit ERPServer_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2021/9/12 ¤U¤È 07:15:23 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\ERP_20210823\ERP\ERP\Server\ERPServer.tlb (1)
// LIBID: {7F85EB33-42C4-4803-B7C8-3F8F74D64D95}
// LCID: 0
// Helpfile: 
// HelpString: ERPServer Library
// DepndLst: 
//   (1) v1.0 Midas, (C:\WINDOWS\system32\midas.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, Midas, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ERPServerMajorVersion = 1;
  ERPServerMinorVersion = 0;

  LIBID_ERPServer: TGUID = '{7F85EB33-42C4-4803-B7C8-3F8F74D64D95}';

  IID_IRdm: TGUID = '{BA4E4E03-AE15-48A8-8F15-AEDED51A6C12}';
  CLASS_Rdm: TGUID = '{8AC0DD42-EC97-4270-8553-C0D47420670D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRdm = interface;
  IRdmDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Rdm = IRdm;


// *********************************************************************//
// Interface: IRdm
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA4E4E03-AE15-48A8-8F15-AEDED51A6C12}
// *********************************************************************//
  IRdm = interface(IAppServer)
    ['{BA4E4E03-AE15-48A8-8F15-AEDED51A6C12}']
    function Login(const IP: WideString; const ComputerName: WideString; const Bu: WideString; 
                   const UserId: WideString; const Password: WideString; out ID: WideString; 
                   out Err: WideString): WordBool; safecall;
    function LogOut(const ID: WideString; out Err: WideString): WordBool; safecall;
    function QueryBySQL(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                        const SelectSQL: WideString; out Data: OleVariant; out Err: WideString): WordBool; safecall;
    function PostByDelta(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                         const UpdateTable: WideString; Delta: OleVariant; out Err: WideString): WordBool; safecall;
    function PostBySQL(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                       const CommandText: WideString; out Err: WideString): WordBool; safecall;
    function QueryOneCR(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                        const SelectSQL: WideString; out Value: OleVariant; out Err: WideString): WordBool; safecall;
    function QueryExists(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                         const SelectSQL: WideString; out isExist: WordBool; out Err: WideString): WordBool; safecall;
    function ExecStoredProc(const ID: WideString; const ProcId: WideString; 
                            const Dbtype: WideString; const StoredProcName: WideString; 
                            ArrPars: OleVariant; out Data: OleVariant; out Err: WideString): WordBool; safecall;
    function GetBu(const Dbtype: WideString; out Data: OleVariant; out Err: WideString): WordBool; safecall;
    function PostByJoinSQL(const ID: WideString; const ProcId: WideString; 
                           const Dbtype: WideString; const JoinSQL: WideString; Delta: OleVariant; 
                           out Err: WideString): WordBool; safecall;
    function CheckLockProc(const ProcId: WideString; out IsLock: WordBool; out Err: WideString): WordBool; safecall;
    function LockProc(const ProcId: WideString; const UserId: WideString; out Err: WideString): WordBool; safecall;
    function UnLockProc(const ProcId: WideString; out Err: WideString): WordBool; safecall;
    function GetMPSEmptyOZ(const Jitem: WideString; const Filter: WideString; out OZ: WideString; 
                           out Err: WideString): WordBool; safecall;
    function COCEmail(const Dbtype: WideString; out Err: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRdmDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BA4E4E03-AE15-48A8-8F15-AEDED51A6C12}
// *********************************************************************//
  IRdmDisp = dispinterface
    ['{BA4E4E03-AE15-48A8-8F15-AEDED51A6C12}']
    function Login(const IP: WideString; const ComputerName: WideString; const Bu: WideString; 
                   const UserId: WideString; const Password: WideString; out ID: WideString; 
                   out Err: WideString): WordBool; dispid 301;
    function LogOut(const ID: WideString; out Err: WideString): WordBool; dispid 302;
    function QueryBySQL(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                        const SelectSQL: WideString; out Data: OleVariant; out Err: WideString): WordBool; dispid 303;
    function PostByDelta(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                         const UpdateTable: WideString; Delta: OleVariant; out Err: WideString): WordBool; dispid 304;
    function PostBySQL(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                       const CommandText: WideString; out Err: WideString): WordBool; dispid 305;
    function QueryOneCR(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                        const SelectSQL: WideString; out Value: OleVariant; out Err: WideString): WordBool; dispid 307;
    function QueryExists(const ID: WideString; const ProcId: WideString; const Dbtype: WideString; 
                         const SelectSQL: WideString; out isExist: WordBool; out Err: WideString): WordBool; dispid 306;
    function ExecStoredProc(const ID: WideString; const ProcId: WideString; 
                            const Dbtype: WideString; const StoredProcName: WideString; 
                            ArrPars: OleVariant; out Data: OleVariant; out Err: WideString): WordBool; dispid 308;
    function GetBu(const Dbtype: WideString; out Data: OleVariant; out Err: WideString): WordBool; dispid 309;
    function PostByJoinSQL(const ID: WideString; const ProcId: WideString; 
                           const Dbtype: WideString; const JoinSQL: WideString; Delta: OleVariant; 
                           out Err: WideString): WordBool; dispid 310;
    function CheckLockProc(const ProcId: WideString; out IsLock: WordBool; out Err: WideString): WordBool; dispid 311;
    function LockProc(const ProcId: WideString; const UserId: WideString; out Err: WideString): WordBool; dispid 312;
    function UnLockProc(const ProcId: WideString; out Err: WideString): WordBool; dispid 313;
    function GetMPSEmptyOZ(const Jitem: WideString; const Filter: WideString; out OZ: WideString; 
                           out Err: WideString): WordBool; dispid 314;
    function COCEmail(const Dbtype: WideString; out Err: WideString): WordBool; dispid 315;
    function AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; MaxErrors: Integer; 
                             out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                           Options: Integer; const CommandText: WideString; var Params: OleVariant; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function AS_GetProviderNames: OleVariant; dispid 20000003;
    function AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoRdm provides a Create and CreateRemote method to          
// create instances of the default interface IRdm exposed by              
// the CoClass Rdm. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRdm = class
    class function Create: IRdm;
    class function CreateRemote(const MachineName: string): IRdm;
  end;

implementation

uses ComObj;

class function CoRdm.Create: IRdm;
begin
  Result := CreateComObject(CLASS_Rdm) as IRdm;
end;

class function CoRdm.CreateRemote(const MachineName: string): IRdm;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Rdm) as IRdm;
end;

end.
