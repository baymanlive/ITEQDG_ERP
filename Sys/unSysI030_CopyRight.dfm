inherited FrmSysI030_CopyRight: TFrmSysI030_CopyRight
  Width = 460
  Height = 220
  Caption = 'FrmSysI030_CopyRight'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SourceId: TLabel [0]
    Left = 72
    Top = 54
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'SourceId'
  end
  object DestId: TLabel [1]
    Left = 83
    Top = 99
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'DestId'
  end
  object Label1: TLabel [2]
    Left = 230
    Top = 53
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel [3]
    Left = 230
    Top = 98
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  inherited PnlRight: TPanel
    Left = 334
    Height = 181
  end
  object Cbb1: TComboBox [5]
    Left = 121
    Top = 50
    Width = 98
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = Cbb1Change
  end
  object Cbb2: TComboBox [6]
    Left = 121
    Top = 95
    Width = 98
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = Cbb2Change
  end
end
