inherited FrmMPST012_adqty: TFrmMPST012_adqty
  Left = 192
  Top = 145
  Width = 800
  Height = 500
  Caption = #33184#31995#23610#23544#29986#33021#26126#32048
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 674
    Height = 461
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 674
    Height = 461
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
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stype'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'maxqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remainqty'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 468
    Top = 256
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 440
    Top = 256
  end
end
