unit unMPST012_ClsStock;

interface

uses
   Classes, SysUtils;

type
  TMPST012_ClsStock = class
  private
  public
    gid:string;
    // 訂單信息
	  uuid:string;
	  orderno:string;
	  orderitem:integer;
    materialno:string;
    custno:string;
    custom:string;
	  orderQty:double;
	  sQty:double;
    orderBu:string;

    // 庫存信息
	  dbtype:string;
    materialno1:string;
	  wareHouseNo:string;
	  storageNo:string;
	  batchNo:string;
	  stockQty:double;
    rStockQty:double;
	  isActive:string;
    custno1:string;
    custom1:string;

    constructor Create;
    destructor Destroy; override;
    function GetGUID: string;
  end;

implementation

constructor TMPST012_ClsStock.Create;
begin
end;

destructor TMPST012_ClsStock.Destroy;
begin
  inherited Destroy;
end;

function TMPST012_ClsStock.GetGUID: string;
var
  LTep: TGUID;
  sGUID: string;
begin
  CreateGUID(LTep);
  sGUID := GUIDToString(LTep);
  sGUID := StringReplace(sGUID, '-', '', [rfReplaceAll]);
  sGUID := Copy(sGUID, 2, Length(sGUID) - 2);
  Result := sGUID;
end;

end.
