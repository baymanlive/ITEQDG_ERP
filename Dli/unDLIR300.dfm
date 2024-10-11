inherited FrmDLIR300: TFrmDLIR300
  Left = 157
  Top = 78
  Caption = 'DLIR300'
  ClientHeight = 886
  ClientWidth = 1868
  PixelsPerInch = 96
  TextHeight = 13
  object oga01: TLabel [0]
    Left = 16
    Top = 48
    Width = 52
    Height = 13
    Caption = #20986#36008#21934#34399
  end
  object oga02: TLabel [1]
    Left = 16
    Top = 72
    Width = 52
    Height = 13
    Caption = #20986#36008#26085#26399
  end
  object oga032: TLabel [2]
    Left = 216
    Top = 72
    Width = 52
    Height = 13
    Caption = #23458#25142#31777#31281
  end
  object oga011: TLabel [3]
    Left = 216
    Top = 48
    Width = 78
    Height = 13
    Caption = #20986#36008#36890#30693#21934#34399
  end
  inherited DBGridEh1: TDBGridEh [4]
    Top = 104
    Width = 1862
    Height = 749
    Align = alNone
    DataSource = DS2
  end
  inherited ToolBar: TToolBar [5]
    Width = 1868
  end
  inherited PnlBottom: TPanel [6]
    Top = 856
    Width = 1868
  end
  inherited Panel1: TPanel [7]
    Width = 1868
  end
  object DBEdit1: TDBEdit [8]
    Left = 72
    Top = 44
    Width = 121
    Height = 21
    DataField = 'oga01'
    DataSource = DS
    ImeName = #23567#29436#27627
    TabOrder = 4
  end
  object DBEdit2: TDBEdit [9]
    Left = 72
    Top = 68
    Width = 121
    Height = 21
    DataField = 'oga02'
    DataSource = DS
    ImeName = #23567#29436#27627
    TabOrder = 5
  end
  object DBEdit3: TDBEdit [10]
    Left = 304
    Top = 44
    Width = 121
    Height = 21
    DataField = 'oga011'
    DataSource = DS
    ImeName = #23567#29436#27627
    TabOrder = 6
  end
  object DBEdit4: TDBEdit [11]
    Left = 304
    Top = 68
    Width = 121
    Height = 21
    DataField = 'oga032'
    DataSource = DS
    ImeName = #23567#29436#27627
    TabOrder = 7
  end
  object DBEdit5: TDBEdit [12]
    Left = 464
    Top = 44
    Width = 121
    Height = 21
    DataField = 'SNO'
    DataSource = DS
    ImeName = #23567#29436#27627
    TabOrder = 8
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 705
    Top = 93
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 677
    Top = 93
  end
  object cdssno: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 784
    Top = 64
    object cdssnosno: TStringField
      FieldName = 'sno'
      Size = 1000
    end
  end
end
