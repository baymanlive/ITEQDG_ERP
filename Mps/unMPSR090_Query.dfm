inherited FrmMPSR090_Query: TFrmMPSR090_Query
  Width = 480
  Height = 200
  ActiveControl = Edit1
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderno: TLabel [0]
    Left = 39
    Top = 56
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object lblcustno: TLabel [1]
    Left = 45
    Top = 81
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblpno: TLabel [2]
    Left = 58
    Top = 106
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblpno'
  end
  object lblorderdate: TLabel [3]
    Left = 32
    Top = 31
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  inherited PnlRight: TPanel
    Left = 354
    Height = 162
    TabOrder = 5
    inherited btn_ok: TBitBtn
      Hint = #30906#23450#26597#35426
    end
  end
  object Dtp1: TDateTimePicker [5]
    Left = 95
    Top = 28
    Width = 95
    Height = 21
    Hint = #35330#21934#26085#26399'('#36215')'
    Date = 42429.370626250000000000
    Time = 42429.370626250000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [6]
    Left = 201
    Top = 28
    Width = 95
    Height = 21
    Hint = #35330#21934#26085#26399'('#36804')'
    Date = 42429.370663425930000000
    Time = 42429.370663425930000000
    TabOrder = 1
  end
  object Edit1: TEdit [7]
    Left = 95
    Top = 53
    Width = 200
    Height = 21
    Hint = #35330#21934#34399#30908
    TabOrder = 2
  end
  object Edit2: TEdit [8]
    Left = 95
    Top = 78
    Width = 200
    Height = 21
    Hint = #23458#25142#32232#34399
    TabOrder = 3
  end
  object Edit3: TEdit [9]
    Left = 95
    Top = 103
    Width = 200
    Height = 21
    Hint = #29289#21697#26009#34399
    TabOrder = 4
  end
end
