inherited FrmIPQCT624: TFrmIPQCT624
  Caption = 'FrmIPQCT624'
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 220
    Top = 44
    Height = 451
  end
  inherited DBGridEh1: TDBGridEh
    Width = 220
    Align = alLeft
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ver'
        Footers = <>
      end>
  end
  object Panel2: TPanel [5]
    Left = 223
    Top = 44
    Width = 740
    Height = 451
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 60
      Width = 740
      Height = 391
      Align = alClient
      DataSource = DS2
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
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'sno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'item'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'kg'
          Footer.ValueType = fvtSum
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'diff'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 740
      Height = 60
      Align = alTop
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object Label1: TLabel
        Left = 68
        Top = 23
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object Edit3: TEdit
        Left = 104
        Top = 20
        Width = 100
        Height = 21
        TabOrder = 0
        Text = '1'
      end
      object BitBtn1: TBitBtn
        Left = 210
        Top = 16
        Width = 75
        Height = 25
        Caption = 'BitBtn1'
        TabOrder = 1
        OnClick = BitBtn1Click
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 849
    Top = 325
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 877
    Top = 325
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 764
    Top = 12
  end
end
