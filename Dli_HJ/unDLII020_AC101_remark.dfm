inherited FrmDLII020_AC101_remark: TFrmDLII020_AC101_remark
  Width = 1000
  Height = 400
  Caption = #20633#35387
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 874
    Height = 361
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 874
    Height = 361
    Align = alClient
    DataSource = DataSource1
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    TabOrder = 1
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'recno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cnt'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DataSource1: TDataSource
    DataSet = CDS
    Left = 388
    Top = 40
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDSBeforeInsert
    BeforeDelete = CDSBeforeDelete
    Left = 416
    Top = 40
  end
end
