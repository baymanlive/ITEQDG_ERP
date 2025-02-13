inherited FrmSTDI030: TFrmSTDI030
  Left = 517
  Top = 219
  BorderStyle = bsNone
  Caption = 'FrmSTDI030'
  ClientHeight = 525
  ClientWidth = 596
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar [0]
    Left = 0
    Top = 0
    Width = 596
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 59
    Flat = True
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 0
    Wrapable = False
    object btn_insert: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #26032#22686
      ImageIndex = 4
      OnClick = btn_insertClick
    end
    object btn_edit: TToolButton
      Left = 37
      Top = 0
      AutoSize = True
      Caption = #26356#25913
      ImageIndex = 5
      OnClick = btn_editClick
    end
    object btn_delete: TToolButton
      Left = 74
      Top = 0
      AutoSize = True
      Caption = #21034#38500
      ImageIndex = 6
      OnClick = btn_deleteClick
    end
    object btn_copy: TToolButton
      Left = 111
      Top = 0
      AutoSize = True
      Caption = #35079#35069
      ImageIndex = 57
      OnClick = btn_copyClick
    end
    object btn_post: TToolButton
      Left = 148
      Top = 0
      AutoSize = True
      Caption = #20445#23384
      ImageIndex = 47
      OnClick = btn_postClick
    end
    object btn_cancel: TToolButton
      Left = 185
      Top = 0
      AutoSize = True
      Caption = #21462#28040
      ImageIndex = 48
      OnClick = btn_cancelClick
    end
    object ToolButton2: TToolButton
      Left = 222
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_print: TToolButton
      Left = 230
      Top = 0
      AutoSize = True
      Caption = #21015#21360
      ImageIndex = 9
      OnClick = btn_printClick
    end
    object btn_export: TToolButton
      Left = 267
      Top = 0
      AutoSize = True
      Caption = #21295#20986'Excel'
      ImageIndex = 10
      OnClick = btn_exportClick
    end
    object btn_query: TToolButton
      Left = 330
      Top = 0
      AutoSize = True
      Caption = #26597#35426
      ImageIndex = 11
      OnClick = btn_queryClick
    end
    object ToolButton4: TToolButton
      Left = 367
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_first: TToolButton
      Left = 375
      Top = 0
      AutoSize = True
      Caption = #31532#19968#31558
      ImageIndex = 12
      OnClick = btn_firstClick
    end
    object btn_prior: TToolButton
      Left = 425
      Top = 0
      AutoSize = True
      Caption = #19978#31558
      ImageIndex = 13
      OnClick = btn_priorClick
    end
    object btn_next: TToolButton
      Left = 462
      Top = 0
      AutoSize = True
      Caption = #19979#31558
      ImageIndex = 15
      OnClick = btn_nextClick
    end
    object btn_last: TToolButton
      Left = 499
      Top = 0
      AutoSize = True
      Caption = #26411#19968#31558
      ImageIndex = 16
      OnClick = btn_lastClick
    end
    object ToolButton5: TToolButton
      Left = 549
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_quit: TToolButton
      Left = 557
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
    Width = 596
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
    Width = 596
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
  object PCL: TPageControl [3]
    Left = 0
    Top = 44
    Width = 596
    Height = 451
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 588
        Height = 423
        Align = alClient
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
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
    BeforeInsert = CDSBeforeInsert
    AfterInsert = CDSAfterInsert
    BeforeEdit = CDSBeforeEdit
    AfterEdit = CDSAfterEdit
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
    AfterCancel = CDSAfterCancel
    BeforeDelete = CDSBeforeDelete
    AfterDelete = CDSAfterDelete
    AfterScroll = CDSAfterScroll
    OnNewRecord = CDSNewRecord
    Left = 869
    Top = 5
  end
  inherited ImageList1: TImageList
    Left = 841
    Top = 5
  end
end
