unit unIPQCT510_units;

interface

uses
  Classes, SysUtils;

type
  TTCPData = Record
    Machine,                           //���x
    Wono,                              //�u�渹�X
    ObjName   : string[20];            //���ئW��
    Data1     : string[255];           //�ƾ�:"/"���j
    Data2     : string[255];           //�ƾ�:"/"���j
end;

type
  TAddr = Record                       //�a�}
    Name: string;
end;

type
  TObj = Record                        //����
    Name    : string;
    ArrAddr : array of TAddr;
end;

type
  TMachine = Record                    //�u�O
    Machine : string;
    ArrObj  : array[0..4] of TObj;
end;

var
  g_ArrMachine  : array[0..4] of TMachine;   

implementation

end.
 