inherited FrmEmptyFlagAdd: TFrmEmptyFlagAdd
  Width = 480
  Height = 350
  ActiveControl = Edit1
  Caption = #22686#21152#31354#34892
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 94
    Top = 133
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 94
    Top = 213
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label3: TLabel [2]
    Left = 28
    Top = 255
    Width = 300
    Height = 13
    Caption = #33509#31354#37707#24773#27841#19979','#35531#36984#20013'['#28165#38500#21512#37707#20195#30908'],'#26412#25976#21487#19981#29992#36664#20837
  end
  inherited PnlRight: TPanel
    Left = 362
    Height = 323
    TabOrder = 6
  end
  object Edit1: TEdit [4]
    Left = 130
    Top = 130
    Width = 125
    Height = 21
    TabOrder = 1
  end
  object Memo1: TMemo [5]
    Left = 110
    Top = 30
    Width = 185
    Height = 89
    BorderStyle = bsNone
    Enabled = False
    Lines.Strings = (
      #27231#21488#65306
      #26085#26399#65306
      #37707#27425#65306
      #37628#26495#65306
      #21512#37707#65306)
    TabOrder = 0
  end
  object Chk: TCheckBox [6]
    Left = 130
    Top = 160
    Width = 97
    Height = 17
    Caption = 'Chk'
    TabOrder = 2
  end
  object Chk2: TCheckBox [7]
    Left = 130
    Top = 185
    Width = 97
    Height = 17
    Caption = 'Chk'
    TabOrder = 3
  end
  object Edit2: TEdit [8]
    Left = 130
    Top = 210
    Width = 125
    Height = 21
    TabOrder = 4
  end
  object BitBtn1: TBitBtn [9]
    Left = 255
    Top = 208
    Width = 40
    Height = 25
    Hint = #36984#25799#23458#25142#32676#32068
    Caption = #36984#25799
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  inherited ImageList1: TImageList
    Left = 145
    Top = 285
  end
end
