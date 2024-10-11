inherited FrmDLIR120_ConfDetail: TFrmDLIR120_ConfDetail
  Left = 389
  Top = 222
  Width = 1100
  Height = 600
  Caption = #25104#21697#20986#36008#28165#21934
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 974
    Top = 40
    Height = 522
    Visible = False
    inherited btn_ok: TBitBtn
      TabOrder = 1
    end
    inherited btn_quit: TBitBtn
      TabOrder = 0
    end
  end
  inherited PCL: TPageControl
    Top = 40
    Width = 974
    Height = 522
    inherited TabSheet1: TTabSheet
      object Splitter1: TSplitter
        Left = 0
        Top = 240
        Width = 966
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 243
        Width = 966
        Height = 251
        Align = alClient
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
            FieldName = 'price'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'amt'
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
        Width = 966
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
        TabOrder = 0
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
    object TabSheet2: TTabSheet
      Caption = #20551#26399#35373#23450
      ImageIndex = 1
      object Monday: TLabel
        Left = 113
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#19968
      end
      object Tuesday: TLabel
        Left = 183
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#20108
      end
      object Wednesday: TLabel
        Left = 253
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#19977
      end
      object Thurday: TLabel
        Left = 323
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#22235
      end
      object Friday: TLabel
        Left = 393
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#20116
      end
      object Saturday: TLabel
        Left = 463
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#20845
      end
      object Sunday: TLabel
        Left = 533
        Top = 30
        Width = 39
        Height = 13
        Alignment = taCenter
        Caption = #26143#26399#26085
      end
      object Month: TLabel
        Left = 48
        Top = 30
        Width = 26
        Height = 13
        Caption = #26376#20221
      end
      object lblhint: TLabel
        Left = 110
        Top = 256
        Width = 16
        Height = 16
        Caption = 'xx'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = #26032#32048#26126#39636
        Font.Style = []
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 110
        Top = 60
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 1
        OnDblClick = Edit1DblClick
      end
      object Edit2: TEdit
        Left = 180
        Top = 60
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 2
        OnDblClick = Edit1DblClick
      end
      object Edit3: TEdit
        Left = 250
        Top = 60
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 3
        OnDblClick = Edit1DblClick
      end
      object Edit4: TEdit
        Left = 320
        Top = 60
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 4
        OnDblClick = Edit1DblClick
      end
      object Edit5: TEdit
        Left = 390
        Top = 60
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 5
        OnDblClick = Edit1DblClick
      end
      object Edit6: TEdit
        Left = 460
        Top = 60
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 6
      end
      object Edit7: TEdit
        Left = 530
        Top = 60
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 7
      end
      object Edit8: TEdit
        Left = 110
        Top = 90
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 8
        OnDblClick = Edit1DblClick
      end
      object Edit9: TEdit
        Left = 180
        Top = 90
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 9
        OnDblClick = Edit1DblClick
      end
      object Edit10: TEdit
        Left = 250
        Top = 90
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 10
        OnDblClick = Edit1DblClick
      end
      object Edit11: TEdit
        Left = 320
        Top = 90
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 11
        OnDblClick = Edit1DblClick
      end
      object Edit12: TEdit
        Left = 390
        Top = 90
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 12
        OnDblClick = Edit1DblClick
      end
      object Edit13: TEdit
        Left = 460
        Top = 90
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 13
      end
      object Edit14: TEdit
        Left = 530
        Top = 90
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 14
      end
      object Edit15: TEdit
        Left = 110
        Top = 120
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 15
        OnDblClick = Edit1DblClick
      end
      object Edit16: TEdit
        Left = 180
        Top = 120
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 16
        OnDblClick = Edit1DblClick
      end
      object Edit17: TEdit
        Left = 250
        Top = 120
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 17
        OnDblClick = Edit1DblClick
      end
      object Edit18: TEdit
        Left = 320
        Top = 120
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 18
        OnDblClick = Edit1DblClick
      end
      object Edit19: TEdit
        Left = 390
        Top = 120
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 19
        OnDblClick = Edit1DblClick
      end
      object Edit20: TEdit
        Left = 460
        Top = 120
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 20
      end
      object Edit21: TEdit
        Left = 530
        Top = 120
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 21
      end
      object Edit22: TEdit
        Left = 110
        Top = 150
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 22
        OnDblClick = Edit1DblClick
      end
      object Edit23: TEdit
        Left = 180
        Top = 150
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 23
        OnDblClick = Edit1DblClick
      end
      object Edit24: TEdit
        Left = 250
        Top = 150
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 24
        OnDblClick = Edit1DblClick
      end
      object Edit25: TEdit
        Left = 320
        Top = 150
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 25
        OnDblClick = Edit1DblClick
      end
      object Edit26: TEdit
        Left = 390
        Top = 150
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 26
        OnDblClick = Edit1DblClick
      end
      object Edit27: TEdit
        Left = 460
        Top = 150
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 27
      end
      object Edit28: TEdit
        Left = 530
        Top = 150
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 28
      end
      object Edit29: TEdit
        Left = 110
        Top = 180
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 29
        OnDblClick = Edit1DblClick
      end
      object Edit30: TEdit
        Left = 180
        Top = 180
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 30
        OnDblClick = Edit1DblClick
      end
      object Edit31: TEdit
        Left = 250
        Top = 180
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 31
        OnDblClick = Edit1DblClick
      end
      object Edit32: TEdit
        Left = 320
        Top = 180
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 32
        OnDblClick = Edit1DblClick
      end
      object Edit33: TEdit
        Left = 390
        Top = 180
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 33
        OnDblClick = Edit1DblClick
      end
      object Edit34: TEdit
        Left = 460
        Top = 180
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 34
      end
      object Edit35: TEdit
        Left = 530
        Top = 180
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 35
      end
      object Edit36: TEdit
        Left = 110
        Top = 210
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 36
        OnDblClick = Edit1DblClick
      end
      object Edit37: TEdit
        Left = 180
        Top = 210
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 37
        OnDblClick = Edit1DblClick
      end
      object Edit38: TEdit
        Left = 250
        Top = 210
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 38
        OnDblClick = Edit1DblClick
      end
      object Edit39: TEdit
        Left = 320
        Top = 210
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 39
        OnDblClick = Edit1DblClick
      end
      object Edit40: TEdit
        Left = 390
        Top = 210
        Width = 41
        Height = 21
        ReadOnly = True
        TabOrder = 40
        OnDblClick = Edit1DblClick
      end
      object Edit41: TEdit
        Left = 460
        Top = 210
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 41
      end
      object Edit42: TEdit
        Left = 530
        Top = 210
        Width = 41
        Height = 21
        Color = clYellow
        ReadOnly = True
        TabOrder = 42
      end
      object cbb: TComboBox
        Left = 30
        Top = 60
        Width = 69
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbbChange
      end
    end
  end
  object ToolBar: TToolBar [2]
    Left = 0
    Top = 0
    Width = 1084
    Height = 40
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 88
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 2
    Wrapable = False
    object btn_query: TToolButton
      Left = 0
      Top = 2
      AutoSize = True
      Caption = #26597#35426
      ImageIndex = 11
      OnClick = btn_queryClick
    end
    object btn_export: TToolButton
      Left = 37
      Top = 2
      AutoSize = True
      Caption = #21295#20986'Excel'
      ImageIndex = 10
      OnClick = btn_exportClick
    end
    object btn1: TToolButton
      Left = 100
      Top = 2
      AutoSize = True
      Caption = #21295#20986#28165#21934
      ImageIndex = 10
      OnClick = btn1Click
    end
    object btn_print: TToolButton
      Left = 163
      Top = 2
      AutoSize = True
      Caption = #21015#21360
      ImageIndex = 9
      OnClick = btn_printClick
    end
    object ToolButton1: TToolButton
      Left = 200
      Top = 2
      Width = 4
      Caption = 'ToolButton1'
      ImageIndex = 55
      Style = tbsSeparator
    end
    object btn2: TToolButton
      Left = 204
      Top = 2
      AutoSize = True
      Caption = #21462#28040#30906#35469
      ImageIndex = 48
      OnClick = btn2Click
    end
    object btn_email: TToolButton
      Left = 267
      Top = 2
      AutoSize = True
      Caption = 'Email'#36890#30693
      ImageIndex = 59
      OnClick = btn_emailClick
    end
    object btn3: TToolButton
      Left = 332
      Top = 2
      AutoSize = True
      Caption = #26356#26032#21934#37325
      ImageIndex = 58
      OnClick = btn3Click
    end
    object btn4: TToolButton
      Left = 395
      Top = 2
      AutoSize = True
      Caption = #23529#26680'/'#21462#28040#23529#26680
      ImageIndex = 54
      OnClick = btn4Click
    end
    object ToolButton2: TToolButton
      Left = 487
      Top = 2
      Width = 4
      Caption = 'ToolButton2'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn5: TToolButton
      Left = 491
      Top = 2
      AutoSize = True
      Caption = #38626#38283
      ImageIndex = 19
      OnClick = btn5Click
    end
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 56
    Top = 333
  end
  object DS2: TDataSource
    DataSet = CDS2
    Left = 84
    Top = 333
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = CDS1AfterScroll
    Left = 56
    Top = 361
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 84
    Top = 360
  end
  object IdSMTP1: TIdSMTP
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 25
    AuthenticationType = atNone
    Left = 112
    Top = 360
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    Recipients = <>
    ReplyTo = <>
    Left = 140
    Top = 360
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 180
    Top = 360
  end
end
