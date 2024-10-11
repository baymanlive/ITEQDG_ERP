inherited FrmMPST040_IndateChg: TFrmMPST040_IndateChg
  Width = 1000
  Height = 500
  Caption = #26356#25913#20986#36008#26085#26399
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 874
    Top = 40
    Height = 422
    TabOrder = 1
    Visible = False
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 40
    Width = 874
    Height = 422
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
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Indate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Orderitem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Stime'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custshort'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Notcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Chkcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Units'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 984
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 54
      Top = 12
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 306
      Top = 12
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label2'
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
    object Dtp2: TDateTimePicker
      Left = 340
      Top = 8
      Width = 90
      Height = 21
      Date = 42452.000000000000000000
      Time = 42452.000000000000000000
      TabOrder = 1
    end
    object btn_query: TBitBtn
      Left = 180
      Top = 5
      Width = 55
      Height = 25
      Caption = #26597#35426
      TabOrder = 2
      OnClick = btn_queryClick
    end
    object btn1: TBitBtn
      Left = 432
      Top = 5
      Width = 55
      Height = 25
      Caption = #26356#26032
      TabOrder = 3
      OnClick = btn1Click
    end
  end
  object DS1: TDataSource
    Left = 56
    Top = 273
  end
end
