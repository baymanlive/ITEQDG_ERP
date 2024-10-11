inherited FrmIPQCT510: TFrmIPQCT510
  Caption = 'FrmIPQCT510'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    inherited btn_export: TToolButton
      OnClick = btn_exportClick
    end
    inherited btn_query: TToolButton
      OnClick = btn_queryClick
    end
  end
  object PCL: TPageControl [2]
    Left = 0
    Top = 44
    Width = 954
    Height = 477
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #26354#32218#22294
      object lb: TListBox
        Left = 0
        Top = 0
        Width = 121
        Height = 449
        Hint = 'object'
        Align = alLeft
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 13
        Items.Strings = (
          #38917#30446)
        TabOrder = 0
        OnClick = lbClick
      end
      object Panel2: TPanel
        Left = 121
        Top = 0
        Width = 825
        Height = 449
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 825
          Height = 49
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label6: TLabel
            Left = 227
            Top = 13
            Width = 32
            Height = 13
            Alignment = taCenter
            Caption = 'Label1'
          end
          object Label3: TLabel
            Left = 416
            Top = 13
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Caption = 'Label3'
          end
          object Label4: TLabel
            Left = 528
            Top = 13
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Caption = 'Label2'
          end
          object Label5: TLabel
            Left = 51
            Top = 13
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Caption = 'Label1'
          end
          object Edit3: TEdit
            Left = 452
            Top = 10
            Width = 57
            Height = 21
            TabOrder = 0
          end
          object Edit4: TEdit
            Left = 568
            Top = 10
            Width = 57
            Height = 21
            TabOrder = 1
          end
          object dtp1: TDBDateTimeEditEh
            Left = 88
            Top = 10
            Width = 128
            Height = 21
            DynProps = <>
            EditButtons = <>
            Kind = dtkDateTimeEh
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            Visible = True
          end
          object dtp2: TDBDateTimeEditEh
            Left = 260
            Top = 10
            Width = 130
            Height = 21
            DynProps = <>
            EditButtons = <>
            Kind = dtkDateTimeEh
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Visible = True
          end
          object btn_ipqct510A: TBitBtn
            Left = 630
            Top = 8
            Width = 55
            Height = 25
            Caption = #35373#32622
            TabOrder = 4
            OnClick = btn_ipqct510AClick
          end
        end
        object Chart1: TChart
          Left = 0
          Top = 49
          Width = 825
          Height = 400
          AllowZoom = False
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Title.Text.Strings = (
            'object - nothing')
          LeftAxis.Automatic = False
          LeftAxis.AutomaticMinimum = False
          LeftAxis.Minimum = 415.000000000000000000
          Legend.LegendStyle = lsSeries
          Legend.Visible = False
          View3D = False
          Align = alClient
          TabOrder = 1
          OnMouseMove = Chart1MouseMove
          object Series1: TLineSeries
            Active = False
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            LinePen.Width = 2
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = False
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'PLC'#36039#26009
      ImageIndex = 1
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 946
        Height = 450
        Align = alClient
        DataSource = DS1
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #24037#21934#36039#26009
      ImageIndex = 2
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 946
        Height = 450
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
          end
          item
            DisplayFormat = 'YYYY-MM-DD HH:NN:SS'
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
          end
          item
            DisplayFormat = 'YYYY-MM-DD HH:NN:SS'
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #29200#28331#27874#21205
      ImageIndex = 3
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 946
        Height = 450
        Align = alClient
        DataSource = DS3
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'errmemo'
            Footers = <>
          end
          item
            DisplayFormat = 'YYYY-MM-DD HH:NN:SS'
            DynProps = <>
            EditButtons = <>
            FieldName = 'idate'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 245
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 140
    Top = 245
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 175
    Top = 245
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 204
    Top = 245
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 235
    Top = 245
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 272
    Top = 245
  end
  object SaveDialog100: TSaveDialog
    DefaultExt = 'xls'
    Filter = 'Excel (*.xls)|*.xls|Excel (*.xlsx)|*.xlsx'
    Left = 304
    Top = 245
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 0
    Left = 338
    Top = 244
  end
end
