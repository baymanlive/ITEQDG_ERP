inherited FrmMPSR110: TFrmMPSR110
  Caption = 'FrmMPSR110'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    FooterRowCount = 1
    SumList.Active = True
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'GroupId'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'AD'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Maxqty'
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Tot'
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Diff'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
  end
end
