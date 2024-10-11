inherited FrmDLIT710: TFrmDLIT710
  Caption = 'FrmDLIT710'
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
  object DBGridEh1: TDBGridEh [2]
    Left = 0
    Top = 44
    Width = 954
    Height = 447
    Align = alClient
    DataSource = DS
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 2
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Lot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Place'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Area'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'State'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object PnlBottom: TPanel [3]
    Left = 0
    Top = 491
    Width = 954
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 3
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
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDSAfterScroll
    Left = 732
    Top = 413
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 764
    Top = 412
  end
end
