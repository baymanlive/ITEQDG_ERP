object ServerContainer: TServerContainer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 271
  Width = 415
  object DSServer1: TDSServer
    AutoStart = False
    Left = 64
    Top = 75
  end
  object DSTCPServerTransport1: TDSTCPServerTransport
    Port = 8901
    Server = DSServer1
    Filters = <>
    Left = 224
    Top = 129
  end
  object DSServerClass1: TDSServerClass
    OnGetClass = DSServerClass1GetClass
    Server = DSServer1
    Left = 200
    Top = 11
  end
end
