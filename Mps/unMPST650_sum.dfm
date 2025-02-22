inherited FrmMPST650_sum: TFrmMPST650_sum
  Width = 700
  Height = 638
  Caption = #25976#37327#32113#35336#34920
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 582
    Top = 50
    Height = 561
  end
  inherited PCL: TPageControl
    Left = 120
    Top = 50
    Width = 462
    Height = 561
    inherited TabSheet1: TTabSheet
      Caption = #38928#35336#20986#24288
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 454
        Height = 533
        Align = alClient
        DataSource = DS1
        DynProps = <>
        FooterRowCount = 1
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        SumList.Active = True
        TabOrder = 0
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
            FieldName = 'units'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty2'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38928#35336#21040#24288
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 446
        Height = 521
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterRowCount = 1
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        ReadOnly = True
        SumList.Active = True
        TabOrder = 0
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
            FieldName = 'units'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fdate'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty1'
            Footer.ValueType = fvtSum
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty2'
            Footer.ValueType = fvtSum
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 692
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 208
      Top = 16
      Width = 13
      Height = 13
      Alignment = taRightJustify
      Caption = #33267
    end
    object Label1: TLabel
      Left = 47
      Top = 16
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #26597#35426#26085#26399#65306
    end
    object Dtp1: TDateTimePicker
      Left = 116
      Top = 12
      Width = 90
      Height = 21
      Date = 42677.000000000000000000
      Time = 42677.000000000000000000
      TabOrder = 0
    end
    object Dtp2: TDateTimePicker
      Left = 226
      Top = 12
      Width = 90
      Height = 21
      Date = 42677.000000000000000000
      Time = 42677.000000000000000000
      TabOrder = 1
    end
    object btn_query: TBitBtn
      Left = 324
      Top = 10
      Width = 80
      Height = 25
      Caption = 'btn_query'
      TabOrder = 2
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
    object btn_export: TBitBtn
      Left = 404
      Top = 10
      Width = 80
      Height = 25
      Caption = 'btn_export'
      TabOrder = 3
      OnClick = btn_exportClick
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00000000000000000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF000000000000000000848484008484840000000000FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00000000008484840084848400848484008484840000000000FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF000000000000000000848484008484840000000000FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF000000
        000000000000000000000000000000000000000000000000000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
        0000C6C60000C6C60000C6C60000C6C60000C6C60000C6C6000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00000000000000000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
    object BitBtn1: TBitBtn
      Left = 484
      Top = 10
      Width = 80
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 4
      OnClick = BitBtn1Click
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF003030
        30003030300030303000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF003030
        300000C0C000008080003030300030303000FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00303030003030300030303000303030003030
        300000C0C00000C0C00000C0C0000080800030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0030303000C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0058585800C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF0000000000FF00FF0080808000C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF000000000000000000C3C3C300C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00000000000000
        000000000000585858005858580000000000C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00000000005858
        58005858580058585800585858005858580000000000C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00000000000000
        000000000000585858005858580000000000C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF000000000000000000C3C3C300C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF0000000000FF00FF0080808000C0FFFF00C0FFFF00C0FFFF003030
        300000C0C00000C0C00000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0058585800C0FFFF00C0FFFF00C0FFFF008080
        8000303030000080800000C0C00000C0C00030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0030303000C0FFFF00C0FFFF00C0FFFF00C0FF
        FF00C0FFFF00A0A0A000303030000080800030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00303030003030300030303000303030003030
        30003030300030303000303030003030300030303000FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
  end
  object Panel2: TPanel [3]
    Left = 0
    Top = 50
    Width = 120
    Height = 561
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    object rgp: TRadioGroup
      Left = 6
      Top = 0
      Width = 110
      Height = 400
      ItemIndex = 0
      Items.Strings = (
        #28961#37675'PP'
        #28961#37675'CCL'
        #33274#28771'PP'
        #33274#28771'CCL'
        #27743#35199'PP'
        #27743#35199'CCL'
        #28961#37675#29305#27530#33184#31995
        #33274#28771#29305#27530#33184#31995
        #27743#35199#29305#27530#33184#31995)
      TabOrder = 0
      OnClick = rgpClick
    end
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 141
    Top = 321
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 170
    Top = 321
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 170
    Top = 353
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 141
    Top = 353
  end
end
