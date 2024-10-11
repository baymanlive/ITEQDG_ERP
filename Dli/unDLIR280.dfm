inherited FrmDLIR280: TFrmDLIR280
  Left = 562
  Top = 211
  Caption = 'FrmDLIR280'
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 151
    Width = 630
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inherited PnlBottom: TPanel
    Top = 154
  end
  inherited DBGridEh1: TDBGridEh
    Height = 107
    OnCellClick = DBGridEh1CellClick
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu08'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu05'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu06'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'gem02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvu07'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'gen02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'isprn'
        Footers = <>
      end>
  end
  object DBGridEh2: TDBGridEh [5]
    Left = 0
    Top = 184
    Width = 630
    Height = 220
    Align = alBottom
    DataSource = DS2
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 4
    OnColWidthsChanged = DBGridEh1ColWidthsChanged
    OnMouseDown = DBGridEh1MouseDown
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv31'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv031'
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
        FieldName = 'rvv32'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv33'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv17'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv35'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv36'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'rvv37'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
  object DS2: TDataSource
    Left = 716
    Top = 400
  end
end
