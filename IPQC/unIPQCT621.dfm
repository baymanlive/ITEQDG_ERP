inherited FrmIPQCT621: TFrmIPQCT621
  Caption = 'FrmIPQCT621'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_edit: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = 'btn_edit'
      ImageIndex = 5
      OnClick = btn_editClick
    end
  end
  inherited DBGridEh1: TDBGridEh
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ver'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'niandu'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ludaiqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spos'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spos_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'temperature'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remainlot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'addqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'addsg'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't1_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't2_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't3_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't4_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'opt_uid'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'opt_uname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'conf_uid'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'conf_uname'
        Footers = <>
      end>
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
    AfterEdit = CDSAfterEdit
  end
end
