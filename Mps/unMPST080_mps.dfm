inherited FrmMPST080_mps: TFrmMPST080_mps
  Width = 1100
  Height = 600
  Caption = #25490#31243#36039#26009
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 974
    Height = 561
  end
  object pnl101: TPanel [1]
    Left = 0
    Top = 0
    Width = 974
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnl102: TPanel
      Left = 0
      Top = 0
      Width = 974
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblsdate: TLabel
        Left = 35
        Top = 16
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = #29983#29986#26085#26399#65306
      end
      object lblto: TLabel
        Tag = 1
        Left = 192
        Top = 16
        Width = 13
        Height = 13
        Alignment = taRightJustify
        Caption = #33267
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
        Width = 289
        Height = 36
        TabOrder = 2
        OnClick = RGClick
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 45
      Width = 974
      Height = 516
      Align = alClient
      DataSource = DS
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      TabOrder = 1
      OnGetCellParams = DBGridEh1GetCellParams
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
          FieldName = 'currentboiler'
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
          FieldName = 'sqty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'adate_new'
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
          FieldName = 'stealno'
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
          FieldName = 'orderqty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'orderno2'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'orderitem2'
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
          FieldName = 'pnlsize1'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'pnlsize2'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
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
