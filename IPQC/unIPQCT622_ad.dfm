inherited FrmIPQCT622_ad: TFrmIPQCT622_ad
  Width = 460
  Height = 470
  Caption = #36984#25799#33184#31995#12289#29256#26412
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 334
    Height = 431
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 334
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
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ver'
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
