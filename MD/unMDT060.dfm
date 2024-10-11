inherited FrmMDT060: TFrmMDT060
  Caption = 'FrmMDT060'
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 8
    Top = 110
    Width = 600
    Height = 160
    Shape = bsFrame
  end
  object Label13: TLabel [1]
    Tag = 1
    Left = 8
    Top = 93
    Width = 38
    Height = 13
    Caption = 'Label13'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label14: TLabel [2]
    Tag = 1
    Left = 8
    Top = 278
    Width = 38
    Height = 13
    Caption = 'Label14'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label16: TLabel [3]
    Tag = 1
    Left = 419
    Top = 280
    Width = 38
    Height = 13
    Caption = 'Label16'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel [4]
    Left = 50
    Top = 129
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [5]
    Left = 50
    Top = 159
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  object Label3: TLabel [6]
    Left = 50
    Top = 189
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label3'
  end
  object Label4: TLabel [7]
    Left = 50
    Top = 231
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label4'
  end
  object Label7: TLabel [8]
    Left = 306
    Top = 158
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label7'
  end
  object Label8: TLabel [9]
    Left = 471
    Top = 187
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label8'
  end
  object Label9: TLabel [10]
    Left = 306
    Top = 188
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label9'
  end
  object Label10: TLabel [11]
    Left = 465
    Top = 157
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label10'
  end
  object Label11: TLabel [12]
    Left = 300
    Top = 218
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label11'
  end
  object Label12: TLabel [13]
    Left = 465
    Top = 218
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label12'
  end
  object btn_sp: TSpeedButton [14]
    Left = 189
    Top = 125
    Width = 40
    Height = 22
    Caption = #26597#35426
    OnClick = btn_spClick
  end
  object Label15: TLabel [15]
    Tag = 1
    Left = 8
    Top = 440
    Width = 38
    Height = 13
    Caption = 'Label15'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label17: TLabel [16]
    Tag = 1
    Left = 418
    Top = 440
    Width = 38
    Height = 13
    Caption = 'Label17'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Bevel2: TBevel [17]
    Left = 0
    Top = 44
    Width = 954
    Height = 9
    Align = alTop
    Shape = bsTopLine
  end
  object Label18: TLabel [18]
    Left = 84
    Top = 93
    Width = 38
    Height = 13
    Caption = 'Label18'
  end
  inherited ToolBar: TToolBar
    ButtonWidth = 72
    TabOrder = 18
    inherited btn_print: TToolButton
      Caption = #25209#34399#38928#36664#20837
      ImageIndex = 52
      OnClick = btn_printClick
    end
    inherited btn_export: TToolButton
      Left = 76
      Caption = #37325#32622#30059#38754
      ImageIndex = 49
      OnClick = btn_exportClick
    end
    inherited btn_query: TToolButton
      Left = 139
      Caption = #30906#35469#22577#24037
      ImageIndex = 64
      OnClick = btn_queryClick
    end
    inherited ToolButton1: TToolButton
      Left = 202
    end
    inherited btn_quit: TToolButton
      Left = 210
    end
  end
  inherited Panel1: TPanel
    TabOrder = 19
  end
  object DBGridEh1: TDBGridEh [21]
    Left = 8
    Top = 295
    Width = 405
    Height = 140
    DataSource = DS1
    DynProps = <>
    FooterRowCount = 1
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    PopupMenu = PopupMenu1
    SumList.Active = True
    TabOrder = 14
    OnEditButtonClick = DBGridEh1EditButtonClick
    Columns = <
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'type'
        Footers = <>
        PickList.Strings = (
          '1.'#38283#27231#35430#35069
          '2.'#36681#35215#26684
          '3.'#27491#24120#29983#29986)
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_sia27'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'tc_sia36'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DBGridEh3: TDBGridEh [22]
    Left = 418
    Top = 295
    Width = 600
    Height = 140
    DataSource = DS3
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    PopupMenu = PopupMenu3
    TabOrder = 15
    OnEditButtonClick = DBGridEh3EditButtonClick
    Columns = <
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'img10'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'ima02'
        Footers = <>
        ReadOnly = True
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'ima021'
        Footers = <>
        ReadOnly = True
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DBGridEh2: TDBGridEh [23]
    Left = 9
    Top = 455
    Width = 405
    Height = 140
    DataSource = DS2
    DynProps = <>
    FooterRowCount = 1
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    PopupMenu = PopupMenu2
    SumList.Active = True
    TabOrder = 16
    OnEditButtonClick = DBGridEh2EditButtonClick
    Columns = <
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'scrapcode'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'scrapname'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'qty'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Edit1: TEdit [24]
    Left = 84
    Top = 125
    Width = 103
    Height = 21
    TabOrder = 1
  end
  object dtp1: TDateTimePicker [25]
    Left = 84
    Top = 155
    Width = 85
    Height = 21
    Date = 43395.000000000000000000
    Time = 43395.000000000000000000
    TabOrder = 2
  end
  object Edit2: TEdit [26]
    Left = 174
    Top = 155
    Width = 55
    Height = 21
    TabOrder = 3
    Text = '00:01'
  end
  object dtp2: TDateTimePicker [27]
    Left = 84
    Top = 185
    Width = 85
    Height = 21
    Date = 43395.000000000000000000
    Time = 43395.000000000000000000
    TabOrder = 4
  end
  object Edit3: TEdit [28]
    Left = 174
    Top = 185
    Width = 55
    Height = 21
    TabOrder = 5
    Text = '00:01'
  end
  object rg1: TRadioGroup [29]
    Left = 84
    Top = 215
    Width = 145
    Height = 42
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'A1'
      'B1')
    TabOrder = 6
  end
  object Edit6: TEdit [30]
    Left = 340
    Top = 155
    Width = 55
    Height = 21
    TabOrder = 7
  end
  object Edit7: TEdit [31]
    Left = 505
    Top = 185
    Width = 55
    Height = 21
    Enabled = False
    TabOrder = 10
    Text = '1'
  end
  object Edit8: TEdit [32]
    Left = 340
    Top = 185
    Width = 55
    Height = 21
    Enabled = False
    TabOrder = 9
    Text = '1'
  end
  object Edit9: TEdit [33]
    Left = 505
    Top = 155
    Width = 55
    Height = 21
    TabOrder = 8
  end
  object Edit10: TEdit [34]
    Left = 340
    Top = 215
    Width = 55
    Height = 21
    Enabled = False
    TabOrder = 11
    Text = '1'
  end
  object Edit11: TEdit [35]
    Left = 505
    Top = 216
    Width = 55
    Height = 21
    Enabled = False
    TabOrder = 12
    Text = '1'
  end
  object chk: TCheckBox [36]
    Left = 340
    Top = 241
    Width = 97
    Height = 17
    Caption = 'chk'
    TabOrder = 13
  end
  object DBGridEh4: TDBGridEh [37]
    Left = 418
    Top = 455
    Width = 600
    Height = 140
    DataSource = DS4
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    PopupMenu = PopupMenu4
    TabOrder = 17
    OnEditButtonClick = DBGridEh4EditButtonClick
    Columns = <
      item
        ButtonStyle = cbsEllipsis
        DynProps = <>
        EditButtons = <>
        FieldName = 'stopcode'
        Footers = <>
      end
      item
        Color = clInfoBk
        DynProps = <>
        EditButtons = <>
        FieldName = 'stopname'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'date1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'time1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'date2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'time2'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object rgp0: TRadioGroup [38]
    Left = 8
    Top = 48
    Width = 225
    Height = 37
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      'T1'
      'T2'
      'T3'
      'T4'
      'T5')
    TabOrder = 0
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 352
    Top = 348
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS1BeforePost
    OnNewRecord = CDS1NewRecord
    Left = 324
    Top = 348
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDS2AfterOpen
    BeforePost = CDS2BeforePost
    Left = 320
    Top = 468
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 348
    Top = 468
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDS3BeforePost
    Left = 504
    Top = 348
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 532
    Top = 348
  end
  object CDS4: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDS4AfterOpen
    BeforePost = CDS4BeforePost
    OnNewRecord = CDS4NewRecord
    Left = 504
    Top = 488
  end
  object DS4: TDataSource
    DataSet = CDS4
    Left = 532
    Top = 488
  end
  object qceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 664
    Top = 252
  end
  object dmaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 692
    Top = 252
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu1Popup
    Left = 380
    Top = 348
    object N1: TMenuItem
      Caption = #21034#38500
      OnClick = N1Click
    end
  end
  object PopupMenu2: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu2Popup
    Left = 376
    Top = 468
    object N2: TMenuItem
      Caption = #21034#38500
      OnClick = N2Click
    end
  end
  object PopupMenu3: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu3Popup
    Left = 560
    Top = 348
    object N3: TMenuItem
      Caption = #21034#38500
      OnClick = N3Click
    end
  end
  object PopupMenu4: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu4Popup
    Left = 560
    Top = 488
    object N4: TMenuItem
      Caption = #21034#38500
      OnClick = N4Click
    end
  end
  object CDSX: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 696
    Top = 96
  end
  object shbCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 696
    Top = 124
  end
  object tc_silCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 724
    Top = 124
  end
  object tc_sikCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 752
    Top = 124
  end
  object tc_siaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 124
  end
  object tc_siyCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 808
    Top = 124
  end
  object tc_shbCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 836
    Top = 124
  end
end
