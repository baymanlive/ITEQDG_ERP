inherited FrmDLIT7XX_select: TFrmDLIT7XX_select
  Width = 600
  Height = 400
  Caption = #26855#26495#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 474
    Height = 321
    TabOrder = 2
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 474
    Height = 321
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
    OnDblClick = DBGridEh1DblClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
        ReadOnly = False
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Place'
        Footers = <>
        ReadOnly = False
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Area'
        Footers = <>
        ReadOnly = False
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'state'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 321
    Width = 584
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 16
      Width = 78
      Height = 13
      Caption = #36895#26597#27969#27700#34399#65306
    end
    object Edit1: TEdit
      Left = 84
      Top = 12
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = Edit1Change
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 120
    Top = 245
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 148
    Top = 245
  end
end
