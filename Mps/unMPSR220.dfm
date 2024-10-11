inherited FrmMPSR220: TFrmMPSR220
  Left = 193
  Caption = 'FrmMPSR220'
  ClientWidth = 962
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 242
    Width = 962
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inherited ToolBar: TToolBar
    Width = 962
    ButtonWidth = 98
    object btn_mpsr220B: TToolButton
      Left = 364
      Top = 0
      Caption = #24235#23384#33287#26410#20132#29376#27841
      ImageIndex = 61
      OnClick = btn_mpsr220BClick
    end
    object btn_mpsr220A: TToolButton
      Left = 462
      Top = 0
      AutoSize = True
      Caption = #35336#31639
      ImageIndex = 50
      OnClick = btn_mpsr220AClick
    end
    object ToolButton100: TToolButton
      Left = 499
      Top = 0
      Width = 23
      AutoSize = True
      Caption = 'ToolButton100'
      ImageIndex = 51
      Style = tbsSeparator
    end
  end
  inherited PnlBottom: TPanel
    Width = 962
  end
  inherited Panel1: TPanel
    Width = 962
  end
  inherited DBGridEh1: TDBGridEh
    Left = 52
    Width = 910
    Height = 198
    PopupMenu = PopupMenu1
    OnCellClick = DBGridEh1CellClick
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono'
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
        FieldName = 'sqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stealno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'currentboiler'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'premark'
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
        FieldName = 'custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custom'
        Footers = <>
      end>
  end
  object DBGridEh2: TDBGridEh [5]
    Left = 0
    Top = 245
    Width = 962
    Height = 250
    Align = alBottom
    DataSource = DS2
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    TabOrder = 4
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sfa03'
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
        FieldName = 'ta_img04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img05'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel3: TPanel [6]
    Left = 0
    Top = 44
    Width = 52
    Height = 198
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 5
    object RG1: TRadioGroup
      Left = 2
      Top = 0
      Width = 48
      Height = 200
      TabOrder = 0
      OnClick = RG1Click
    end
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 780
    Top = 288
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 752
    Top = 288
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PopupMenu1Popup
    Left = 192
    Top = 180
    object N5: TMenuItem
      Caption = #27492#37707#36984#20013
      OnClick = N5Click
    end
    object N1: TMenuItem
      Caption = #30070#22825#36984#20013
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #20840#37096#36984#20013
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #21462#28040#36984#20013
      OnClick = N4Click
    end
  end
end
