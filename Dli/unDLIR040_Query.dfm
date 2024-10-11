inherited FrmDLIR040_Query: TFrmDLIR040_Query
  Left = 677
  Top = 222
  Width = 480
  Height = 285
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 113
    Top = 28
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 113
    Top = 58
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  object Label3: TLabel [2]
    Left = 113
    Top = 88
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  inherited PnlRight: TPanel
    Left = 354
    Height = 247
    TabOrder = 5
  end
  object Dtp: TDateTimePicker [4]
    Left = 149
    Top = 24
    Width = 100
    Height = 21
    Date = 42284.000000000000000000
    Time = 42284.000000000000000000
    TabOrder = 0
  end
  object RadioGroup1: TRadioGroup [5]
    Left = 80
    Top = 117
    Width = 210
    Height = 42
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      'PP'
      'CCL'
      'ALL')
    TabOrder = 3
  end
  object Edit1: TEdit [6]
    Left = 149
    Top = 55
    Width = 100
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit [7]
    Left = 149
    Top = 85
    Width = 100
    Height = 21
    TabOrder = 2
  end
  object RadioGroup2: TRadioGroup [8]
    Left = 80
    Top = 165
    Width = 210
    Height = 42
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #24050#20986#36008
      #26410#20986#36008
      #20840#37096)
    TabOrder = 4
  end
end
