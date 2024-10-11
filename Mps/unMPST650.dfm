inherited FrmMPST650: TFrmMPST650
  Left = 360
  Top = 185
  Caption = 'FrmMPST650'
  ClientHeight = 716
  ClientWidth = 1379
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1379
  end
  inherited PnlBottom: TPanel
    Top = 686
    Width = 1379
    object LblTot: TLabel [4]
      Left = 352
      Top = 4
      Width = 54
      Height = 21
      Caption = 'LblTot'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -21
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
    end
  end
  inherited Panel1: TPanel
    Width = 1379
  end
  inherited DBGridEh1: TDBGridEh
    Left = 120
    Width = 1149
    Height = 642
    PopupMenu = PopupMenu1
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnKeyDown = DBGridEh1KeyDown
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'cdate'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'cno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'sno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'purcno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'pursno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'suppno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'supplier'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'pname'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'units'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'oldpurqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'purqty'
        Footers = <>
      end
      item
        Color = clInfoBk
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
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date1'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date2'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date3'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date4'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date5'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date6'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'date7'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate'
        Footers = <>
      end
      item
        DisplayFormat = 'M/D'
        DynProps = <>
        EditButtons = <>
        FieldName = 'adate_new'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SupplyOrderNo'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SupplyOrderItem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SupplyPno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark0'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark3'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'inqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
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
        FieldName = 'stkqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'mpsqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'purremark'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderdate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oradb'
        Footers = <>
        PickList.Strings = (
          'ITEQDG'
          'ITEQGZ')
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
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'ordernotqty'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'custdate'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_orderno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_pno'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'c_sizes'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'ordremark'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'sendaddr'
        Footers = <>
        ReadOnly = True
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
        FieldName = 'isfinish'
        Footers = <>
      end>
  end
  object PnlRight: TPanel [4]
    Left = 1269
    Top = 44
    Width = 110
    Height = 642
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst650A: TBitBtn
      Tag = 2
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Caption = #35531#36092#21934#36984#25799
      TabOrder = 0
      OnClick = btn_mpst650AClick
      NumGlyphs = 2
    end
    object btn_mpst650D: TBitBtn
      Tag = 2
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #26356#26032#25505#36092#21934#34399
      TabOrder = 1
      OnClick = btn_mpst650DClick
      NumGlyphs = 2
    end
    object btn_mpst650E: TBitBtn
      Tag = 2
      Left = 5
      Top = 68
      Width = 100
      Height = 25
      Caption = #26356#26032#26410#20132#25976#37327
      TabOrder = 2
      OnClick = btn_mpst650EClick
      NumGlyphs = 2
    end
    object btn_mpst650F: TBitBtn
      Tag = 2
      Left = 5
      Top = 98
      Width = 100
      Height = 25
      Caption = #26356#26032#24235#23384#37327
      TabOrder = 3
      OnClick = btn_mpst650FClick
      NumGlyphs = 2
    end
    object btn_mpst650G: TBitBtn
      Tag = 2
      Left = 5
      Top = 128
      Width = 100
      Height = 25
      Caption = #26356#26032#24288#20839#25490#21046#37327
      TabOrder = 4
      OnClick = btn_mpst650GClick
      NumGlyphs = 2
    end
    object btn_mpst650I: TBitBtn
      Tag = 2
      Left = 5
      Top = 158
      Width = 100
      Height = 25
      Caption = #26356#26032#20837#24235#25976#37327
      TabOrder = 5
      OnClick = btn_mpst650IClick
      NumGlyphs = 2
    end
    object btn_mpst650H: TBitBtn
      Tag = 2
      Left = 5
      Top = 188
      Width = 100
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 6
      OnClick = btn_mpst650HClick
      NumGlyphs = 2
    end
    object btn_mpst650J: TBitBtn
      Tag = 2
      Left = 5
      Top = 218
      Width = 100
      Height = 25
      Caption = #32160#33394
      TabOrder = 7
      OnClick = btn_mpst650JClick
      NumGlyphs = 2
    end
    object btn_mpst650K: TBitBtn
      Tag = 2
      Left = 5
      Top = 248
      Width = 100
      Height = 25
      Caption = #40643#33394
      TabOrder = 8
      OnClick = btn_mpst650KClick
      NumGlyphs = 2
    end
    object btn_mpst650L: TBitBtn
      Tag = 2
      Left = 5
      Top = 278
      Width = 100
      Height = 25
      Caption = #32043#32005#33394
      TabOrder = 9
      OnClick = btn_mpst650LClick
      NumGlyphs = 2
    end
    object btn_mpst650M: TBitBtn
      Tag = 2
      Left = 5
      Top = 308
      Width = 100
      Height = 25
      Caption = #38738#33394
      TabOrder = 10
      OnClick = btn_mpst650MClick
      NumGlyphs = 2
    end
    object btn_mpst650N: TBitBtn
      Tag = 2
      Left = 5
      Top = 338
      Width = 100
      Height = 25
      Caption = #27225#33394
      TabOrder = 11
      OnClick = btn_mpst650NClick
      NumGlyphs = 2
    end
    object btn_mpst650O: TBitBtn
      Tag = 2
      Left = 5
      Top = 368
      Width = 100
      Height = 25
      Caption = #25976#37327#32113#35336#34920
      TabOrder = 12
      OnClick = btn_mpst650OClick
      NumGlyphs = 2
    end
    object btn_mpst650P: TBitBtn
      Tag = 2
      Left = 5
      Top = 398
      Width = 100
      Height = 25
      Caption = #24478'excel'#26356#26032#20132#26399
      TabOrder = 13
      OnClick = btn_mpst650PClick
      NumGlyphs = 2
    end
    object btn_mpst650Q: TBitBtn
      Tag = 2
      Left = 5
      Top = 428
      Width = 100
      Height = 25
      Caption = #26356#26032#20379#25033#21830#21934#34399
      TabOrder = 14
      Visible = False
      OnClick = btn_mpst650QClick
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel [5]
    Left = 0
    Top = 44
    Width = 120
    Height = 642
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 5
    object rgp: TRadioGroup
      Left = 6
      Top = 0
      Width = 110
      Height = 430
      ItemIndex = 0
      Items.Strings = (
        #28961#37675'PP'
        #28961#37675'CCL'
        #33274#28771'PP'
        #33274#28771'CCL'
        #27743#35199'PP'
        #27743#35199'CCL'
        #28961#37675#29305#27530#33184#31995
        #33274#28771#29305#27530#33184#31995
        #27743#35199#29305#27530#33184#31995
        #33258#29992'PP')
      TabOrder = 0
      OnClick = rgpClick
    end
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
  object PopupMenu1: TPopupMenu
    Left = 560
    Top = 328
    object N1: TMenuItem
      Caption = #26356#26032#25505#36092#21934#34399
      OnClick = N1Click
    end
  end
end
