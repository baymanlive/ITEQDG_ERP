inherited FrmMPSR120_Query: TFrmMPSR120_Query
  Width = 500
  Height = 270
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderdate: TLabel [0]
    Left = 45
    Top = 27
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 199
    Top = 28
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblto'
  end
  object lblcustno: TLabel [2]
    Left = 58
    Top = 57
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [3]
    Left = 52
    Top = 87
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object Label1: TLabel [4]
    Left = 69
    Top = 117
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  inherited PnlRight: TPanel
    Left = 374
    Height = 231
    TabOrder = 6
  end
  object Dtp1: TDateTimePicker [6]
    Left = 105
    Top = 24
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [7]
    Left = 225
    Top = 24
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 1
  end
  object Edit1: TEdit [8]
    Left = 105
    Top = 54
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit [9]
    Left = 105
    Top = 84
    Width = 210
    Height = 21
    TabOrder = 3
  end
  object Rgp: TRadioGroup [10]
    Left = 105
    Top = 144
    Width = 209
    Height = 45
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ITEQDG'
      'ITEQGZ')
    TabOrder = 5
  end
  object Edit3: TEdit [11]
    Left = 105
    Top = 114
    Width = 210
    Height = 21
    TabOrder = 4
  end
end
