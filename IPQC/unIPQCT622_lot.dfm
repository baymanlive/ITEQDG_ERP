inherited FrmIPQCT622_lot: TFrmIPQCT622_lot
  Width = 360
  Height = 470
  Caption = #36984#25799#25209#34399
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 234
    Height = 431
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 234
    Height = 431
    Align = alClient
    DataSource = DS
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 1
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 156
    Top = 164
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 184
    Top = 164
  end
end
