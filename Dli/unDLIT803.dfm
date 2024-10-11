inherited FrmDLIT803: TFrmDLIT803
  Left = 309
  Top = 242
  Caption = 'FrmDLIT803'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    inherited btn_export: TToolButton
      ImageIndex = 53
      OnClick = btn_exportClick
    end
    inherited btn_query: TToolButton
      ImageIndex = 50
      OnClick = btn_queryClick
    end
  end
  object PnlBottom: TPanel [2]
    Left = 0
    Top = 296
    Width = 584
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
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
      Text = '0'
    end
    object Edit2: TEdit
      Left = 148
      Top = 4
      Width = 60
      Height = 21
      TabStop = False
      ParentColor = True
      TabOrder = 1
      Text = '0'
    end
  end
  object DBGridEh1: TDBGridEh [3]
    Left = 0
    Top = 44
    Width = 584
    Height = 252
    Align = alClient
    DataSource = DS
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 3
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'purno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pursno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
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
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'place'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'area'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Excel'#27284#26696'(*.xlsx)|*.xlsx|Excel'#27284#26696'(*.xls)|*.xls'
    Left = 840
    Top = 56
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 868
    Top = 56
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDSAfterOpen
    AfterScroll = CDSAfterScroll
    Left = 896
    Top = 56
  end
end
