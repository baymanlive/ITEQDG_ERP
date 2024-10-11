inherited FrmMPSI610: TFrmMPSI610
  Caption = 'FrmMPSI610'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        DynProps = <>
        DropDownRows = 14
        EditButtons = <>
        FieldName = 'AD'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'R'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'G'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'B'
        Footers = <>
        ReadOnly = True
        Width = 70
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end>
  end
  object ColorDialog1: TColorDialog
    Left = 544
    Top = 156
  end
end
