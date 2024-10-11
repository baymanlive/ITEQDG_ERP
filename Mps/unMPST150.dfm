inherited FrmMPST150: TFrmMPST150
  Left = 307
  Top = 138
  Caption = 'FrmMPST150'
  ClientHeight = 741
  ClientWidth = 1372
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1372
  end
  inherited PnlBottom: TPanel
    Top = 711
    Width = 1372
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
      Visible = False
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
      TabOrder = 2
      Visible = False
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
      Visible = False
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
      Visible = False
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
      Visible = False
    end
  end
  inherited Panel1: TPanel
    Width = 1372
  end
  inherited PCL: TPageControl
    Width = 1372
    Height = 667
    OnChange = PCLChange
    inherited TabSheet1: TTabSheet
      Caption = #24050#30906#35469#25490#31243
      inherited DBGridEh1: TDBGridEh
        Left = 52
        Width = 1312
        Height = 639
        Hint = #40736#27161#38617#25802#22238#21040#26410#25490',[Ctrl+F]'#26597#25214',[Ctrl+E]'#26356#25913#36948#20132#26085#26399',[Ctrl+Q]'#26356#25913#20841#35282#35330#21934
        ReadOnly = True
        OnDblClick = DBGridEh1DblClick
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        OnGetCellParams = DBGridEh1GetCellParams
        Columns = <
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
        Height = 639
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
      TabVisible = False
      object DBGridEh2: TDBGridEh
        Left = 52
        Top = 0
        Width = 1312
        Height = 639
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
        Height = 639
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
      TabVisible = False
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 1364
        Height = 639
        Hint = #24453#25490#35330#21934','#21487#20351#29992#21491#37749'['#21034#38500']'#25110'['#35079#35069'],'#38617#25802#21487#35722#25563'['#21934#36984']'#25110'['#35079#36984']'
        Align = alClient
        DataSource = DS3
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
    AfterScroll = CDS3AfterScroll
    Left = 749
    Top = 373
  end
end
