inherited FrmMPST060: TFrmMPST060
  Caption = 'FrmMPST060'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    Width = 853
    ReadOnly = False
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyPress = DBGridEh1KeyPress
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'pdaconf'
        Footers = <>
        ReadOnly = True
      end
      item
        DisplayFormat = 'YYYY-MM-DD HH:NN:SS'
        DynProps = <>
        EditButtons = <>
        FieldName = 'pdatime'
        Footers = <>
        ReadOnly = True
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'bg'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bgqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qcqty'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'qcconf'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sdate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'currentboiler'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono'
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
        FieldName = 'materialno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate_new'
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
        FieldName = 'stealno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'premark'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno2'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem2'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'materialno1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pnlsize1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pnlsize2'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'aqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cqty'
        Footers = <>
        ReadOnly = True
      end>
  end
  object PnlRight: TPanel [4]
    Left = 853
    Top = 44
    Width = 110
    Height = 451
    Hint = '  '
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst060: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Hint = #21462#27171#35336#31639
      Caption = #21462#27171#35336#31639
      TabOrder = 0
      OnClick = btn_mpst060Click
      NumGlyphs = 2
    end
    object RGP: TRadioGroup
      Left = 10
      Top = 55
      Width = 90
      Height = 150
      Caption = #27231#21488
      ItemIndex = 0
      Items.Strings = (
        'L1'
        'L2'
        'L3'
        'L4'
        'L5')
      TabOrder = 1
      OnClick = RGPClick
    end
    object Chk: TCheckBox
      Left = 10
      Top = 227
      Width = 97
      Height = 17
      Caption = #21482#39023#31034#21462#27171
      TabOrder = 2
      OnClick = ChkClick
    end
  end
  inherited CDS: TClientDataSet
    BeforeInsert = CDSBeforeInsert
    BeforeEdit = CDSBeforeEdit
    AfterPost = CDSAfterPost
  end
end
