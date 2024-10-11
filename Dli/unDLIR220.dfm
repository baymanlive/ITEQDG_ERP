inherited FrmDLIR220: TFrmDLIR220
  Caption = 'FrmDLIR220'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    object Label1: TLabel [4]
      Left = 250
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel [5]
      Left = 440
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
  end
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ftype'
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
            FieldName = 'orderdate'
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
            FieldName = 'custshort'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'salename'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pname'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sizes'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'units'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'confdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'adate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'mpsdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'diffday1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'diffday2'
            Footers = <>
          end>
      end
    end
    object TabSheet20: TTabSheet
      Caption = 'TabSheet20'
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS2
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
            FieldName = 'ad'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ftype'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'avg'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'not'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet21: TTabSheet
      Caption = 'TabSheet21'
      ImageIndex = 2
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS3
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
            FieldName = 'salename'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custshort'
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
            FieldName = 'ftype'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'not'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet22: TTabSheet
      Caption = 'TabSheet22'
      ImageIndex = 3
      object DBGridEh4: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS4
        DynProps = <>
        FooterRowCount = 1
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        SumList.Active = True
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'salename'
            Footer.Value = #32317#35336
            Footer.ValueType = fvtStaticText
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'not'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet23: TTabSheet
      Caption = 'TabSheet23'
      ImageIndex = 4
      object DBGridEh5: TDBGridEh
        Left = 0
        Top = 0
        Width = 955
        Height = 423
        Align = alClient
        DataSource = DS5
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
            FieldName = 'salename'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custshort'
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
            FieldName = 'ftype'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'avg'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'not'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 866
    Top = 377
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 377
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 405
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 866
    Top = 405
  end
  object CDS4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 433
  end
  object DS4: TDataSource
    DataSet = CDS4
    Left = 866
    Top = 433
  end
  object CDS5: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 837
    Top = 461
  end
  object DS5: TDataSource
    DataSet = CDS5
    Left = 866
    Top = 461
  end
end
