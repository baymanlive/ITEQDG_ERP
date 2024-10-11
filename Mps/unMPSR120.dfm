inherited FrmMPSR120: TFrmMPSR120
  Left = 403
  Top = 218
  Caption = 'FrmMPSR120'
  ClientHeight = 584
  ClientWidth = 1051
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1051
  end
  inherited PnlBottom: TPanel
    Top = 554
    Width = 1051
  end
  inherited Panel1: TPanel
    Width = 1051
  end
  inherited DBGridEh1: TDBGridEh
    Width = 941
    Height = 510
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyDown = DBGridEh1KeyDown
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
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
        FieldName = 'ta_oea08'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb30'
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
        FieldName = 'c_orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb11'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_sizes'
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
        FieldName = 'struct'
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
        FieldName = 'orderqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ddate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ok'
        Footers = <>
      end>
  end
  object PnlRight: TPanel [4]
    Left = 941
    Top = 44
    Width = 110
    Height = 510
    Hint = '  '
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpsr120A: TBitBtn
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Caption = #26356#26032#24235#23384#37327
      TabOrder = 0
      OnClick = btn_mpsr120AClick
      NumGlyphs = 2
    end
    object btn_mpsr120B: TBitBtn
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #26356#26032#26410#20132#25976#37327
      TabOrder = 1
      OnClick = btn_mpsr120BClick
      NumGlyphs = 2
    end
    object btn_mpsr120C: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 2
      OnClick = btn_mpsr120CClick
      NumGlyphs = 2
    end
  end
end
