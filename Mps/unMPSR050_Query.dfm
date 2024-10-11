inherited FrmMPSR050_Query: TFrmMPSR050_Query
  Width = 400
  Height = 200
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblmachine: TLabel [0]
    Left = 56
    Top = 28
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblmachine'
  end
  object Label1: TLabel [1]
    Left = 76
    Top = 63
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [2]
    Left = 76
    Top = 98
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  inherited PnlRight: TPanel
    Left = 274
    Height = 161
    TabOrder = 3
  end
  object Cbb: TComboBox [4]
    Left = 112
    Top = 25
    Width = 100
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object Dtp1: TDateTimePicker [5]
    Left = 112
    Top = 60
    Width = 100
    Height = 21
    Date = 42191.711292164350000000
    Time = 42191.711292164350000000
    TabOrder = 1
    OnChange = Dtp1Change
  end
  object Dtp2: TDateTimePicker [6]
    Left = 112
    Top = 95
    Width = 100
    Height = 21
    Date = 42191.711344479170000000
    Time = 42191.711344479170000000
    TabOrder = 2
  end
end
