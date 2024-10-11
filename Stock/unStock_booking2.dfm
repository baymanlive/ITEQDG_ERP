inherited FrmStock_booking2: TFrmStock_booking2
  Width = 900
  Height = 500
  Caption = #24235#23384#36039#26009
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 774
    Height = 461
    Visible = False
  end
  object DBGridEh1: TDBGridEh [1]
    Left = 0
    Top = 0
    Width = 774
    Height = 461
    Align = alClient
    DataSource = DataSource1
    DynProps = <>
    FooterRowCount = 1
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    SumList.Active = True
    TabOrder = 1
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'dbtype'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img01'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img02'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img03'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img04'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'img10'
        Footer.ValueType = fvtSum
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'bookingqty'
        Footer.ValueType = fvtSum
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img01'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img03'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img04'
        Footers = <>
        ReadOnly = True
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ta_img05'
        Footers = <>
        ReadOnly = True
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object DataSource1: TDataSource
    DataSet = CDS
    Left = 116
    Top = 268
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDSBeforeInsert
    BeforeEdit = CDSBeforeEdit
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
    AfterScroll = CDSAfterScroll
    Left = 117
    Top = 239
  end
end
