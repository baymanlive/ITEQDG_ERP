inherited FrmDLIR080: TFrmDLIR080
  Caption = 'FrmDLIR080'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    object Label3: TLabel [4]
      Left = 267
      Top = 8
      Width = 26
      Height = 13
      Caption = #31558#25976
    end
  end
  inherited DBGridEh1: TDBGridEh
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyPress = DBGridEh1KeyPress
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'saledate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'saleno'
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
        FieldName = 'custshort'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'carno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'driver'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'company'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'out'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'outuser'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'outtime'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'back'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'backuser'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'backtime'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'conf'
        Footers = <>
      end>
  end
end
