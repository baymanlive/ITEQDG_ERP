inherited FrmDLIR140_Query: TFrmDLIR140_Query
  Width = 520
  Height = 320
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
  object Label1: TLabel [4]
    Left = 84
    Top = 118
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object btn_sp: TSpeedButton [5]
    Left = 332
    Top = 114
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btn_spClick
  end
  object Label2: TLabel [6]
    Left = 84
    Top = 148
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  inherited PnlRight: TPanel
    Left = 394
    Height = 281
    TabOrder = 7
  end
  object Dtp1: TDateTimePicker [8]
    Left = 120
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [9]
    Left = 240
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 1
  end
  object Edit1: TEdit [10]
    Left = 120
    Top = 55
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object Edit2: TEdit [11]
    Left = 120
    Top = 85
    Width = 210
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit [12]
    Left = 120
    Top = 115
    Width = 210
    Height = 21
    TabOrder = 4
  end
  object rgp: TRadioGroup [13]
    Left = 120
    Top = 185
    Width = 209
    Height = 49
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'DG'
      'GZ')
    TabOrder = 6
  end
  object Edit4: TEdit [14]
    Left = 120
    Top = 145
    Width = 210
    Height = 21
    TabOrder = 5
  end
end
