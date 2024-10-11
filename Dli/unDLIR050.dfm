inherited FrmDLIR050: TFrmDLIR050
  Left = 508
  Top = 270
  Caption = 'FrmDLIR050'
  ClientHeight = 540
  ClientWidth = 1021
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1021
    ButtonWidth = 85
    object btn_dlir050A: TToolButton
      Left = 364
      Top = 0
      Caption = #26356#26032#37325#37327#38754#31309
      ImageIndex = 58
      OnClick = btn_dlir050AClick
    end
    object btn_dlir050B: TToolButton
      Left = 449
      Top = 0
      AutoSize = True
      Caption = #26356#26032#23458#25142'PO'
      ImageIndex = 58
      OnClick = btn_dlir050BClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 510
    Width = 1021
    Enabled = True
    inherited Edit1: TEdit
      Enabled = False
    end
    inherited Edit2: TEdit
      Enabled = False
    end
    object CheckBox1: TCheckBox
      Left = 300
      Top = 8
      Width = 97
      Height = 17
      Caption = 'CheckBox1'
      TabOrder = 2
      OnClick = CheckBox1Click
    end
  end
  inherited Panel1: TPanel
    Width = 1021
  end
  inherited DBGridEh1: TDBGridEh
    Width = 1021
    Height = 466
    OnCellClick = DBGridEh1CellClick
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
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
        FieldName = 'indate'
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
        FieldName = 'pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'manfac'
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
        FieldName = 'units'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'coc_no'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'jt'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qx'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bm'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'prddate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'enddate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custorderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'longitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'latitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custprono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sendAddr'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
      end
      item
        DisplayFormat = 'YYYY/M/D HH:NN:SS'
        DynProps = <>
        EditButtons = <>
        FieldName = 'zc_idate'
        Footers = <>
      end
      item
        DisplayFormat = 'YYYY/M/D HH:NN:SS'
        DynProps = <>
        EditButtons = <>
        FieldName = 'zc_mdate'
        Footers = <>
      end
      item
        DisplayFormat = 'YYYY/M/D HH:NN:SS'
        DynProps = <>
        EditButtons = <>
        FieldName = 'coc_idate'
        Footers = <>
      end
      item
        DisplayFormat = 'YYYY/M/D HH:NN:SS'
        DynProps = <>
        EditButtons = <>
        FieldName = 'coc_mdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rc'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rf'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pg'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'resin'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'copper'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pp'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kg'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tkg'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sf'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tsf'
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
        FieldName = 'carno'
        Footers = <>
      end>
  end
end
