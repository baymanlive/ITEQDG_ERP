inherited FrmDLII030: TFrmDLII030
  Caption = 'FrmDLII030'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_delete: TToolButton
      Left = 364
      Top = 0
      Hint = '[F4]'#21034#38500#25209#34399#36039#26009
      AutoSize = True
      Caption = #21034#38500
      ImageIndex = 6
      OnClick = btn_deleteClick
    end
  end
  inherited PnlBottom: TPanel
    TabOrder = 3
  end
  inherited Panel1: TPanel
    TabOrder = 4
  end
  inherited DBGridEh1: TDBGridEh
    Height = 231
    TabOrder = 1
    OnCellClick = DBGridEh1CellClick
    OnDblClick = DBGridEh1DblClick
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'coc_ans'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Indate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Saleno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Saleitem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Odate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Ddate'
        Footers = <>
      end
      item
        DisplayFormat = 'HH:NN'
        DynProps = <>
        EditButtons = <>
        FieldName = 'Stime'
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
        FieldName = 'Orderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Orderitem'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Pname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sizes'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Longitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Latitude'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Notcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Delcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Jcount_old'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Jcount_new'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Bcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Coccount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Chkcount'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Coc_no'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark1'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark2'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark3'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark4'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark5'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SaleRemark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'StkRemark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Units'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custorderno'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custprono'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Custname'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Remark'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'SendAddr'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ErrorCause'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ErrorDept'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Kg'
        Footers = <>
      end>
  end
  object PCL2: TPageControl [4]
    Left = 0
    Top = 275
    Width = 963
    Height = 220
    ActivePage = TabSheet2
    Align = alBottom
    TabOrder = 2
    object TabSheet2: TTabSheet
      Caption = #25209#34399#36039#26009
      ImageIndex = 1
      DesignSize = (
        955
        192)
      object DBGridEh2: TDBGridEh
        Left = 4
        Top = 4
        Width = 947
        Height = 183
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = DS2
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'manfac'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qty'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #20108#32173#30908#36039#26009
      ImageIndex = 1
      DesignSize = (
        955
        192)
      object DBGridEh3: TDBGridEh
        Left = 4
        Top = 4
        Width = 947
        Height = 183
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = DS3
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'sno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'qrcode'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  inherited CDS: TClientDataSet
    BeforeInsert = CDSBeforeInsert
    AfterPost = CDSAfterPost
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS2BeforeInsert
    BeforeEdit = CDS2BeforeEdit
    AfterPost = CDS2AfterPost
    Left = 777
    Top = 405
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 806
    Top = 405
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = CDS3BeforeInsert
    BeforeEdit = CDS3BeforeEdit
    AfterPost = CDS3AfterPost
    Left = 777
    Top = 433
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 806
    Top = 433
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 640
    Top = 12
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 672
    Top = 12
  end
end
