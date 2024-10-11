inherited FrmMPST040_ordlist: TFrmMPST040_ordlist
  Width = 1110
  Height = 600
  Caption = #26410#20132#26126#32048
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 992
    Top = 38
    Height = 533
    TabOrder = 1
    Visible = False
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 38
    Width = 992
    Height = 533
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
    OnKeyDown = DBGridEh1KeyDown
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oea02'
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
        FieldName = 'ptype'
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
        FieldName = 'oeb04'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb06'
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
        FieldName = 'struct'
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
        FieldName = 'oeb12'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb24'
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
        FieldName = 'oeb15'
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
        FieldName = 'aremark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bremark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stkremark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oea10'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oeb11'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_oeb10'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'oao06'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ocd221'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object ToolBar: TToolBar [2]
    Left = 0
    Top = 0
    Width = 1102
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 59
    Flat = True
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 2
    Wrapable = False
    object btn_query: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #26597#35426
      ImageIndex = 11
      OnClick = btn_queryClick
    end
    object btn_export: TToolButton
      Left = 37
      Top = 0
      AutoSize = True
      Caption = #21295#20986'Excel'
      ImageIndex = 10
      OnClick = btn_exportClick
    end
    object btn1: TToolButton
      Left = 100
      Top = 0
      AutoSize = True
      Caption = #32080#26696
      ImageIndex = 60
      OnClick = btn1Click
    end
    object btn2: TToolButton
      Left = 137
      Top = 0
      AutoSize = True
      Caption = #26356#26032#24235#23384
      ImageIndex = 58
      OnClick = btn2Click
    end
    object ToolButton5: TToolButton
      Left = 200
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn3: TToolButton
      Left = 208
      Top = 0
      AutoSize = True
      Caption = #38626#38283
      ImageIndex = 19
      OnClick = btn_quitClick
    end
    object pnlmsg: TPanel
      Left = 245
      Top = 0
      Width = 368
      Height = 36
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlmsg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
  object DS1: TDataSource
    Left = 132
    Top = 317
  end
end
