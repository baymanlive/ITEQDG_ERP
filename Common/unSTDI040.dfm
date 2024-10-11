inherited FrmSTDI040: TFrmSTDI040
  BorderStyle = bsNone
  Caption = 'FrmSTDI040'
  ClientHeight = 525
  ClientWidth = 963
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar [0]
    Left = 0
    Top = 0
    Width = 963
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 59
    Flat = True
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 0
    Wrapable = False
    object btn_print: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #21015#21360
      ImageIndex = 9
      OnClick = btn_printClick
    end
    object btn_export: TToolButton
      Left = 37
      Top = 0
      AutoSize = True
      Caption = #21295#20986'Excel'
      ImageIndex = 10
      OnClick = btn_exportClick
    end
    object btn_query: TToolButton
      Left = 100
      Top = 0
      AutoSize = True
      Caption = #26597#35426
      ImageIndex = 11
      OnClick = btn_queryClick
    end
    object ToolButton4: TToolButton
      Left = 137
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_first: TToolButton
      Left = 145
      Top = 0
      AutoSize = True
      Caption = #31532#19968#31558
      ImageIndex = 12
      OnClick = btn_firstClick
    end
    object btn_prior: TToolButton
      Left = 195
      Top = 0
      AutoSize = True
      Caption = #19978#31558
      ImageIndex = 13
      OnClick = btn_priorClick
    end
    object btn_next: TToolButton
      Left = 232
      Top = 0
      AutoSize = True
      Caption = #19979#31558
      ImageIndex = 15
      OnClick = btn_nextClick
    end
    object btn_last: TToolButton
      Left = 269
      Top = 0
      AutoSize = True
      Caption = #26411#19968#31558
      ImageIndex = 16
      OnClick = btn_lastClick
    end
    object ToolButton5: TToolButton
      Left = 319
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_quit: TToolButton
      Left = 327
      Top = 0
      AutoSize = True
      Caption = #38626#38283
      ImageIndex = 19
      OnClick = btn_quitClick
    end
  end
  object PnlBottom: TPanel [1]
    Left = 0
    Top = 495
    Width = 963
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 1
    object lblrecored: TLabel
      Tag = 1
      Left = 43
      Top = 8
      Width = 26
      Height = 13
      Caption = #31558#25976
    end
    object Bevel1: TBevel
      Left = 8
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object Bevel2: TBevel
      Left = 213
      Top = 14
      Width = 30
      Height = 10
      Shape = bsTopLine
    end
    object lblsp: TLabel
      Tag = 1
      Left = 138
      Top = 8
      Width = 3
      Height = 13
      Caption = '/'
    end
    object Edit1: TEdit
      Left = 73
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 148
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 1
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 38
    Width = 963
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
  object PCL: TPageControl [3]
    Left = 0
    Top = 44
    Width = 963
    Height = 451
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        TabOrder = 0
        OnColWidthsChanged = DBGridEh1ColWidthsChanged
        OnMouseDown = DBGridEh1MouseDown
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object DS: TDataSource [4]
    DataSet = CDS
    Left = 897
    Top = 5
  end
  object CDS: TClientDataSet [5]
    Aggregates = <>
    Params = <>
    AfterScroll = CDSAfterScroll
    Left = 869
    Top = 5
  end
  inherited ImageList1: TImageList
    Left = 841
    Top = 5
  end
end
