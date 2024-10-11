inherited FrmDLII060: TFrmDLII060
  Caption = 'FrmDLII060'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 61
    object btn_dlii060: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_dlii060'
      ImageIndex = 8
      OnClick = btn_dlii060Click
    end
    object btn_import: TToolButton
      Left = 659
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
        FieldName = 'Strip_lower'
        Footers = <>
        PickList.Strings = (
          'A'
          'B')
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Strip_upper'
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
        FieldName = 'Copper'
        Footers = <>
        PickList.Strings = (
          '@'
          '#'
          '&')
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'StdValue'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fValue'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'materi_tail'
        Footers = <>
      end>
  end
end
