inherited FrmMPST012_cqty: TFrmMPST012_cqty
  Left = 190
  Top = 137
  Width = 1000
  Height = 500
  Caption = #23458#25142#32676#29986#33021#26126#32048
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 874
    Height = 461
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 874
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
        FieldName = 'groupid'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
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
        FieldName = 'isthin'
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
