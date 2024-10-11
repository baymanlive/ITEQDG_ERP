inherited FrmDLIR210_Query: TFrmDLIR210_Query
  Width = 540
  Height = 294
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderdate: TLabel [0]
    Left = 60
    Top = 28
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 214
    Top = 29
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblto'
  end
  object lblcustno: TLabel [2]
    Left = 73
    Top = 58
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [3]
    Left = 67
    Top = 88
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  inherited PnlRight: TPanel
    Left = 414
    Height = 255
    TabOrder = 5
  end
  object Dtp1: TDateTimePicker [5]
    Left = 120
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [6]
    Left = 240
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 1
  end
  object Edit1: TEdit [7]
    Left = 120
    Top = 55
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit [8]
    Left = 120
    Top = 85
    Width = 210
    Height = 21
    TabOrder = 3
  end
  object Rgp1: TRadioGroup [9]
    Left = 120
    Top = 115
    Width = 210
    Height = 45
    Columns = 3
    Items.Strings = (
      '1'
      '2'
      '3')
    TabOrder = 4
  end
  object Rgp2: TRadioGroup [10]
    Left = 120
    Top = 171
    Width = 210
    Height = 45
    Columns = 2
    Items.Strings = (
      '1'
      '2')
    TabOrder = 6
  end
end
