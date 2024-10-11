inherited FrmIPQCT623: TFrmIPQCT623
  Caption = 'FrmIPQCT623'
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 253
    Width = 963
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  inherited ToolBar: TToolBar
    object btn_garbage: TToolButton
      Left = 364
      Top = 0
      AutoSize = True
      Caption = #28961#25928
      ImageIndex = 7
      OnClick = btn_garbageClick
    end
  end
  inherited DBGridEh1: TDBGridEh
    Height = 209
    OnGetCellParams = DBGridEh1GetCellParams
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
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'lot'
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
        FieldName = 'sg1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sg1_std'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sg2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sg2_std'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sg3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'sg3_std'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'niandu'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ludaiqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'c13_3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spos'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'spos_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'temperature'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'remainlot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'addqty'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'addsg'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't1_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't2_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't3_time'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 't4_time'
        Footers = <>
      end>
  end
  object DBGridEh2: TDBGridEh [5]
    Left = 0
    Top = 256
    Width = 963
    Height = 239
    Align = alBottom
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
    TabOrder = 4
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
        FieldName = 'listpno'
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
        FieldName = 'keep'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'diff'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'srcpno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'in_kg'
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'srclot'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'stime'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'uname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'istext'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
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
    Left = 780
    Top = 12
  end
end
