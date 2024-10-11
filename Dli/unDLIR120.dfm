inherited FrmDLIR120: TFrmDLIR120
  Left = 499
  Top = 151
  Caption = 'FrmDLIR120'
  ClientHeight = 765
  ClientWidth = 950
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 950
  end
  inherited PnlBottom: TPanel
    Top = 735
    Width = 950
  end
  inherited Panel1: TPanel
    Width = 950
  end
  inherited DBGridEh1: TDBGridEh
    Width = 840
    Height = 691
    PopupMenu = PopupMenu1
    OnCellClick = DBGridEh1CellClick
    OnDblClick = DBGridEh1DblClick
    OnDrawColumnCell = DBGridEh1DrawColumnCell
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
        FieldName = 'cname'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kw'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kb'
        Footers = <>
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
        FieldName = 'saledate'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'saleno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'saleitem'
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
        FieldName = 'thickness'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'totthickness'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sf'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'totsf'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'totsf1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'gsf'
        Footers = <>
        ReadOnly = True
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
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'price'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'amt'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cashtype'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kg'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'nw'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'totnw'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'gw'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tare'
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
        FieldName = 'zcremark'
        Footers = <>
      end>
  end
  object PnlRight: TPanel [4]
    Left = 840
    Top = 44
    Width = 110
    Height = 691
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_dlir120A: TBitBtn
      Tag = 2
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = #20986#36008#36039#26009
      TabOrder = 2
      OnClick = btn_dlir120AClick
      NumGlyphs = 2
    end
    object btn_dlir120B: TBitBtn
      Tag = 2
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Caption = #36554#27425#30867#35469
      TabOrder = 0
      OnClick = btn_dlir120BClick
      NumGlyphs = 2
    end
    object btn_dlir120C: TBitBtn
      Tag = 3
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Caption = #24050#30906#35469#36039#26009
      TabOrder = 1
      OnClick = btn_dlir120CClick
      NumGlyphs = 2
    end
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu1Popup
    Left = 720
    Top = 349
    object N_del3: TMenuItem
      Caption = #26410#36984#21034#38500
      Hint = #21034#38500#26410#36984#20013#30340#36039#26009','#37325#26032#26597#35426#26371#20877#39023#31034#36039#26009
      OnClick = N_del3Click
    end
    object N_clr: TMenuItem
      Caption = #21462#28040#36984#20013
      Hint = #21462#28040#36984#20013#30340#27161#35352
      OnClick = N_clrClick
    end
    object N_xxxx: TMenuItem
      Caption = '-'
    end
    object N_edit1: TMenuItem
      Caption = #35079#35069#27611#37325
      Hint = #26356#25913#30456#21516#21345#20301#30340#27611#37325#28858#30070#21069#20540
      OnClick = N_edit1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N_del1: TMenuItem
      Caption = #33256#26178#21034#38500
      Hint = #36039#26009#20445#30041','#37325#26032#26597#35426#26371#20877#39023#31034#36039#26009
      OnClick = N_del1Click
    end
    object N_del2: TMenuItem
      Caption = #24505#24213#21034#38500
      Hint = #36039#26009#19981#20445#30041','#21487#36890#36942'['#20986#36008#36039#26009']'#25353#25197#37325#26032#25235#21462#36039#26009#20986#20358
      OnClick = N_del2Click
    end
  end
end
