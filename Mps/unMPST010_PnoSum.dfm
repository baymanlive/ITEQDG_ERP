inherited FrmMPST010_PnoSum: TFrmMPST010_PnoSum
  Width = 672
  Height = 547
  Caption = #27599#22825#25490#35069#37327#32113#35336#34920
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 546
    Top = 41
    Height = 467
    TabOrder = 1
    inherited btn_ok: TBitBtn
      Glyph.Data = {00000000}
    end
    inherited btn_quit: TBitBtn
      Top = 70
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Caption = 'toxls'
      TabOrder = 2
      OnClick = BitBtn1Click
      NumGlyphs = 2
    end
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 41
    Width = 546
    Height = 467
    Align = alClient
    DataSource = DS
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
        FieldName = 'sqty'
        Footer.ValueType = fvtSum
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 656
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 174
      Top = 13
      Width = 32
      Height = 13
      Alignment = taCenter
      Caption = 'Label2'
    end
    object Label1: TLabel
      Left = 58
      Top = 13
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
    object Label3: TLabel
      Left = 304
      Top = 13
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label3'
    end
    object rgp2: TRadioGroup
      Left = 495
      Top = 0
      Width = 150
      Height = 34
      Columns = 3
      ItemIndex = 2
      Items.Strings = (
        'DG'
        'GZ'
        'ALL')
      TabOrder = 3
    end
    object dtp1: TDateTimePicker
      Left = 90
      Top = 10
      Width = 80
      Height = 21
      Date = 42640.000000000000000000
      Time = 42640.000000000000000000
      TabOrder = 0
    end
    object dtp2: TDateTimePicker
      Left = 200
      Top = 10
      Width = 80
      Height = 21
      Date = 42640.000000000000000000
      Time = 42640.000000000000000000
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 340
      Top = 10
      Width = 150
      Height = 21
      TabOrder = 2
      Text = 'E6,TF'
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 56
    Top = 273
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 301
  end
end
