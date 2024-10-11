inherited FrmMDT060_img: TFrmMDT060_img
  Width = 800
  Height = 420
  Caption = #24067#25458#34399#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 674
    Height = 381
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 674
    Height = 381
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
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ima02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ima021'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img10'
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
