inherited FrmDLII020_lotgo: TFrmDLII020_lotgo
  Left = 458
  Top = 214
  Width = 1050
  Height = 500
  Caption = #25209#34399#25291#36681
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 924
    Height = 462
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 924
    Height = 462
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 0
      Width = 924
      Height = 242
      Align = alClient
      DataSource = DS1
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
          FieldName = 'indate'
          Footers = <>
          ReadOnly = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'saleno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'saleitem'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'odate'
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
          ReadOnly = False
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'custshort'
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
          FieldName = 'pname'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'ordercount'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'notcount1'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 242
      Width = 924
      Height = 220
      Align = alBottom
      DataSource = DS2
      DynProps = <>
      FooterParams.Color = clWindow
      GridLineParams.VertEmptySpaceStyle = dessNonEh
      IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
      ReadOnly = True
      TabOrder = 1
      Columns = <
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'stkplace'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'stkarea'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'manfac'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'manfac1'
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
          FieldName = 'sflagx'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'jflagx'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'jremark'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 76
    Top = 272
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS1AfterScroll
    Left = 48
    Top = 272
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 300
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 76
    Top = 300
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 136
    Top = 276
  end
end
