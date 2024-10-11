inherited FrmAdSelect: TFrmAdSelect
  Width = 680
  Height = 450
  Caption = #33184#31995#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 554
    Top = 25
    Height = 387
    TabOrder = 1
  end
  object Lv: TListView [1]
    Left = 0
    Top = 25
    Width = 554
    Height = 387
    Hint = #23458#25142
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Checkboxes = True
    Columns = <>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object TPanel [2]
    Left = 0
    Top = 0
    Width = 664
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object chkAll: TCheckBox
      Left = 10
      Top = 4
      Width = 97
      Height = 17
      Caption = #20840#36984
      TabOrder = 0
      OnClick = chkAllClick
    end
  end
end
