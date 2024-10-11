inherited FrmIPQCT500_forecast: TFrmIPQCT500_forecast
  Width = 980
  Height = 587
  Caption = #29627#24067#38656#27714#32113#35336
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 854
    Top = 50
    Height = 499
    TabOrder = 1
    object btn_export: TBitBtn
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Caption = 'btn_export'
      TabOrder = 2
      OnClick = btn_exportClick
      NumGlyphs = 2
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 50
    Width = 854
    Height = 499
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
        FieldName = 'pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 964
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 192
      Top = 16
      Width = 13
      Height = 13
      Alignment = taRightJustify
      Caption = #33267
    end
    object Label1: TLabel
      Left = 35
      Top = 16
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #29983#29986#26085#26399#65306
    end
    object Dtp1: TDateTimePicker
      Left = 100
      Top = 12
      Width = 90
      Height = 21
      Date = 42677.000000000000000000
      Time = 42677.000000000000000000
      TabOrder = 0
    end
    object Dtp2: TDateTimePicker
      Left = 210
      Top = 12
      Width = 90
      Height = 21
      Date = 42677.000000000000000000
      Time = 42677.000000000000000000
      TabOrder = 1
    end
    object RG: TRadioGroup
      Left = 340
      Top = 2
      Width = 137
      Height = 36
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'DG'
        'GZ')
      TabOrder = 2
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
