inherited FrmMPSR090: TFrmMPSR090
  Left = 358
  Top = 222
  Caption = 'FrmMPSR090'
  ClientHeight = 516
  ClientWidth = 955
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 955
  end
  inherited PnlBottom: TPanel
    Top = 486
    Width = 955
  end
  inherited Panel1: TPanel
    Width = 955
  end
  inherited DBGridEh1: TDBGridEh
    Width = 845
    Height = 442
    ReadOnly = False
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orddate'
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
        FieldName = 'ordpno'
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
        FieldName = 'unit'
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
        FieldName = 'custorderno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custprono'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custname'
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
        FieldName = 'sendaddr'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ordqty'
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
        FieldName = 'oldadate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cdate'
        Footers = <>
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
        FieldName = 'remark1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark2'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'flag'
        Footers = <>
        ReadOnly = True
      end>
  end
  object PnlRight: TPanel [4]
    Left = 845
    Top = 44
    Width = 110
    Height = 442
    Hint = '  '
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpsr090A: TBitBtn
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 0
      OnClick = btn_mpsr090AClick
      NumGlyphs = 2
    end
    object btn_mpsr090B: TBitBtn
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #25286#20998#25976#37327
      TabOrder = 1
      OnClick = btn_mpsr090BClick
      NumGlyphs = 2
    end
    object btn_mpsr090C: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Caption = #19968#37749'Call'#36008
      TabOrder = 2
      OnClick = btn_mpsr090CClick
      NumGlyphs = 2
    end
  end
  inherited CDS: TClientDataSet
    BeforeInsert = CDSBeforeInsert
    BeforeEdit = CDSBeforeEdit
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
  end
end
