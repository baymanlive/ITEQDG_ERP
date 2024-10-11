inherited FrmMPST130: TFrmMPST130
  Left = 429
  Top = 255
  Caption = 'FrmMPST130'
  ClientHeight = 566
  ClientWidth = 950
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 950
    object btn_mpst130: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = #29986#29983#24037#21934
      ImageIndex = 50
      OnClick = btn_mpst130Click
    end
  end
  inherited PnlBottom: TPanel
    Top = 536
    Width = 950
    Enabled = True
    inherited Edit1: TEdit
      Enabled = False
    end
    inherited Edit2: TEdit
      Enabled = False
    end
    object chkAll: TCheckBox
      Left = 328
      Top = 4
      Width = 97
      Height = 17
      Caption = 'chkAll'
      TabOrder = 2
      OnClick = chkAllClick
    end
  end
  inherited Panel1: TPanel
    Width = 950
  end
  inherited DBGridEh1: TDBGridEh
    Width = 950
    Height = 492
    ReadOnly = False
    OnCellClick = DBGridEh1CellClick
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custshort'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderdate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pname'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb11'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'longitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'latitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb04'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb07'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'units'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'outqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'notqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'l_pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'l_qty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'w_wono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'w_qty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'num'
        Footers = <>
        ReadOnly = True
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'iscreate'
        Footers = <>
        ReadOnly = True
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'iscomplete'
        Footers = <>
        ReadOnly = True
      end>
  end
  inherited CDS: TClientDataSet
    BeforeInsert = CDSBeforeInsert
    AfterPost = CDSAfterPost
    BeforeDelete = CDSBeforeDelete
  end
end
