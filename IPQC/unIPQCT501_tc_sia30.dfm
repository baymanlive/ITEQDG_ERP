inherited FrmIPQCT501_tc_sia30: TFrmIPQCT501_tc_sia30
  Width = 320
  Height = 400
  Caption = #33184#27700#25209#34399
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 194
    Height = 362
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 194
    Height = 362
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
        FieldName = 'ta_shb02'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 228
    Top = 125
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 228
    Top = 153
  end
end
