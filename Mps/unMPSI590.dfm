inherited FrmMPSI590: TFrmMPSI590
  Caption = 'FrmMPSI590'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi590: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi590'
      ImageIndex = 58
      OnClick = btn_mpsi590Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Fi'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sno'
        Footers = <>
        Width = 80
      end>
  end
end
