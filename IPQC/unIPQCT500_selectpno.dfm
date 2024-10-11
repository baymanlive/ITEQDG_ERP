inherited FrmIPQCT500_selectpno: TFrmIPQCT500_selectpno
  Width = 660
  Height = 545
  Caption = #21407#26009#32232#30908#34920
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 534
    Height = 507
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 534
    Height = 507
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
        FieldName = 'fiber'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'breadth'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'vendor'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'code'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 57
    Top = 217
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 86
    Top = 217
  end
end
