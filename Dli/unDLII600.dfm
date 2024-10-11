inherited FrmDLII600: TFrmDLII600
  Caption = 'FrmDLII600'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 60
    object btn_import: TToolButton
      Left = 594
      Top = 0
      Caption = 'btn_import'
      ImageIndex = 53
      OnClick = btn_importClick
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'CustNo'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'C_pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pno'
        Footers = <>
      end>
  end
end
