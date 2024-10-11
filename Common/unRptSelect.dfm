inherited FrmRptSelect: TFrmRptSelect
  Width = 420
  Height = 380
  Caption = #22577#34920#36984#25799
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 294
    Height = 342
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 294
    Height = 342
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
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rptid'
        Footers = <>
        Width = 80
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rptname'
        Footers = <>
        Width = 80
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 88
    Top = 140
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 60
    Top = 140
  end
end
