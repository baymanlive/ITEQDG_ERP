inherited FrmMPST012: TFrmMPST012
  Left = 240
  Top = 54
  Caption = 'FrmMPST012'
  ClientHeight = 678
  ClientWidth = 1141
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1141
  end
  inherited PnlBottom: TPanel
    Top = 648
    Width = 1141
    object Label3: TLabel [4]
      Left = 255
      Top = 6
      Width = 107
      Height = 16
      Caption = #29983#29986#26085#26399'/'#25976#37327
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit3: TEdit
      Left = 365
      Top = 3
      Width = 90
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ImeName = #23567#29436#27627
      ParentColor = True
      ParentFont = False
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 458
      Top = 3
      Width = 60
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ImeName = #23567#29436#27627
      ParentColor = True
      ParentFont = False
      TabOrder = 3
      Text = '0'
    end
  end
  inherited Panel1: TPanel
    Width = 1141
  end
  inherited PCL: TPageControl
    Width = 1031
    Height = 604
    ActivePage = TabSheet2
    OnChange = PCLChange
    inherited TabSheet1: TTabSheet
      Caption = #24050#30906#35469#25490#31243
      inherited DBGridEh1: TDBGridEh
        Left = 62
        Width = 961
        Height = 576
        PopupMenu = PopupMenu1
        ReadOnly = True
        OnCellClick = DBGridEh1CellClick
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        OnGetCellParams = DBGridEh1GetCellParams
        OnKeyDown = DBGridEh1KeyDown
        OnTitleBtnClick = DBGridEh1TitleBtnClick
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
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderdate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            Title.TitleButton = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'regulateQty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oqcQty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custom'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custom2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark3'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
            Width = 40
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
            FieldName = 'custno2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custname2'
            Footers = <>
          end>
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 62
        Height = 576
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG1: TRadioGroup
          Left = 0
          Top = 0
          Width = 60
          Height = 500
          TabOrder = 0
          OnClick = RG1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38928#25490#32080#26524
      ImageIndex = 2
      object DBGridEh2: TDBGridEh
        Left = 62
        Top = 0
        Width = 961
        Height = 576
        Hint = #38928#25490#32080#26524
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        ImeName = #23567#29436#27627
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnCellClick = DBGridEh2CellClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderdate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
            Width = 40
            OnUpdateData = DBGridEh2Columns6UpdateData
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark3'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'regulateQty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 62
        Height = 576
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG2: TRadioGroup
          Left = 0
          Top = 0
          Width = 60
          Height = 500
          TabOrder = 0
          OnClick = RG2Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #24453#25490#35330#21934
      ImageIndex = 1
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 954
        Height = 509
        Hint = #24453#25490#35330#21934','#21487#20351#29992#21491#37749'['#21034#38500']'#25110'['#35079#35069'],'#38617#25802#21487#35722#25563'['#21934#36984']'#25110'['#35079#36984']'
        Align = alClient
        DataSource = DS3
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        ImeName = #23567#29436#27627
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        PopupMenu = PopupMenu2
        TabOrder = 0
        OnDblClick = DBGridEh3DblClick
        OnTitleClick = DBGridEh3TitleClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderdate'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            Width = 40
            OnUpdateData = DBGridEh3Columns4UpdateData
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stype'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark3'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno1'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize1'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'oz'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'regulateQty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'uuid'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderBu'
            Footers = <>
            Visible = False
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 1031
    Top = 44
    Width = 110
    Height = 604
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst012A: TBitBtn
      Tag = 2
      Left = 8
      Top = 10
      Width = 95
      Height = 25
      Caption = #26410#25490#35330#21934
      TabOrder = 0
      OnClick = btn_mpst012AClick
      NumGlyphs = 2
    end
    object btn_mpst012C: TBitBtn
      Tag = 2
      Left = 8
      Top = 40
      Width = 95
      Height = 25
      Caption = #22519#34892#25490#31243
      TabOrder = 1
      OnClick = btn_mpst012CClick
      NumGlyphs = 2
    end
    object btn_mpst012D: TBitBtn
      Tag = 2
      Left = 8
      Top = 70
      Width = 95
      Height = 25
      Caption = #25490#31243#30906#35469
      TabOrder = 2
      OnClick = btn_mpst012DClick
      NumGlyphs = 2
    end
    object btn_mpst012E: TBitBtn
      Tag = 2
      Left = 8
      Top = 100
      Width = 95
      Height = 25
      Caption = #35519#25972#20301#32622
      TabOrder = 3
      OnClick = btn_mpst012EClick
      NumGlyphs = 2
    end
    object btn_mpst012F: TBitBtn
      Tag = 2
      Left = 8
      Top = 130
      Width = 95
      Height = 25
      Caption = #22686#21152#31354#34892
      TabOrder = 4
      OnClick = btn_mpst012FClick
      NumGlyphs = 2
    end
    object btn_mpst012L: TBitBtn
      Tag = 2
      Left = 8
      Top = 160
      Width = 95
      Height = 25
      Caption = #26356#26032#31354#34892#29986#33021
      TabOrder = 5
      OnClick = btn_mpst012LClick
      NumGlyphs = 2
    end
    object btn_mpst012H: TBitBtn
      Tag = 3
      Left = 8
      Top = 190
      Width = 95
      Height = 25
      Caption = #23458#25142#32676#29986#33021#26126#32048
      TabOrder = 6
      OnClick = btn_mpst012HClick
      NumGlyphs = 2
    end
    object btn_mpst012I: TBitBtn
      Tag = 3
      Left = 8
      Top = 220
      Width = 95
      Height = 25
      Caption = #29986#33021#26126#32048
      TabOrder = 7
      OnClick = btn_mpst012IClick
      NumGlyphs = 2
    end
    object btn_mpst012J: TBitBtn
      Tag = 2
      Left = 8
      Top = 250
      Width = 95
      Height = 25
      Caption = #29986#33021#28165#38646
      TabOrder = 8
      OnClick = btn_mpst012JClick
      NumGlyphs = 2
    end
    object btn_mpst012G: TBitBtn
      Tag = 3
      Left = 8
      Top = 280
      Width = 95
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 9
      OnClick = btn_mpst012GClick
      NumGlyphs = 2
    end
    object btn_mpst012K: TBitBtn
      Tag = 3
      Left = 8
      Top = 310
      Width = 95
      Height = 25
      Caption = 'Bom'#34920#26597#35426
      TabOrder = 10
      OnClick = btn_mpst012KClick
      NumGlyphs = 2
    end
    object btn_mpst012N: TBitBtn
      Tag = 2
      Left = 8
      Top = 340
      Width = 95
      Height = 25
      Caption = #33184#31995#23610#23544#29986#33021
      TabOrder = 11
      OnClick = btn_mpst012NClick
      NumGlyphs = 2
    end
    object btn_mpst012O: TBitBtn
      Tag = 2
      Left = 8
      Top = 370
      Width = 95
      Height = 25
      Caption = #36948#20132#26085#26399#25976#37327
      TabOrder = 12
      OnClick = btn_mpst012OClick
      NumGlyphs = 2
    end
    object btn_mpst012P: TBitBtn
      Tag = 2
      Left = 8
      Top = 400
      Width = 95
      Height = 25
      Caption = #25490#35069#37327#32113#35336
      TabOrder = 13
      OnClick = btn_mpst012PClick
      NumGlyphs = 2
    end
    object btn_mpst012Q: TBitBtn
      Tag = 2
      Left = 8
      Top = 430
      Width = 95
      Height = 25
      Caption = #36339#36681#26085#26399
      TabOrder = 14
      OnClick = btn_mpst012QClick
      NumGlyphs = 2
    end
    object btn_mpst070R: TButton
      Tag = 2
      Left = 8
      Top = 458
      Width = 95
      Height = 25
      Hint = 'CCL'#32113#35336
      Caption = 'CCL'#32113#35336
      TabOrder = 15
      OnClick = btn_mpst070RClick
    end
    object btn_mpst012S: TButton
      Left = 8
      Top = 487
      Width = 95
      Height = 25
      Caption = #35330#21934#38364#32879#24235#23384
      TabOrder = 16
      OnClick = btn_mpst012SClick
    end
    object btn_mpst012T: TButton
      Left = 8
      Top = 516
      Width = 95
      Height = 25
      Caption = #21462#27171#25976#37327
      TabOrder = 17
      OnClick = btn_mpst012TClick
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu1Popup
    Left = 720
    Top = 341
    object N20: TMenuItem
      Caption = #25972#22825#36984#20013
      OnClick = N20Click
    end
    object N21: TMenuItem
      Caption = #20840#37096#21462#28040
      OnClick = N21Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N22: TMenuItem
      Caption = #36820#22238#24453#25490
      OnClick = N22Click
    end
    object N23: TMenuItem
      Caption = #21034#38500
      OnClick = N23Click
    end
    object N24: TMenuItem
      Caption = #35079#35069
      OnClick = N24Click
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS2BeforePost
    AfterScroll = CDS2AfterScroll
    Left = 749
    Top = 341
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 778
    Top = 341
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 778
    Top = 373
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS3BeforePost
    AfterScroll = CDS3AfterScroll
    Left = 749
    Top = 373
  end
  object PopupMenu2: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu2Popup
    Left = 720
    Top = 374
    object N31: TMenuItem
      Caption = #21034#38500
      OnClick = N31Click
    end
    object N32: TMenuItem
      Caption = #35079#35069
      OnClick = N32Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N33: TMenuItem
      Caption = #25286#20998#25976#37327#35079#35069
      OnClick = N33Click
    end
    object N34: TMenuItem
      Caption = #29983#29986#26085#26399#30456#21516
      OnClick = N34Click
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=dgiteq;Persist Security Info=True;U' +
      'ser ID=sa;Initial Catalog=ERP2015;Data Source=192.168.4.14'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 164
    Top = 212
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 196
    Top = 212
  end
end
