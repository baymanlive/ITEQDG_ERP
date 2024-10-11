inherited FrmStock: TFrmStock
  Left = 300
  Top = 108
  Width = 1311
  Height = 818
  Caption = #24235#23384#33287#26410#20132#29376#27841
  WindowState = wsMaximized
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 321
    Top = 40
    Height = 721
  end
  inherited PnlRight: TPanel
    Left = 1185
    Top = 40
    Height = 721
    TabOrder = 1
  end
  object DBGridEh1: TDBGridEh [2]
    Left = 0
    Top = 40
    Width = 321
    Height = 721
    Align = alLeft
    DataSource = DS1
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
    OnCellClick = DBGridEh1CellClick
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'dbtype'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img02'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img10'
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bookingqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img01'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img03'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img05'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cjremark'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 0
    Width = 1295
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblpno: TLabel
      Left = 54
      Top = 14
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblpno'
    end
    object CheckBoxT: TCheckBox
      Left = 310
      Top = 11
      Width = 33
      Height = 17
      Caption = 'T'
      TabOrder = 0
    end
    object Edit3: TEdit
      Left = 88
      Top = 10
      Width = 177
      Height = 21
      Hint = #29289#21697#26009#34399
      TabOrder = 1
    end
    object CheckBoxE: TCheckBox
      Left = 276
      Top = 11
      Width = 33
      Height = 17
      Caption = 'E'
      TabOrder = 2
    end
    object CheckBoxB: TCheckBox
      Left = 344
      Top = 11
      Width = 33
      Height = 17
      Caption = 'B'
      TabOrder = 3
    end
    object CheckBoxR: TCheckBox
      Left = 378
      Top = 11
      Width = 33
      Height = 17
      Caption = 'R'
      TabOrder = 4
    end
    object CheckBoxP: TCheckBox
      Left = 414
      Top = 11
      Width = 33
      Height = 17
      Caption = 'P'
      TabOrder = 5
    end
    object CheckBoxQ: TCheckBox
      Left = 450
      Top = 11
      Width = 33
      Height = 17
      Caption = 'Q'
      TabOrder = 6
    end
    object CheckBoxM: TCheckBox
      Left = 486
      Top = 11
      Width = 33
      Height = 17
      Caption = 'M'
      TabOrder = 7
    end
    object CheckBoxN: TCheckBox
      Left = 522
      Top = 11
      Width = 33
      Height = 17
      Caption = 'N'
      TabOrder = 8
    end
    object btn_query: TBitBtn
      Left = 610
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btn_query'
      TabOrder = 10
      OnClick = btn_queryClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFF00000FFF00000FFF0F000FFF0F000FFF0F000FFF0F000FFF000000F00000
        0FFF0F0000F0F0000FFF0F000000F0000FFFF0000FF00000444FFF000FFF000F
        444FFF000FFF000FFFFFFFF0FFFFF0FF44FFFFFFFFFFFFFF44FFFFFFFFFFFFFF
        F44FFFFFFFFFFF4FFF44FFFFFFFFFF444FF4FFFFFFFFFFF44444}
    end
    object BitBtn1: TBitBtn
      Left = 770
      Top = 8
      Width = 70
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 12
      OnClick = BitBtn1Click
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFF444
        FFFFFFFFFF0FFFFF4FFFFFFFF00FFFFF4FFFFFFF030FFF44444FFFF0330FFFF4
        44FFF0033300000F4FFFFF03330FF0FFFFFFFF03330FF0FFFFFFFF03330FF0FF
        FFFFFF03330FF0FFFFFFFF03330FF0FFFFFFFF03330FF0FFFFFFFF0330FFF0FF
        FFFFFF030FFFF0FFFFFFFF00FFFFF0FFFFFFFF00000000FFFFFF}
    end
    object CheckBox1: TCheckBox
      Left = 560
      Top = 11
      Width = 33
      Height = 17
      Caption = '1'
      TabOrder = 9
    end
    object BitBtn2: TBitBtn
      Tag = 1
      Left = 690
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btn_query'
      TabOrder = 11
      OnClick = btn_queryClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFF00000FFF00000FFF0F000FFF0F000FFF0F000FFF0F000FFF000000F00000
        0FFF0F0000F0F0000FFF0F000000F0000FFFF0000FF00000444FFF000FFF000F
        444FFF000FFF000FFFFFFFF0FFFFF0FF44FFFFFFFFFFFFFF44FFFFFFFFFFFFFF
        F44FFFFFFFFFFF4FFF44FFFFFFFFFF444FF4FFFFFFFFFFF44444}
    end
  end
  object StatusBar1: TStatusBar [4]
    Left = 0
    Top = 761
    Width = 1295
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object Panel2: TPanel [5]
    Left = 324
    Top = 40
    Width = 861
    Height = 721
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 0
      Width = 861
      Height = 243
      Align = alClient
      DataSource = DS2
      DynProps = <>
      FooterRowCount = 1
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      PopupMenu = PopupMenu1
      ReadOnly = True
      SumList.Active = True
      TabOrder = 0
      OnDblClick = DBGridEh2DblClick
      OnTitleClick = DBGridEh2TitleClick
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oeb04'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oea01'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oeb03'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oea04'
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
          FieldName = 'qty'
          Footer.ValueType = fvtSum
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sqty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'tqty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'bookingqty'
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
          FieldName = 'cdate'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'oeb05'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ta_oeb01'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ta_oeb02'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'dbtype'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh3: TDBGridEh
      Left = 0
      Top = 411
      Width = 861
      Height = 155
      Align = alBottom
      DataSource = DS3
      DynProps = <>
      FooterRowCount = 1
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      SumList.Active = True
      TabOrder = 1
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sdate'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'stype'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'materialno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'materialno1'
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
          FieldName = 'sqty'
          Footer.ValueType = fvtSum
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh4: TDBGridEh
      Left = 0
      Top = 566
      Width = 861
      Height = 155
      Align = alBottom
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
      TabOrder = 2
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'srcid'
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
          FieldName = 'purqty'
          Footer.ValueType = fvtSum
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'qty'
          Footer.ValueType = fvtSum
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'date4'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'date6'
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
          FieldName = 'adate_new'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh5: TDBGridEh
      Left = 0
      Top = 243
      Width = 861
      Height = 168
      Align = alBottom
      DataSource = DS5
      DynProps = <>
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
      TabOrder = 3
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'gid'
          Footers = <>
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'uuid'
          Footers = <>
          Visible = False
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
          FieldName = 'materialno'
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
          FieldName = 'custom'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'orderQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'dbtype'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'wareHouseNo'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'materialno1'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'storageNo'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'batchNo'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'stockQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'isActive'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'orderBu'
          Footers = <>
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'rStockQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'custno1'
          Footers = <>
          Visible = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'custom1'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
  object DS2: TDataSource
    Left = 84
    Top = 273
  end
  object DS3: TDataSource
    Left = 112
    Top = 273
  end
  object DS4: TDataSource
    Left = 140
    Top = 273
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu1Popup
    Left = 168
    Top = 272
    object N1: TMenuItem
      Caption = 'booking'
      OnClick = N1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 48
    Top = 356
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 80
    Top = 356
  end
  object DS5: TDataSource
    Left = 756
    Top = 368
  end
end
