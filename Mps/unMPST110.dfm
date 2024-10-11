inherited FrmMPST110: TFrmMPST110
  Left = 433
  Top = 276
  Caption = 'FrmMPST110'
  ClientHeight = 457
  ClientWidth = 768
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 768
    ButtonWidth = 72
    object btn_mpst110: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = #29986#29983#24037#21934
      ImageIndex = 50
      OnClick = btn_mpst110Click
    end
    object btn_mpst110_export: TToolButton
      Left = 427
      Top = 0
      Caption = #23566#20986#37325#24037#21934
      ImageIndex = 41
      OnClick = btn_mpst110_exportClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 427
    Width = 768
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
    Width = 768
  end
  inherited DBGridEh1: TDBGridEh
    Width = 768
    Height = 383
    OnCellClick = DBGridEh1CellClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyDown = DBGridEh1KeyDown
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
        FieldName = 'w_pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'w_qty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark5'
        Footers = <>
      end
      item
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
        DynProps = <>
        EditButtons = <>
        FieldName = 'Adate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Odate'
        Footers = <>
      end
      item
        DisplayFormat = 'HH:NN'
        DynProps = <>
        EditButtons = <>
        FieldName = 'Stime'
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
        FieldName = 'Longitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Latitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Notcount1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Delcount1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Coccount1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Chkcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remain_ordqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark6'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SaleRemark'
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
        FieldName = 'Units'
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
        FieldName = 'Custname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end>
  end
  inherited CDS: TClientDataSet
    AfterPost = CDSAfterPost
  end
end
