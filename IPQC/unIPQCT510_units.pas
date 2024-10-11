unit unIPQCT510_units;

interface

uses
  Classes, SysUtils;

type
  TTCPData = Record
    Machine,                           //機台
    Wono,                              //工單號碼
    ObjName   : string[20];            //項目名稱
    Data1     : string[255];           //數據:"/"分隔
    Data2     : string[255];           //數據:"/"分隔
end;

type
  TAddr = Record                       //地址
    Name: string;
end;

type
  TObj = Record                        //項目
    Name    : string;
    ArrAddr : array of TAddr;
end;

type
  TMachine = Record                    //線別
    Machine : string;
    ArrObj  : array[0..4] of TObj;
end;

var
  g_ArrMachine  : array[0..4] of TMachine;   

implementation

end.
 