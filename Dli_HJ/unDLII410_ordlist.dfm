inherited FrmDLII410_ordlist: TFrmDLII410_ordlist
  Width = 1100
  Height = 600
  Caption = #20986#36008#25490#31243#26126#32048
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 974
    Height = 562
    object btn_export: TBitBtn
      Left = 10
      Top = 72
      Width = 90
      Height = 25
      Caption = #21295#20986'Excel'
      TabOrder = 2
      OnClick = btn_exportClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFF00000000000000006666007777777706EEF0FF0E6666606EE
        F0FFFF0E66606EEF0FFFFFF0E606EEF0FFFFFFFF006EEF0FFFFFFFFF06EEF00F
        FFFFFFF06EEF0670FFFFFF06EEF0E6670FFFF06EEF0F0E6670FF0FFFF0FFF0EE
        EE0F00000FFFFF00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
  end
  object pnl100: TPanel [1]
    Left = 0
    Top = 0
    Width = 974
    Height = 562
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnl101: TPanel
      Left = 0
      Top = 0
      Width = 974
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 75
        Top = 13
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 364
        Top = 14
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Dtp: TDateTimePicker
        Left = 113
        Top = 10
        Width = 100
        Height = 21
        Date = 42755.000000000000000000
        Time = 42755.000000000000000000
        TabOrder = 0
      end
      object btn_query: TBitBtn
        Left = 215
        Top = 8
        Width = 40
        Height = 25
        Caption = #26597#35426
        TabOrder = 1
        OnClick = btn_queryClick
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 41
      Width = 974
      Height = 521
      Align = alClient
      DataSource = DS1
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      TabOrder = 1
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
  end
  object DS1: TDataSource
    Left = 133
    Top = 317
  end
end
