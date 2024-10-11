inherited FrmSysI020_Actions: TFrmSysI020_Actions
  Width = 652
  Height = 317
  Caption = 'FrmSysI020_Actions'
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 68
    Top = 24
    Width = 400
    Height = 180
    Shape = bsFrame
  end
  inherited PnlRight: TPanel
    Left = 526
    Height = 279
    TabOrder = 15
  end
  object Ainsert: TCheckBox [2]
    Left = 103
    Top = 53
    Width = 97
    Height = 17
    Caption = #26032#22686
    TabOrder = 0
  end
  object Aedit: TCheckBox [3]
    Left = 103
    Top = 78
    Width = 97
    Height = 17
    Caption = #26356#25913
    TabOrder = 1
  end
  object Adelete: TCheckBox [4]
    Left = 103
    Top = 103
    Width = 97
    Height = 17
    Caption = #21034#38500
    TabOrder = 2
  end
  object Acopy: TCheckBox [5]
    Left = 103
    Top = 128
    Width = 97
    Height = 17
    Caption = #35079#35069
    TabOrder = 3
  end
  object Agarbage: TCheckBox [6]
    Left = 103
    Top = 153
    Width = 97
    Height = 17
    Caption = #28961#25928
    TabOrder = 4
  end
  object Afirst: TCheckBox [7]
    Left = 328
    Top = 53
    Width = 97
    Height = 17
    Caption = #31532#19968#31558
    TabOrder = 9
  end
  object Aprior: TCheckBox [8]
    Left = 328
    Top = 78
    Width = 97
    Height = 17
    Caption = #19978#31558
    TabOrder = 10
  end
  object Ajump: TCheckBox [9]
    Left = 328
    Top = 103
    Width = 97
    Height = 17
    Caption = #25351#23450#31558
    TabOrder = 11
  end
  object Anext: TCheckBox [10]
    Left = 328
    Top = 129
    Width = 97
    Height = 17
    Caption = #19979#31558
    TabOrder = 12
  end
  object Alast: TCheckBox [11]
    Left = 328
    Top = 153
    Width = 97
    Height = 17
    Caption = #26411#19968#31558
    TabOrder = 13
  end
  object Aprop: TCheckBox [12]
    Left = 213
    Top = 53
    Width = 97
    Height = 17
    Caption = #21934#36523
    TabOrder = 5
  end
  object Aquery: TCheckBox [13]
    Left = 213
    Top = 128
    Width = 97
    Height = 17
    Caption = #26597#35426
    TabOrder = 8
  end
  object Aprint: TCheckBox [14]
    Left = 213
    Top = 78
    Width = 97
    Height = 17
    Caption = #21015#21360
    TabOrder = 6
  end
  object Aexport: TCheckBox [15]
    Left = 213
    Top = 103
    Width = 97
    Height = 17
    Caption = #21295#20986'Excel'
    TabOrder = 7
  end
  object checkAll: TCheckBox [16]
    Tag = 1
    Left = 104
    Top = 228
    Width = 97
    Height = 17
    Caption = #20840#36984
    TabOrder = 14
    OnClick = checkAllClick
  end
end
