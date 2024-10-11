inherited FrmDLII032: TFrmDLII032
  Caption = 'FrmDLII032'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 60
    object btn_import: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
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
        FieldName = 'custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Adhesive'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'thick'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'inccu'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'exccu'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Copper'
        Footers = <>
      end>
  end
end
