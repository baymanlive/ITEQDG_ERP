inherited FrmMDT060_lot: TFrmMDT060_lot
  Width = 595
  Height = 342
  Caption = #25209#34399#36984#25799
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
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_six03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_six08'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_six04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_six05'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_six06'
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
