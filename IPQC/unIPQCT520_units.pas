unit unIPQCT520_units;

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
  TAddr = Record                       //�l����,�a�}+�W��
    //Addr,
    Name: string;
end;

type
  TObj = Record                        //�j����
    Name        : string;
    AllObjName  : string;              //�Ҧ��l����,�r���s��
    ArrAddr     : array of TAddr;
    DataList    : TStrings;            //�ƾ�
end;

type
  TMachine = Record                    //�u�O
    Machine         : string;
    MonitorObjList,                    //�ʵ�����
    MonitorDataList : TStrings;        //�ʵ����ؼƭ�
    ArrObj          : array[0..4] of TObj;
end;

var
  g_ArrMachine  : array[0..4] of TMachine;   

implementation

end.
 