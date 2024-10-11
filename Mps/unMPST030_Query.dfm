inherited FrmMPST030_Query: TFrmMPST030_Query
  Width = 520
  Height = 380
  ActiveControl = Edit1
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderno: TLabel [0]
    Left = 83
    Top = 48
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object lblcustno: TLabel [1]
    Left = 89
    Top = 73
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblpno: TLabel [2]
    Left = 102
    Top = 98
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblpno'
  end
  object lblorderdate: TLabel [3]
    Left = 76
    Top = 23
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  inherited PnlRight: TPanel
    Left = 402
    Height = 353
    TabOrder = 9
  end
  object Dtp1: TDateTimePicker [5]
    Left = 135
    Top = 20
    Width = 95
    Height = 21
    Hint = #35330#21934#26085#26399'('#36215')'
    Date = 42429.370626250000000000
    Time = 42429.370626250000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [6]
    Left = 241
    Top = 20
    Width = 95
    Height = 21
    Hint = #35330#21934#26085#26399'('#36804')'
    Date = 42429.370663425930000000
    Time = 42429.370663425930000000
    TabOrder = 1
  end
  object Edit1: TEdit [7]
    Left = 135
    Top = 45
    Width = 200
    Height = 21
    Hint = #35330#21934#34399#30908
    TabOrder = 2
  end
  object Edit2: TEdit [8]
    Left = 135
    Top = 70
    Width = 200
    Height = 21
    Hint = #23458#25142#32232#34399
    TabOrder = 3
  end
  object Edit3: TEdit [9]
    Left = 135
    Top = 95
    Width = 200
    Height = 21
    Hint = #29289#21697#26009#34399
    TabOrder = 4
  end
  object RadioGroup1: TRadioGroup [10]
    Left = 65
    Top = 120
    Width = 270
    Height = 40
    Hint = #35330#21934#30906#35469
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      #26410#30906#35469
      #24050#30906#35469
      #20840#37096)
    TabOrder = 5
  end
  object RadioGroup2: TRadioGroup [11]
    Left = 65
    Top = 165
    Width = 270
    Height = 40
    Hint = #21407#35330#21934#32080#26696'+'#26412#22320#36039#26009#32080#26696
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      #26410#32080#26696
      #24050#32080#26696
      #20840#37096)
    TabOrder = 6
  end
  object RadioGroup3: TRadioGroup [12]
    Left = 65
    Top = 210
    Width = 270
    Height = 40
    Hint = #25033#20986#25976#37327#33287#24050#20986#25976#37327
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      #26410#20986#23436#36008
      #24050#20986#23436#36008
      #20840#37096)
    TabOrder = 7
  end
  object RadioGroup4: TRadioGroup [13]
    Left = 65
    Top = 255
    Width = 270
    Height = 40
    Hint = #25286#20132#26399
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      #26410#25286#20132#26399
      #24050#25286#20132#26399
      #20840#37096)
    TabOrder = 8
  end
end
