inherited FrmDLII020: TFrmDLII020
  Caption = 'FrmDLII020'
  PixelsPerInch = 96
  TextHeight = 13
  object PnlRight: TPanel [3]
    Left = 853
    Top = 44
    Width = 110
    Height = 300
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object btn_dlii020A: TBitBtn
      Tag = 2
      Left = 5
      Top = 10
      Width = 100
      Height = 25
      Hint = #23565#36984#20013#30340#24050#30906#35469#30340#21934#25818#29986#29983#20986#36008#21934
      Caption = #29986#29983#20986#36008#21934
      TabOrder = 0
      OnClick = btn_dlii020AClick
      NumGlyphs = 2
    end
    object btn_dlii020B: TBitBtn
      Tag = 2
      Left = 5
      Top = 40
      Width = 100
      Height = 25
      Hint = #26356#25913#20489#24235#12289#20786#20301#12289#25209#34399#12289#25976#37327
      Caption = #26356#25913#20489#20786#25209#25976
      TabOrder = 1
      OnClick = btn_dlii020BClick
      NumGlyphs = 2
    end
    object btn_dlii020C: TBitBtn
      Tag = 2
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Hint = #23565#30070#21069#21934#25818#36914#34892#25286#20998#25976#37327
      Caption = #21934#31558#25286#20998
      TabOrder = 2
      OnClick = btn_dlii020CClick
      NumGlyphs = 2
    end
    object btn_dlii020D: TBitBtn
      Tag = 2
      Left = 5
      Top = 100
      Width = 100
      Height = 25
      Hint = #23565#36984#23450#30340#20986#36008#26085#26399','#24050#29986#29983#20986#36008#21934#19988#26410#20986#23436#36008#30340#21934#25818','#20840#37096#25286#20998
      Caption = #20840#37096#25286#20998
      TabOrder = 3
      OnClick = btn_dlii020DClick
      NumGlyphs = 2
    end
    object btn_dlii020E: TBitBtn
      Tag = 2
      Left = 5
      Top = 130
      Width = 100
      Height = 25
      Hint = #21034#38500#36984#20013#30340#20986#36008#21934#25152#26377#38917#27425','#21034#38500#24460#35531#20316#24290'TipTop'#23565#25033#30340#20986#36008#21934
      Caption = #21034#38500#25972#24373#20986#36008#21934
      TabOrder = 5
      OnClick = btn_dlii020EClick
      NumGlyphs = 2
    end
    object btn_dlii020F: TBitBtn
      Tag = 2
      Left = 5
      Top = 160
      Width = 100
      Height = 25
      Hint = #21034#38500#36984#20013#30340#20986#36008#21934#30070#21069#38917#27425','#21034#38500#24460#35531#26356#25913'TipTop'#23565#25033#30340#20986#36008#21934#38917#27425
      Caption = #21034#38500#21934#38917#20986#36008#21934
      TabOrder = 6
      OnClick = btn_dlii020FClick
      NumGlyphs = 2
    end
    object btn_dlii020G: TBitBtn
      Tag = 2
      Left = 5
      Top = 190
      Width = 100
      Height = 25
      Hint = #21034#38500#36984#20013#30340#25209#34399
      Caption = #21034#38500#25209#34399
      TabOrder = 4
      OnClick = btn_dlii020GClick
      NumGlyphs = 2
    end
    object btn_dlii020H: TBitBtn
      Tag = 3
      Left = 5
      Top = 220
      Width = 100
      Height = 25
      Caption = #20108#32173#30908
      TabOrder = 7
      OnClick = btn_dlii020HClick
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel [4]
    Left = 0
    Top = 44
    Width = 853
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
  end
  inherited DBGridEh1: TDBGridEh
    Width = 853
    Height = 300
    TabOrder = 5
    OnCellClick = DBGridEh1CellClick
    OnDrawColumnCell = DBGridEh1DrawColumnCell
    OnGetCellParams = DBGridEh1GetCellParams
    OnTitleClick = DBGridEh1TitleClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'select'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Prn_ans'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sno'
        Footers = <>
      end
      item
        ButtonStyle = cbsNone
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
        ButtonStyle = cbsNone
        DynProps = <>
        EditButtons = <>
        FieldName = 'Odate'
        Footers = <>
      end
      item
        ButtonStyle = cbsNone
        DynProps = <>
        EditButtons = <>
        FieldName = 'Ddate'
        Footers = <>
      end
      item
        ButtonStyle = cbsNone
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
  object DBGridEh2: TDBGridEh [6]
    Left = 0
    Top = 344
    Width = 963
    Height = 151
    Align = alBottom
    DataSource = DS2
    DynProps = <>
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    TabOrder = 6
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
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'pno'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  inherited CDS: TClientDataSet
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 400
    Top = 152
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 372
    Top = 152
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 740
    Top = 12
  end
end
