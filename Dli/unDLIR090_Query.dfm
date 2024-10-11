inherited FrmDLIR090_Query: TFrmDLIR090_Query
  Width = 500
  Height = 440
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 108
    Top = 44
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 108
    Top = 69
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  object lblsaleno: TLabel [2]
    Left = 98
    Top = 94
    Width = 42
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblsaleno'
  end
  object lblcustno: TLabel [3]
    Left = 97
    Top = 119
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object Label3: TLabel [4]
    Left = 108
    Top = 144
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  inherited PnlRight: TPanel
    Left = 374
    Height = 402
    TabOrder = 11
  end
  object Dtp1: TDateTimePicker [6]
    Left = 144
    Top = 40
    Width = 100
    Height = 21
    Date = 42284.000000000000000000
    Time = 42284.000000000000000000
    TabOrder = 2
  end
  object Edit1: TEdit [7]
    Left = 144
    Top = 90
    Width = 100
    Height = 21
    TabOrder = 4
  end
  object Dtp2: TDateTimePicker [8]
    Left = 144
    Top = 65
    Width = 100
    Height = 21
    Date = 42284.000000000000000000
    Time = 42284.000000000000000000
    TabOrder = 3
  end
  object Edit2: TEdit [9]
    Left = 144
    Top = 115
    Width = 100
    Height = 21
    TabOrder = 5
  end
  object Rgp1: TRadioGroup [10]
    Left = 60
    Top = 176
    Width = 229
    Height = 40
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #26410#20986#24288
      #24050#20986#24288
      #20840#37096)
    TabOrder = 7
  end
  object Rgp2: TRadioGroup [11]
    Left = 60
    Top = 220
    Width = 229
    Height = 40
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #26410#22238#32879
      #24050#22238#32879
      #20840#37096)
    TabOrder = 8
  end
  object Rgp3: TRadioGroup [12]
    Left = 60
    Top = 264
    Width = 229
    Height = 40
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #26410#31805#25910
      #24050#31805#25910
      #20840#37096)
    TabOrder = 9
  end
  object RB1: TRadioButton [13]
    Left = 80
    Top = 15
    Width = 85
    Height = 17
    Caption = #27966#36554#26085#26399
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = RB1Click
  end
  object RB2: TRadioButton [14]
    Left = 172
    Top = 15
    Width = 93
    Height = 17
    Caption = #36865#36008#21934#26085#26399
    TabOrder = 1
    OnClick = RB1Click
  end
  object Rgp4: TRadioGroup [15]
    Left = 60
    Top = 308
    Width = 229
    Height = 40
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #26410#21015#21360
      #24050#21015#21360
      #20840#37096)
    TabOrder = 10
  end
  object Edit3: TEdit [16]
    Left = 144
    Top = 140
    Width = 100
    Height = 21
    TabOrder = 6
  end
end
