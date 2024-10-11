inherited FrmMPSI500: TFrmMPSI500
  Caption = 'FrmMPSI500'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi500: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi500'
      ImageIndex = 57
      OnClick = btn_mpsi500Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'machine'
        Footers = <>
        Title.Caption = #27231#21488#20195#30908
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wdate'
        Footers = <>
        Title.Caption = #24037#20316#26085#26399
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'capacity'
        Footers = <>
        Title.Caption = #29986#33021'('#20998#37912')'
        Width = 100
      end>
  end
end
