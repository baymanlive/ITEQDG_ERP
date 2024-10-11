inherited FrmDLIT801_fdate: TFrmDLIT801_fdate
  Width = 279
  Caption = #30436#40670#26085#26399#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 153
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 153
    Height = 276
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
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'fdate'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 57
    Top = 45
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 85
    Top = 45
  end
end
