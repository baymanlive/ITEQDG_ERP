inherited FrmMPST010: TFrmMPST010
  Left = 411
  Top = 162
  Caption = 'FrmMPST010'
  ClientHeight = 717
  ClientWidth = 1476
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1476
    ButtonWidth = 85
    object btn_mpst010U: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #26356#26032#24037#21934#34399#30908
      ImageIndex = 58
      OnClick = btn_mpst010UClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 687
    Width = 1476
    object Label3: TLabel [4]
      Left = 255
      Top = 6
      Width = 107
      Height = 16
      Caption = #29983#29986#26085#26399'/'#37707#27425
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel [5]
      Left = 515
      Top = 6
      Width = 34
      Height = 16
      Caption = #25976#37327
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
      ParentColor = True
      ParentFont = False
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 460
      Top = 3
      Width = 30
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 3
      Text = '0'
    end
    object Edit5: TEdit
      Left = 550
      Top = 3
      Width = 50
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 4
      Text = '0'
    end
    object Edit6: TEdit
      Left = 605
      Top = 3
      Width = 50
      Height = 24
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
  end
  inherited Panel1: TPanel
    Width = 1476
  end
  inherited PCL: TPageControl
    Width = 1366
    Height = 643
    OnChange = PCLChange
    inherited TabSheet1: TTabSheet
      Caption = #24050#30906#35469#25490#31243
      inherited DBGridEh1: TDBGridEh
        Left = 52
        Width = 1306
        Height = 615
        Hint = #40736#27161#38617#25802#22238#21040#26410#25490',[Ctrl+F]'#26597#25214',[Ctrl+E]'#26356#25913#36948#20132#26085#26399',[Ctrl+Q]'#26356#25913#20841#35282#35330#21934
        PopupMenu = PopupMenu1
        ReadOnly = True
        OnCellClick = DBGridEh1CellClick
        OnDblClick = DBGridEh1DblClick
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        OnGetCellParams = DBGridEh1GetCellParams
        OnKeyDown = DBGridEh1KeyDown
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'select'
            Footers = <>
            Width = 20
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'case_ans1'
            Footers = <>
            Width = 20
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
            FieldName = 'wono'
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
            FieldName = 'regulateQty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate_new'
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
            FieldName = 'stealno'
            Footers = <>
            Width = 40
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
            FieldName = 'edate'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adhesive'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'thickness'
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
            FieldName = 'supplier'
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
            FieldName = 'co_str'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'remain_ordqty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sampleQty'
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
        Width = 52
        Height = 615
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG1: TRadioGroup
          Left = 0
          Top = 0
          Width = 50
          Height = 300
          TabOrder = 0
          OnClick = RG1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38928#25490#32080#26524
      ImageIndex = 2
      object DBGridEh2: TDBGridEh
        Left = 52
        Top = 0
        Width = 1306
        Height = 615
        Hint = #38928#25490#32080#26524
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
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
            FieldName = 'adate'
            Footers = <>
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
            FieldName = 'stealno'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'boiler1'
            Footers = <>
            PickList.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12')
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
            FieldName = 'edate'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sampleQty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 52
        Height = 615
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG2: TRadioGroup
          Left = 0
          Top = 0
          Width = 50
          Height = 300
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
        Width = 1774
        Height = 710
        Hint = #24453#25490#35330#21934','#21487#20351#29992#21491#37749'['#21034#38500']'#25110'['#35079#35069'],'#38617#25802#21487#35722#25563'['#21934#36984']'#25110'['#35079#36984']'
        Align = alClient
        DataSource = DS3
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        PopupMenu = PopupMenu2
        TabOrder = 0
        OnDblClick = DBGridEh3DblClick
        OnGetCellParams = DBGridEh3GetCellParams
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
            FieldName = 'regulateQty'
            Footers = <>
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
            FieldName = 'machine1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate1'
            Footers = <>
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'boiler1'
            Footers = <>
            PickList.Strings = (
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12')
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
            Footers = <>
            ReadOnly = True
            Width = 40
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark2'
            Footers = <>
            ReadOnly = True
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
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sampleQty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 1366
    Top = 44
    Width = 110
    Height = 643
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst010A: TBitBtn
      Tag = 2
      Left = 8
      Top = 10
      Width = 95
      Height = 25
      Hint = #26410#25490#35330#21934#26597#35426
      Caption = #21103#25490#31243#35330#21934
      TabOrder = 0
      OnClick = btn_mpst010AClick
      NumGlyphs = 2
    end
    object btn_mpst010B: TBitBtn
      Tag = 2
      Left = 8
      Top = 40
      Width = 95
      Height = 25
      Hint = #30701#20132#35330#21934
      Caption = #30701#20132#35330#21934
      TabOrder = 1
      OnClick = btn_mpst010BClick
      NumGlyphs = 2
    end
    object btn_mpst010C: TBitBtn
      Tag = 2
      Left = 8
      Top = 70
      Width = 95
      Height = 25
      Hint = #26681#25818#24453#25490#35330#21934#30340#25490#35069#38918#24207#36914#34892#33258#21205#25490#31243
      Caption = #22519#34892#25490#31243
      TabOrder = 2
      OnClick = btn_mpst010CClick
      NumGlyphs = 2
    end
    object btn_mpst010D: TBitBtn
      Tag = 2
      Left = 8
      Top = 100
      Width = 95
      Height = 25
      Hint = #30906#35469#38928#25490#32080#26524','#20786#23384#36039#26009
      Caption = #25490#31243#30906#35469
      TabOrder = 3
      OnClick = btn_mpst010DClick
      NumGlyphs = 2
    end
    object btn_mpst010E: TBitBtn
      Tag = 2
      Left = 8
      Top = 130
      Width = 95
      Height = 25
      Hint = #23565#24050#30906#35469#30340#25490#31243','#30456#21516#27231#21488#30340#21934#25818#20301#32622#35519#25972
      Caption = #35519#25972#20301#32622
      TabOrder = 4
      OnClick = btn_mpst010EClick
      NumGlyphs = 2
    end
    object btn_mpst010F: TBitBtn
      Tag = 2
      Left = 8
      Top = 160
      Width = 95
      Height = 25
      Hint = #23565#24050#30906#35469#30340#25490#31243','#30456#21516#27231#21488#25972#37707#23565#25563
      Caption = #25972#37707#23565#25563
      TabOrder = 5
      OnClick = btn_mpst010FClick
      NumGlyphs = 2
    end
    object btn_mpst010G: TBitBtn
      Tag = 2
      Left = 8
      Top = 190
      Width = 95
      Height = 25
      Hint = #22810#29983#29986#25110#23569#29983#29986','#33256#26178#30064#24120#35336#21010#35722#26356#26178#29983#29986#26085#26399#37325#25972
      Caption = #30064#24120#35336#21010#35722#26356
      TabOrder = 6
      OnClick = btn_mpst010GClick
      NumGlyphs = 2
    end
    object btn_mpst010H: TBitBtn
      Tag = 2
      Left = 8
      Top = 220
      Width = 95
      Height = 25
      Hint = #23565#25152#26377#36984#20013#30340#32080#26696#21934#25818#36914#34892#24375#21046#32080#26696','#24375#21046#32080#26696#24460#37325#26032#25171#38283#20316#26989#23559#19981#20877#39023#31034
      Caption = #24375#21046#32080#26696
      TabOrder = 7
      OnClick = btn_mpst010HClick
      NumGlyphs = 2
    end
    object btn_mpst010I: TBitBtn
      Tag = 2
      Left = 8
      Top = 250
      Width = 95
      Height = 25
      Hint = #22686#21152#31354#34892
      Caption = #22686#21152#31354#34892
      TabOrder = 8
      OnClick = btn_mpst010IClick
      NumGlyphs = 2
    end
    object btn_mpst010J: TBitBtn
      Tag = 2
      Left = 8
      Top = 280
      Width = 95
      Height = 25
      Hint = #35336#31639#30070#21069#37707#27425#30340#26412#25976
      Caption = #35336#31639#21934#37707#26412#25976
      TabOrder = 9
      OnClick = btn_mpst010JClick
      NumGlyphs = 2
    end
    object btn_mpst010K: TBitBtn
      Tag = 2
      Left = 8
      Top = 310
      Width = 95
      Height = 25
      Hint = #35336#31639#19968#22825#20013#21508#37707#27425#30340#26412#25976
      Caption = #35336#31639#19968#22825#26412#25976
      TabOrder = 10
      OnClick = btn_mpst010KClick
      NumGlyphs = 2
    end
    object btn_mpst010L: TBitBtn
      Tag = 2
      Left = 8
      Top = 340
      Width = 95
      Height = 25
      Hint = #30456#21516#37628#26495#30340#37707#27425#24460#31227','#31354#20986#27492#37707
      Caption = #22686#21152#37628#26495
      TabOrder = 11
      OnClick = btn_mpst010LClick
      NumGlyphs = 2
    end
    object btn_mpst010M: TBitBtn
      Tag = 2
      Left = 8
      Top = 370
      Width = 95
      Height = 25
      Hint = #27298#26597#30070#21069#26085#26399#36215#25152#26377#25490#31243#20013#30340#37628#26495#33287#37628#26495#36039#26009#35373#23450#26159#21542#19968#33268
      Caption = #27298#26597#37628#26495
      TabOrder = 12
      OnClick = btn_mpst010MClick
      NumGlyphs = 2
    end
    object btn_mpst010N: TBitBtn
      Tag = 2
      Left = 8
      Top = 400
      Width = 95
      Height = 25
      Hint = #20809#27161#36339#36681#21040#35519#25972#30340#37707#27425
      Caption = #36339#36681#37707#27425
      TabOrder = 13
      OnClick = btn_mpst010NClick
      NumGlyphs = 2
    end
    object btn_mpst010O: TBitBtn
      Tag = 3
      Left = 8
      Top = 430
      Width = 95
      Height = 25
      Hint = #35336#31639#24235#23384
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 14
      OnClick = btn_mpst010OClick
      NumGlyphs = 2
    end
    object btn_mpst010P: TBitBtn
      Tag = 3
      Left = 8
      Top = 460
      Width = 95
      Height = 25
      Hint = 'BOM'#34920#26597#35426
      Caption = 'BOM'#34920#26597#35426
      TabOrder = 15
      OnClick = btn_mpst010PClick
      NumGlyphs = 2
    end
    object btn_mpst010Q: TBitBtn
      Tag = 3
      Left = 8
      Top = 490
      Width = 95
      Height = 25
      Hint = #26356#26032#32068#21512#31449#22577#24037#30340#37509#31636#33267#25490#31243
      Caption = #22577#24037#37509#31636#26356#26032
      TabOrder = 16
      OnClick = btn_mpst010QClick
      NumGlyphs = 2
    end
    object btn_mpst010R: TBitBtn
      Tag = 3
      Left = 8
      Top = 520
      Width = 95
      Height = 25
      Hint = #26356#26032#35330#21934#26410#20132#25976#37327
      Caption = #26410#20132#25976#37327#26356#26032
      TabOrder = 17
      OnClick = btn_mpst010RClick
      NumGlyphs = 2
    end
    object btn_mpst010S: TBitBtn
      Tag = 2
      Left = 8
      Top = 550
      Width = 95
      Height = 25
      Hint = #26681#25818'CCL'#25490#31243#35336#31639#20839#29992'core'
      Caption = #20839#29992'core'#35336#31639
      TabOrder = 18
      OnClick = btn_mpst010SClick
      NumGlyphs = 2
    end
    object btn_mpst010T: TBitBtn
      Tag = 2
      Left = 8
      Top = 580
      Width = 95
      Height = 25
      Caption = #25490#35069#37327#32113#35336
      TabOrder = 19
      OnClick = btn_mpst010TClick
      NumGlyphs = 2
    end
    object btnCheckMaterReview: TButton
      Left = 8
      Top = 611
      Width = 95
      Height = 25
      Caption = #28151#26009#25972#29702
      TabOrder = 20
      OnClick = btnCheckMaterReviewClick
    end
    object btn_mpst010V: TButton
      Tag = 2
      Left = 7
      Top = 643
      Width = 95
      Height = 25
      Caption = #29986#29983#37325#24037#24037#21934
      TabOrder = 21
      OnClick = btn_mpst010VClick
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu1Popup
    Left = 720
    Top = 341
    object N20: TMenuItem
      Caption = #25972#37707#36984#20013
      OnClick = N20Click
    end
    object N21: TMenuItem
      Caption = #20840#37096#21462#28040
      OnClick = N21Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N22: TMenuItem
      Caption = #25972#37707#32080#26696
      OnClick = N22Click
    end
    object N23: TMenuItem
      Caption = #26356#25913#26412#25976
      OnClick = N23Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #37628#26495#20999#25563
      object N26: TMenuItem
        Caption = #26356#25913
        OnClick = N26Click
      end
      object N27: TMenuItem
        Caption = #21034#38500
        OnClick = N27Click
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #21516#37707#25563#20301
      OnClick = N6Click
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS2BeforePost
    AfterScroll = CDS2AfterScroll
    OnNewRecord = CDS2NewRecord
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
    object N24: TMenuItem
      Caption = #33256#26178#21034#38500
      Hint = #21034#38500
      OnClick = N24Click
    end
    object N28: TMenuItem
      Caption = #24505#24213#21034#38500
      OnClick = N28Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N29: TMenuItem
      Caption = #35079#35069
      Hint = #35079#35069#30070#21069#36889#31558#36039#26009
      OnClick = N29Click
    end
    object N30: TMenuItem
      Caption = #29983#29986#26085#26399#30456#21516
      OnClick = N30Click
    end
  end
end
