inherited FrmMPST040_pnlwono: TFrmMPST040_pnlwono
  Width = 1110
  Height = 600
  Caption = #23567#26495#24037#21934#20449#24687#26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 984
    Top = 40
    Height = 522
    TabOrder = 1
    inherited btn_ok: TBitBtn
      Left = 6
      Top = 100
      Width = 100
      TabOrder = 3
      Visible = False
    end
    inherited btn_quit: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      TabOrder = 2
    end
    object btn1: TBitBtn
      Tag = 3
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Hint = #35336#31639#24235#23384
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 0
      OnClick = btn1Click
      NumGlyphs = 2
    end
    object btn_export: TBitBtn
      Tag = 3
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Caption = #21295#20986
      TabOrder = 1
      OnClick = btn_exportClick
      NumGlyphs = 2
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 40
    Width = 984
    Height = 522
    Align = alClient
    DataSource = DS1
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    TabOrder = 0
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'orderitem'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'custshort'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'longitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'latitude'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'notcount1'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'chkcount'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remark5'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stkremark'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'wono'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cqty'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'state'
        Footers = <>
        ReadOnly = True
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 1094
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblindate: TLabel
      Left = 46
      Top = 12
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblindate'
    end
    object Label1: TLabel
      Left = 504
      Top = 16
      Width = 32
      Height = 13
      Caption = 'Label1'
    end
    object Dtp1: TDateTimePicker
      Left = 88
      Top = 8
      Width = 90
      Height = 21
      Date = 42452.000000000000000000
      Time = 42452.000000000000000000
      TabOrder = 0
    end
    object btn_query: TBitBtn
      Left = 180
      Top = 6
      Width = 55
      Height = 25
      Caption = #26597#35426
      TabOrder = 1
      OnClick = btn_queryClick
    end
    object rgp: TRadioGroup
      Left = 264
      Top = 0
      Width = 200
      Height = 34
      Columns = 3
      ItemIndex = 2
      Items.Strings = (
        'CCL'
        'PP'
        'ALL')
      TabOrder = 2
      OnClick = rgpClick
    end
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
end
