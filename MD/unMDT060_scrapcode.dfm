inherited FrmMDT060_scrapcode: TFrmMDT060_scrapcode
  Width = 595
  Height = 342
  Caption = #22577#24290#21407#22240#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 469
    Height = 303
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 469
    Height = 303
    Align = alClient
    DataSource = DS1
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
        FieldName = 'qce01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qce03'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 204
    Top = 140
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 140
  end
end
