inherited FrmDLIR080_detail: TFrmDLIR080_detail
  Width = 900
  Height = 400
  Caption = #20986#36008#21934#36039#26009
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 774
    Height = 362
    TabOrder = 1
    Visible = False
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 774
    Height = 362
    Align = alClient
    DataSource = DS1
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 0
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb05'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb06'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb12'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb31'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ogb32'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oea10'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb11'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb10'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
end
