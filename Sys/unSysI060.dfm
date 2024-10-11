inherited FrmSysI060: TFrmSysI060
  Caption = 'FrmSysI060'
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 300
    Top = 44
    Height = 451
  end
  inherited ToolBar: TToolBar
    ButtonWidth = 65
    TabOrder = 1
    object btn_otherrpt: TToolButton
      Left = 594
      Top = 0
      Caption = 'btn_otherrpt'
      ImageIndex = 41
      OnClick = btn_otherrptClick
    end
  end
  inherited PnlBottom: TPanel
    TabOrder = 2
  end
  inherited Panel1: TPanel
    TabOrder = 3
  end
  object DBGridEh2: TDBGridEh [4]
    Left = 0
    Top = 44
    Width = 300
    Height = 451
    Align = alLeft
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
        FieldName = 'procid'
        Footers = <>
        ReadOnly = False
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'procname'
        Footers = <>
        ReadOnly = False
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel2: TPanel [5]
    Left = 303
    Top = 44
    Width = 660
    Height = 451
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 0
      Width = 660
      Height = 451
      Align = alClient
      DataSource = DS1
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
          FieldName = 'reportname'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'def'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS2AfterScroll
    Left = 705
    Top = 37
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 733
    Top = 37
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 772
    Top = 36
  end
end
