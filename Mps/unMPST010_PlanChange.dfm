inherited FrmPlanChange: TFrmPlanChange
  Width = 776
  Height = 432
  ActiveControl = Edit1
  Caption = #30064#24120#35336#21010#35722#26356'-'#29983#29986#26085#26399#12289#37707#27425#37325#25972
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 60
    Top = 79
    Width = 91
    Height = 13
    Alignment = taRightJustify
    Caption = #23526#38555#29983#29986#37707#25976#65306
  end
  object Label2: TLabel [1]
    Left = 60
    Top = 49
    Width = 91
    Height = 13
    Alignment = taRightJustify
    Caption = #30064#24120#29983#29986#26085#26399#65306
  end
  object Label3: TLabel [2]
    Left = 281
    Top = 47
    Width = 32
    Height = 13
    Caption = 'Label3'
  end
  object Label4: TLabel [3]
    Left = 59
    Top = 120
    Width = 182
    Height = 13
    Caption = #37325#25972#24460#35531#22312#20316#26989#20013#37325#26032#26597#35426#36039#26009
  end
  inherited PnlRight: TPanel
    Left = 650
    Height = 393
    TabOrder = 2
    inherited btn_ok: TBitBtn
      Top = 40
    end
    inherited btn_quit: TBitBtn
      Top = 70
    end
    object btn_export: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'btn_export'
      TabOrder = 2
      OnClick = btn_exportClick
    end
  end
  object Edit1: TEdit [5]
    Left = 155
    Top = 75
    Width = 120
    Height = 21
    Hint = #35531#36664#20837#25976#23383
    TabOrder = 1
    Text = 'Edit1'
  end
  object Dtp: TDateTimePicker [6]
    Left = 155
    Top = 45
    Width = 120
    Height = 21
    Hint = #35531#36984#25799#29983#29986#26085#26399
    Date = 42108.000000000000000000
    Time = 42108.000000000000000000
    TabOrder = 0
    OnChange = DtpChange
  end
  object DBGridEh1: TDBGridEh [7]
    Left = 350
    Top = 16
    Width = 280
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DS
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 3
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'machine'
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
        FieldName = 'cnt'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 244
    Top = 212
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 216
    Top = 212
  end
end
