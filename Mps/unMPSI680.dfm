inherited FrmMPSI680: TFrmMPSI680
  Left = 339
  Top = 257
  Caption = 'FrmMPSI680'
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
        FieldName = 'Stype'
        Footers = <>
        PickList.Strings = (
          'BS'
          'DGPQ'
          'GZPQ')
      end
      item
        DynProps = <>
        DropDownRows = 14
        EditButtons = <>
        FieldName = 'Mtype'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'BW'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'TW'
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
        FieldName = 'RF_diff'
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
        FieldName = 'PG1_diff'
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
        FieldName = 'A1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'A2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'C'
        Footers = <>
      end>
  end
end
