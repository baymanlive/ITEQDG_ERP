inherited FrmDLII433: TFrmDLII433
  Caption = 'FrmDLII433'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DBGridEh1: TDBGridEh
    Width = 300
    Align = alLeft
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'iuser'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'idate'
        Footers = <>
      end>
  end
  object Panel2: TPanel [4]
    Left = 300
    Top = 44
    Width = 663
    Height = 451
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 0
      Width = 663
      Height = 201
      Align = alClient
      DataSource = DS2
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      TabOrder = 0
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'kb'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sno'
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
          FieldName = 'pno'
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
          FieldName = 'iuser'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'idate'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 201
      Width = 663
      Height = 250
      Align = alBottom
      BevelInner = bvSpace
      BevelOuter = bvLowered
      TabOrder = 1
      object saleno: TLabel
        Tag = 1
        Left = 252
        Top = 5
        Width = 30
        Height = 13
        Caption = 'saleno'
      end
      object kb: TLabel
        Tag = 1
        Left = 20
        Top = 5
        Width = 12
        Height = 13
        Caption = 'kb'
      end
      object Memo2: TMemo
        Left = 252
        Top = 20
        Width = 185
        Height = 220
        ReadOnly = True
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 20
        Top = 20
        Width = 185
        Height = 220
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 857
    Top = 81
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 885
    Top = 81
  end
end
