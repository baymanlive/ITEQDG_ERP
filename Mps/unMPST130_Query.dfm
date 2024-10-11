inherited FrmMPST130_Query: TFrmMPST130_Query
  Width = 500
  Height = 480
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderdate: TLabel [0]
    Left = 55
    Top = 28
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 209
    Top = 29
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblto'
  end
  object lblcustno: TLabel [2]
    Left = 68
    Top = 58
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [3]
    Left = 62
    Top = 88
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object lblpno: TLabel [4]
    Left = 81
    Top = 118
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblpno'
  end
  object Label1: TLabel [5]
    Left = 81
    Top = 148
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblpno'
  end
  inherited PnlRight: TPanel
    Left = 382
    Height = 451
    TabOrder = 10
  end
  object Dtp1: TDateTimePicker [7]
    Left = 115
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    ImeName = #23567#29436#27627
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [8]
    Left = 235
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    ImeName = #23567#29436#27627
    TabOrder = 1
  end
  object Edit1: TEdit [9]
    Left = 115
    Top = 55
    Width = 210
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 2
  end
  object Edit2: TEdit [10]
    Left = 115
    Top = 85
    Width = 210
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 3
  end
  object Rgp4: TRadioGroup [11]
    Left = 115
    Top = 345
    Width = 209
    Height = 45
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ITEQDG'
      'ITEQGZ')
    TabOrder = 9
  end
  object Rgp2: TRadioGroup [12]
    Left = 115
    Top = 235
    Width = 209
    Height = 45
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      #26410#29986#29983
      #24050#29986#29983
      #20840#37096)
    TabOrder = 7
  end
  object Edit3: TEdit [13]
    Left = 115
    Top = 115
    Width = 210
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 4
  end
  object Rgp1: TRadioGroup [14]
    Left = 115
    Top = 180
    Width = 209
    Height = 45
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'CCL'
      'PP'
      #20840#37096)
    TabOrder = 6
  end
  object Edit4: TEdit [15]
    Left = 115
    Top = 145
    Width = 210
    Height = 21
    ImeName = #23567#29436#27627
    TabOrder = 5
  end
  object Rgp3: TRadioGroup [16]
    Left = 115
    Top = 290
    Width = 209
    Height = 45
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      #26410#23436#24037
      #24050#23436#24037
      #20840#37096)
    TabOrder = 8
  end
end
