inherited FrmDLIR150_Query: TFrmDLIR150_Query
  Width = 540
  Height = 270
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblsaledate: TLabel [0]
    Left = 67
    Top = 28
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblsaledate'
  end
  object lblcustno: TLabel [1]
    Left = 73
    Top = 58
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [2]
    Left = 67
    Top = 88
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object Label1: TLabel [3]
    Left = 84
    Top = 118
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object btn_sp: TSpeedButton [4]
    Left = 332
    Top = 114
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btn_spClick
  end
  inherited PnlRight: TPanel
    Left = 414
    Height = 232
    TabOrder = 5
  end
  object Dtp1: TDateTimePicker [6]
    Left = 120
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Edit1: TEdit [7]
    Left = 120
    Top = 55
    Width = 210
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit [8]
    Left = 120
    Top = 85
    Width = 210
    Height = 21
    TabOrder = 2
  end
  object Edit3: TEdit [9]
    Left = 120
    Top = 115
    Width = 210
    Height = 21
    TabOrder = 3
  end
  object rgp: TRadioGroup [10]
    Left = 120
    Top = 145
    Width = 209
    Height = 49
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'DG'
      'GZ')
    TabOrder = 4
  end
end
