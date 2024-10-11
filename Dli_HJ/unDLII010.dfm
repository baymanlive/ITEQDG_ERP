inherited FrmDLII010: TFrmDLII010
  Caption = 'FrmDLII010'
  ClientWidth = 962
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 962
    object btn_dlii010A: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'Excel'#21295#20837
      ImageIndex = 53
      OnClick = btn_dlii010AClick
    end
    object btn_dlii010B: TToolButton
      Left = 657
      Top = 0
      AutoSize = True
      Caption = #26356#26032
      ImageIndex = 58
      OnClick = btn_dlii010BClick
    end
  end
  inherited PnlBottom: TPanel
    Width = 962
  end
  inherited Panel1: TPanel
    Width = 962
  end
  inherited DBGridEh1: TDBGridEh
    Width = 962
    OnGetCellParams = DBGridEh1GetCellParams
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        ButtonStyle = cbsNone
        DynProps = <>
        EditButtons = <>
        FieldName = 'Indate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sno'
        Footers = <>
      end
      item
        ButtonStyle = cbsNone
        DynProps = <>
        EditButtons = <>
        FieldName = 'Odate'
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
        FieldName = 'Custshort'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custorderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custprono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Orderitem'
        Footers = <>
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
        FieldName = 'Sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Ordercount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Outcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'RemainCount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Notcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Delcount'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Coccount'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Units'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'StkRemark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end>
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'xls'
    Filter = 'Excel(*.xls;*.xlsx)|*.xls;*.xlsx'
    Left = 568
    Top = 189
  end
end
