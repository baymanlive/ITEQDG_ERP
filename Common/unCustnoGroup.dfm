inherited FrmCustnoGroup: TFrmCustnoGroup
  Width = 574
  Height = 400
  Caption = #23458#25142#32676#32068
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 448
    Height = 362
    TabOrder = 1
  end
  object Lv: TListView [1]
    Left = 0
    Top = 0
    Width = 448
    Height = 362
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = #32676#32068#32232#34399
        Width = 80
      end
      item
        Caption = #23458#25142#32232#34399
        Width = 300
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
