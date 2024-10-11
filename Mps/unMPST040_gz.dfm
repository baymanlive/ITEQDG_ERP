inherited FrmMPST040_gz: TFrmMPST040_gz
  Left = 333
  Top = 148
  Width = 1050
  Height = 600
  Caption = #24291#24030#29983#29986#25490#31243'-'#20986#36008#34920
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 932
    Height = 573
    inherited btn_ok: TBitBtn
      Top = 70
      TabOrder = 1
    end
    inherited btn_quit: TBitBtn
      Top = 100
      TabOrder = 2
    end
    object Btn1: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'btn1'
      TabOrder = 0
      OnClick = Btn1Click
      NumGlyphs = 2
    end
    object Btn2: TBitBtn
      Tag = 1
      Left = 10
      Top = 40
      Width = 90
      Height = 25
      Caption = 'btn1'
      TabOrder = 3
      OnClick = Btn1Click
      NumGlyphs = 2
    end
  end
  object PCL: TPageControl [1]
    Left = 0
    Top = 0
    Width = 932
    Height = 573
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 924
        Height = 545
        Align = alClient
        DataSource = DS1
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        OnCellClick = DBGridEh1CellClick
        OnGetCellParams = DBGridEh1GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'select'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'currentboiler'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            ReadOnly = True
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
            FieldName = 'adate_new'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custom'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'stealno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno1'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize1'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
            ReadOnly = True
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 924
        Height = 545
        Align = alClient
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        OnCellClick = DBGridEh2CellClick
        OnGetCellParams = DBGridEh2GetCellParams
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'select'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'machine'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sdate'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'wono'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sqty'
            Footers = <>
            ReadOnly = True
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
            FieldName = 'adate_new'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custom'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'breadth'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'fiber'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'premark'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderqty'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderno2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'orderitem2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno1'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize1'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pnlsize2'
            Footers = <>
            ReadOnly = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'edate'
            Footers = <>
            ReadOnly = True
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 916
        Height = 533
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 124
    Top = 76
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS1BeforeInsert
    Left = 152
    Top = 76
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 124
    Top = 112
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    Left = 152
    Top = 112
  end
end
