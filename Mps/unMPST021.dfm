inherited FrmMPST021: TFrmMPST021
  Left = 337
  Top = 139
  Caption = 'FrmMPST021'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 85
    object btn_mpst020A: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = #22238#23531#20841#35282#35330#21934
      ImageIndex = 58
      OnClick = btn_mpst020AClick
    end
    object btn_mpst020B: TToolButton
      Left = 453
      Top = 0
      AutoSize = True
      Caption = #29986#29983#24037#21934
      ImageIndex = 50
      OnClick = btn_mpst020BClick
    end
  end
  inherited DBGridEh1: TDBGridEh
    OnCellClick = DBGridEh1CellClick
    OnDrawColumnCell = DBGridEh1DrawColumnCell
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'machine'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'materialno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'breadth'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fiber'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate_new'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'premark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'edate'
        Footers = <>
      end>
  end
end
