inherited FrmMPSI260: TFrmMPSI260
  Caption = 'FrmMPSI260'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 70
    object btn_mpsi260: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_mpsi260'
      ImageIndex = 54
      OnClick = btn_mpsi260Click
    end
  end
  inherited DBGridEh1: TDBGridEh
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'CustNo'
        Footers = <>
        Width = 111
      end
      item
        DynProps = <>
        DropDownRows = 14
        EditButtons = <>
        FieldName = 'Adhesive'
        Footers = <>
        Width = 89
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Fiber'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Code3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'LastCode3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'TailNo'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Vendor'
        Footers = <>
        Width = 111
      end>
  end
end
