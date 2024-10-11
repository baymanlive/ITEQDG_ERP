inherited FrmMPST650_pur: TFrmMPST650_pur
  Left = 187
  Top = 196
  Width = 1300
  Height = 600
  Caption = #35531#36092#21934#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 1174
    Top = 50
    Height = 512
    TabOrder = 1
    object Memo1: TMemo
      Left = 8
      Top = 320
      Width = 94
      Height = 189
      Lines.Strings = (
        'Memo1')
      TabOrder = 2
      Visible = False
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 50
    Width = 1174
    Height = 512
    Align = alClient
    DataSource = DS
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
        FieldName = 'pmk01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pmk04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pmk09'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'occ02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml041'
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
        FieldName = 'pml07'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml09'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml20'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml20x'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pml06'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 1284
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
    object Label3: TLabel
      Left = 323
      Top = 16
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #35531#36092#34399#30908#65306
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
    object btn_query: TBitBtn
      Left = 500
      Top = 10
      Width = 75
      Height = 25
      Caption = 'btn_query'
      TabOrder = 3
      OnClick = btn_queryClick
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00101810001018
        1000101810001018100010181000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF002939290010181000101810001018100010181000FF00FF0018211800C6E7
        C600426B4A00294A310010181000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0029392900C6E7C600426B4A00294A310010181000FF00FF0018211800C6E7
        C600426B4A00294A310010181000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0029392900C6E7C600426B4A00294A310010181000FF00FF00182118001018
        10001018100010181000101810001018100010181000FF00FF00101810001018
        10001018100010181000101810001018100010181000FF00FF00182118003152
        3100C6E7C600426B4A001018100010181000101810001018100010181000C6E7
        C600426B4A00294A3100294A31001018100010181000FF00FF00182118003152
        3100C6E7C600426B4A001018100010181000ADCEAD001018100010181000C6E7
        C600426B4A00294A3100294A31001018100010181000FF00FF00182118003152
        3100C6E7C600426B4A001018100010181000ADCEAD001018100010181000C6E7
        C600426B4A00294A3100294A31001018100010181000FF00FF00FF00FF001821
        1800182118001018100010181000101810001018100010181000101810001018
        100010181000101810001018100010181000FF00FF00FF00FF00FF00FF00FF00
        FF0018211800C6E7C600426B4A001018100010181000FF00FF0018211800C6E7
        C600426B4A00294A310010181000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF001821180018211800426B4A001018100010181000FF00FF00182118001821
        1800426B4A00294A310010181000FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00182118001821180018211800FF00FF00FF00FF00FF00FF001821
        18001821180018211800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0018291800C6E7C60000000000FF00FF00FF00FF00FF00FF001829
        1800C6E7C60000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00182918001829180018211800FF00FF00FF00FF00FF00FF001829
        18001829180018291800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
    object Edit1: TEdit
      Left = 388
      Top = 12
      Width = 100
      Height = 21
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 12
      Top = 14
      Width = 85
      Height = 17
      Caption = #35531#36092#26085#26399#65306
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object pb: TProgressBar
      Left = 608
      Top = 16
      Width = 565
      Height = 17
      TabOrder = 5
      Visible = False
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 57
    Top = 217
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 86
    Top = 217
  end
end
