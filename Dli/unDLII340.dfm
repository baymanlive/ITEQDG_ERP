inherited FrmDLII340: TFrmDLII340
  Caption = 'FrmDLII340'
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
        FieldName = 'Custno'
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
        FieldName = 'LastCode'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Stkname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'RC'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'RC_diff'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'RF'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'PG1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'PG2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'VC'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
        Width = 148
      end>
  end
end
