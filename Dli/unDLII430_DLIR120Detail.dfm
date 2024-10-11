inherited FrmDLII430_DLIR120Detail: TFrmDLII430_DLIR120Detail
  Width = 1101
  Height = 600
  Caption = #25104#21697#20986#36008#28165#21934
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 975
    Height = 561
    inherited btn_ok: TBitBtn
      Top = 40
      TabOrder = 1
    end
    inherited btn_quit: TBitBtn
      Top = 70
      TabOrder = 2
    end
    object btn_query: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'btn_query'
      TabOrder = 0
      OnClick = btn_queryClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFF00000FFF00000FFF0F000FFF0F000FFF0F000FFF0F000FFF000000F00000
        0FFF0F0000F0F0000FFF0F000000F0000FFFF0000FF00000444FFF000FFF000F
        444FFF000FFF000FFFFFFFF0FFFFF0FF44FFFFFFFFFFFFFF44FFFFFFFFFFFFFF
        F44FFFFFFFFFFF4FFF44FFFFFFFFFF444FF4FFFFFFFFFFF44444}
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 975
    Height = 561
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object DBGridEh2: TDBGridEh
      Left = 0
      Top = 240
      Width = 975
      Height = 321
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
          FieldName = 'kw'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'kb'
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
          FieldName = 'custshort'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'saledate'
          Footers = <>
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
          FieldName = 'sizes'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'longitude'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'latitude'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'thickness'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'totthickness'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'sf'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'totsf'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'totsf1'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'gsf'
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
          FieldName = 'units'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'cashtype'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'kg'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'nw'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'totnw'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'gw'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'tare'
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
          FieldName = 'custorderno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'custprono'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'custname'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'remark'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'zcremark'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 0
      Top = 0
      Width = 975
      Height = 240
      Align = alTop
      DataSource = DS1
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
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'Conf'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Cname'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Cdate'
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
          FieldName = 'CCLQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'PPQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'CCLPnlQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'PPPnlQty'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Carno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Driver'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'Tel'
          Footers = <>
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  inherited ImageList1: TImageList
    Left = 109
    Top = 325
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 80
    Top = 321
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 52
    Top = 321
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS1AfterScroll
    Left = 52
    Top = 349
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 348
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 108
    Top = 352
  end
end
