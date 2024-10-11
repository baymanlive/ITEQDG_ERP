inherited FrmDLII430_ordlist: TFrmDLII430_ordlist
  Width = 1130
  Height = 600
  Caption = #20986#36008#25490#31243#26126#32048
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 1004
    Top = 40
    Height = 522
    TabOrder = 1
    object btn_export: TBitBtn
      Tag = 2
      Left = 10
      Top = 70
      Width = 90
      Height = 25
      Hint = 'btn_export'
      Caption = 'btn_export'
      TabOrder = 2
      OnClick = btn_exportClick
      NumGlyphs = 2
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 40
    Width = 1004
    Height = 522
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
        FieldName = 'pathname'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sno'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custshort'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'notcount1'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'units'
        Footers = <>
        Width = 60
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark'
        Footers = <>
        Width = 60
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 1114
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 316
      Top = 14
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label1: TLabel
      Left = 70
      Top = 14
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
    object Dtp: TDateTimePicker
      Left = 105
      Top = 10
      Width = 100
      Height = 21
      Date = 42755.000000000000000000
      Time = 42755.000000000000000000
      TabOrder = 0
    end
    object btn_query: TBitBtn
      Left = 210
      Top = 8
      Width = 40
      Height = 25
      Caption = #26597#35426
      TabOrder = 1
      OnClick = btn_queryClick
    end
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
end
