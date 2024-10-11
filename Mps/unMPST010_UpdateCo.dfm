inherited FrmUpdateCo: TFrmUpdateCo
  Width = 480
  Height = 260
  Caption = #37509#31636#26356#26032
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 112
    Top = 33
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 112
    Top = 103
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label3: TLabel [2]
    Left = 112
    Top = 68
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  inherited PnlRight: TPanel
    Left = 354
    Height = 221
    TabOrder = 4
  end
  object rgp: TRadioGroup [4]
    Left = 92
    Top = 130
    Width = 177
    Height = 45
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'L1~L5'
      'L6')
    TabOrder = 3
  end
  object dtp1: TDateTimePicker [5]
    Left = 148
    Top = 30
    Width = 120
    Height = 21
    Date = 43102.000000000000000000
    Time = 43102.000000000000000000
    TabOrder = 0
  end
  object Edit1: TEdit [6]
    Left = 148
    Top = 100
    Width = 120
    Height = 21
    Hint = #36664#20837#21046#20196#21934#34399#23559#24573#30053#29983#29986#26085#26399
    TabOrder = 2
  end
  object dtp2: TDateTimePicker [7]
    Left = 148
    Top = 65
    Width = 120
    Height = 21
    Date = 43102.000000000000000000
    Time = 43102.000000000000000000
    TabOrder = 1
  end
end
