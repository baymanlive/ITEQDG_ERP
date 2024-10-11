inherited FrmMPST070: TFrmMPST070
  Left = 241
  Top = 124
  Caption = 'FrmMPST070'
  ClientHeight = 745
  ClientWidth = 1406
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1406
    ButtonWidth = 85
    object btn_mpst070Q: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #26356#26032#24037#21934#34399#30908
      ImageIndex = 58
      OnClick = btn_mpst070QClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 715
    Width = 1406
    object Label3: TLabel [4]
      Left = 271
      Top = 6
      Width = 90
      Height = 16
      Alignment = taRightJustify
      Caption = #29983#29986#26085#26399'/'#31859
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = #26032#32048#26126#39636
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ProgressBar1: TProgressBar
      Left = 856
      Top = 8
      Width = 150
      Height = 17
      TabOrder = 2
      Visible = False
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
      TabOrder = 3
    end
    object Edit4: TEdit
      Left = 460
      Top = 3
      Width = 70
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
  end
  inherited Panel1: TPanel
    Width = 1406
  end
  inherited PCL: TPageControl
    Width = 1296
    Height = 671
    ActivePage = TabSheet2
    OnChange = PCLChange
    inherited TabSheet1: TTabSheet
      Caption = #24050#30906#35469#25490#31243
      inherited DBGridEh1: TDBGridEh
        Left = 52
        Width = 1236
        Height = 643
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
            FieldName = 'breadth'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fiber'
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
            FieldName = 'wostation_qtystr'
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
            FieldName = 'custno2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custname2'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ppqty'
            Footers = <>
          end>
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 52
        Height = 643
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG1: TRadioGroup
          Left = 0
          Top = 0
          Width = 50
          Height = 370
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
        Width = 1236
        Height = 643
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
            FieldName = 'breadth'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fiber'
            Footers = <>
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
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 52
        Height = 643
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object RG2: TRadioGroup
          Left = 0
          Top = 0
          Width = 50
          Height = 370
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
        Width = 1288
        Height = 643
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
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 1296
    Top = 44
    Width = 110
    Height = 671
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst070A: TBitBtn
      Tag = 2
      Left = 8
      Top = 10
      Width = 95
      Height = 25
      Hint = #26410#25490#35330#21934#26597#35426
      Caption = #26410#25490#35330#21934
      TabOrder = 0
      OnClick = btn_mpst070AClick
      NumGlyphs = 2
    end
    object btn_mpst070B: TBitBtn
      Tag = 2
      Left = 8
      Top = 40
      Width = 95
      Height = 25
      Hint = #30701#20132#35330#21934#26597#35426
      Caption = #30701#20132#35330#21934
      TabOrder = 1
      OnClick = btn_mpst070BClick
      NumGlyphs = 2
    end
    object btn_mpst070C: TBitBtn
      Tag = 2
      Left = 8
      Top = 70
      Width = 95
      Height = 25
      Hint = #26681#25818#24453#25490#35330#21934#30340#25490#35069#38918#24207#36914#34892#33258#21205#25490#31243
      Caption = #22519#34892#25490#31243
      TabOrder = 2
      OnClick = btn_mpst070CClick
      NumGlyphs = 2
    end
    object btn_mpst070D: TBitBtn
      Tag = 2
      Left = 8
      Top = 100
      Width = 95
      Height = 25
      Hint = #30906#35469#38928#25490#32080#26524','#20786#23384#36039#26009
      Caption = #25490#31243#30906#35469
      TabOrder = 3
      OnClick = btn_mpst070DClick
      NumGlyphs = 2
    end
    object btn_mpst070E: TBitBtn
      Tag = 2
      Left = 8
      Top = 130
      Width = 95
      Height = 25
      Hint = #26681#25818'CCL'#25490#31243#35336#31639#20839#29992'core'
      Caption = #20839#29992'core'#25490#31243
      TabOrder = 4
      OnClick = btn_mpst070EClick
      NumGlyphs = 2
    end
    object btn_mpst070F: TBitBtn
      Tag = 2
      Left = 8
      Top = 160
      Width = 95
      Height = 25
      Hint = #23565#25152#26377#36984#20013#30340#32080#26696#21934#25818#36914#34892#24375#21046#32080#26696','#24375#21046#32080#26696#24460#37325#26032#25171#38283#20316#26989#23559#19981#20877#39023#31034
      Caption = #24375#21046#32080#26696
      TabOrder = 5
      OnClick = btn_mpst070FClick
      NumGlyphs = 2
    end
    object btn_mpst070G: TBitBtn
      Tag = 2
      Left = 8
      Top = 190
      Width = 95
      Height = 25
      Hint = #22686#21152#31354#34892
      Caption = #22686#21152#31354#34892
      TabOrder = 6
      OnClick = btn_mpst070GClick
      NumGlyphs = 2
    end
    object btn_mpst070H: TBitBtn
      Tag = 2
      Left = 8
      Top = 220
      Width = 95
      Height = 25
      Hint = #23565#24050#30906#35469#30340#25490#31243','#30456#21516#27231#21488#30340#21934#25818#20301#32622#35519#25972
      Caption = #35519#25972#20301#32622
      TabOrder = 7
      OnClick = btn_mpst070HClick
      NumGlyphs = 2
    end
    object btn_mpst070I: TBitBtn
      Tag = 2
      Left = 8
      Top = 250
      Width = 95
      Height = 25
      Hint = #35519#25972#35215#26684#12289'RC'#38918#24207
      Caption = #35519#25972#38918#24207
      TabOrder = 8
      OnClick = btn_mpst070IClick
      NumGlyphs = 2
    end
    object btn_mpst070J: TBitBtn
      Tag = 2
      Left = 8
      Top = 280
      Width = 95
      Height = 25
      Hint = #23565#25563#29983#29986#26085#26399
      Caption = #23565#25563#26085#26399
      TabOrder = 9
      OnClick = btn_mpst070JClick
      NumGlyphs = 2
    end
    object btn_mpst070K: TBitBtn
      Tag = 2
      Left = 8
      Top = 310
      Width = 95
      Height = 25
      Hint = #35336#31639#25490#31243#25152#20351#29992#26178#38291
      Caption = #35336#31639#26178#38291
      TabOrder = 10
      OnClick = btn_mpst070KClick
      NumGlyphs = 2
    end
    object btn_mpst070L: TBitBtn
      Tag = 3
      Left = 8
      Top = 340
      Width = 95
      Height = 25
      Hint = #35336#31639#24235#23384
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 12
      OnClick = btn_mpst070LClick
      NumGlyphs = 2
    end
    object btn_mpst070M: TBitBtn
      Tag = 3
      Left = 8
      Top = 370
      Width = 95
      Height = 25
      Hint = 'BOM'#34920#26597#35426
      Caption = 'BOM'#34920#26597#35426
      TabOrder = 15
      OnClick = btn_mpst070MClick
      NumGlyphs = 2
    end
    object btn_mpst070N: TBitBtn
      Tag = 3
      Left = 8
      Top = 400
      Width = 95
      Height = 25
      Hint = #26356#26032#23436#24037#25976#37327
      Caption = #26356#26032#23436#24037#25976#37327
      TabOrder = 11
      OnClick = btn_mpst070NClick
      NumGlyphs = 2
    end
    object btn_mpst070O: TBitBtn
      Tag = 3
      Left = 8
      Top = 430
      Width = 95
      Height = 25
      Hint = #26597#35426#26085#26399#33539#22285#20839#20839#29992'core'#20351#29992#26126#32048
      Caption = #20839#29992'core'#26126#32048
      TabOrder = 13
      OnClick = btn_mpst070OClick
      NumGlyphs = 2
    end
    object btn_mpst070P: TBitBtn
      Tag = 2
      Left = 8
      Top = 460
      Width = 95
      Height = 25
      Caption = #36339#36681#26085#26399
      TabOrder = 14
      OnClick = btn_mpst070PClick
      NumGlyphs = 2
    end
    object btn_mpst070CalPP: TBitBtn
      Tag = 3
      Left = 8
      Top = 490
      Width = 95
      Height = 25
      Hint = 'PP'#32113#35336
      Caption = 'PP'#32113#35336
      TabOrder = 16
      OnClick = btn_mpst070CalPPClick
      NumGlyphs = 2
    end
    object btn_mpst070CalcPP: TBitBtn
      Tag = 3
      Left = 8
      Top = 519
      Width = 95
      Height = 25
      Hint = 'btn_mpst070CalcPP'
      Caption = 'PP'#36229#21046#31859#25976
      TabOrder = 17
      OnClick = btn_mpst070CalcPPClick
      NumGlyphs = 2
    end
  end
  inherited CDS: TClientDataSet
    IndexDefs = <
      item
        Name = 'CDSIndex1'
        DescFields = 'RC'
        Fields = 'Machine;Sdate;Jitem;AD;FISno;RC;Fiber;Simuver;Citem'
        Options = [ixDescending]
      end>
    IndexName = 'CDSIndex1'
    StoreDefs = True
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'CDS2Index1'
        DescFields = 'RC'
        Fields = 'Machine;Sdate;Jitem;AD;FISno;RC;Fiber'
        Options = [ixDescending]
      end>
    IndexName = 'CDS2Index1'
    Params = <>
    StoreDefs = True
    BeforePost = CDS2BeforePost
    AfterScroll = CDS2AfterScroll
    OnNewRecord = CDS2NewRecord
    Left = 777
    Top = 409
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 409
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 806
    Top = 441
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS3BeforePost
    AfterScroll = CDS3AfterScroll
    Left = 777
    Top = 441
  end
  object PopupMenu2: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu2Popup
    Left = 748
    Top = 444
    object N24: TMenuItem
      Caption = #21034#38500
      Hint = #21034#38500
      OnClick = N24Click
    end
    object N28: TMenuItem
      Caption = #21034#38500'('#30064#24120')'
      Hint = #30064#24120#35330#21934#21034#38500#24460#24453#25490#19981#20877#20986#29694
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
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Images = ImageList1
    OnPopup = PopupMenu1Popup
    Left = 748
    Top = 409
    object N20: TMenuItem
      Caption = #25972#22825#36984#20013
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
      Caption = #25972#22825#32080#26696
      OnClick = N22Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N23: TMenuItem
      Caption = #26356#25913#29986#33021
      OnClick = N23Click
    end
    object N25: TMenuItem
      Caption = #21034#38500#31354#34892
      OnClick = N25Click
    end
  end
end
