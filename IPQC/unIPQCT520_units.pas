unit unIPQCT520_units;

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
  TAddr = Record                       //子項目,地址+名稱
    //Addr,
    Name: string;
end;

type
  TObj = Record                        //大項目
    Name        : string;
    AllObjName  : string;              //所有子項目,逗號連接
    ArrAddr     : array of TAddr;
    DataList    : TStrings;            //數據
end;

type
  TMachine = Record                    //線別
    Machine         : string;
    MonitorObjList,                    //監視項目
    MonitorDataList : TStrings;        //監視項目數值
    ArrObj          : array[0..4] of TObj;
end;

var
  g_ArrMachine  : array[0..4] of TMachine;   

implementation

end.
 