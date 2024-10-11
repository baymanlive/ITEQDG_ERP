object FrmIPQCT620: TFrmIPQCT620
  Left = -8
  Top = -8
  Width = 1936
  Height = 973
  Caption = #35519#33184#30332#24037#21934
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #26032#32048#26126#39636
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1920
    Height = 241
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      1920
      241)
    object Bevel1: TBevel
      Left = 2
      Top = 228
      Width = 100
      Height = 9
      Shape = bsTopLine
    end
    object Label8: TLabel
      Left = 1681
      Top = 120
      Width = 96
      Height = 96
      Anchors = [akTop, akRight]
      Caption = #22136
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -96
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 180
      Top = 10
      Width = 266
      Height = 108
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -80
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = #33184#31995
      OnChange = Edit1Change
    end
    object Button1: TButton
      Left = 1782
      Top = 120
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #30906#23450
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button1Click
    end
    object Edit3: TEdit
      Left = 10
      Top = 120
      Width = 1396
      Height = 108
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -80
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = #25209#34399
    end
    object Edit4: TEdit
      Left = 1408
      Top = 120
      Width = 270
      Height = 108
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -80
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = #35519#33184#37327
    end
    object cbb2: TComboBox
      Left = 452
      Top = 10
      Width = 1470
      Height = 101
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -93
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ItemHeight = 93
      ParentFont = False
      TabOrder = 4
    end
    object cbb1: TComboBox
      Left = 10
      Top = 10
      Width = 165
      Height = 101
      Style = csDropDownList
      DropDownCount = 5
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -93
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ItemHeight = 93
      ItemIndex = 0
      ParentFont = False
      TabOrder = 5
      Text = 'B1'
      OnChange = cbb1Change
      Items.Strings = (
        'B1'
        'B2'
        'B3'
        'B4'
        'B5'
        'B6'
        'B7'
        'B8'
        'B9'
        'B10')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 815
    Width = 1920
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1920
      120)
    object Label9: TLabel
      Left = 776
      Top = 12
      Width = 933
      Height = 97
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#20633#35387#35387#20633#35387
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 166
      Top = 36
      Width = 350
      Height = 49
      AutoSize = False
      Caption = #25237#20837#37327#65306'0/0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 2
      Top = 3
      Width = 100
      Height = 9
      Shape = bsTopLine
    end
    object Label1: TLabel
      Left = 10
      Top = 36
      Width = 110
      Height = 49
      AutoSize = False
      Caption = '0/0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 1494
      Top = 10
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #19978#19968#27493
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 1638
      Top = 10
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #19979#19968#27493
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 1782
      Top = 10
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #23436#25104
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 1118
      Top = 10
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #31532#19968#27493
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 1262
      Top = 10
      Width = 140
      Height = 100
      Anchors = [akTop, akRight]
      Caption = #20316#24290
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button6Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 241
    Width = 1920
    Height = 574
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      1920
      574)
    object Label2: TLabel
      Left = 10
      Top = 10
      Width = 1740
      Height = 92
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #38917#30446#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label3: TLabel
      Left = 10
      Top = 116
      Width = 1233
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #35336#21123#37327'(kg)'#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Top = 240
      Width = 1233
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #20801#35377#35492#24046#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 1408
      Top = 342
      Width = 381
      Height = 46
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = #23526#38555#25237#20837#37327'(kg)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 1408
      Top = 454
      Width = 397
      Height = 46
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = #21407#26009#25209#34399
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 743
      Top = -4
      Width = 381
      Height = 46
      AutoSize = False
      Caption = #36984#25799#29289#26009
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 10
      Top = 344
      Width = 1347
      Height = 46
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = #25475#25551#32080#26524#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object RichEdit1: TRichEdit
      Left = 386
      Top = 112
      Width = 185
      Height = 89
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Enabled = False
      Font.Charset = CHINESEBIG5_CHARSET
      Font.Color = clBlue
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEdit1')
      ParentFont = False
      TabOrder = 2
    end
    object DBEdit1: TDBEdit
      Left = 1408
      Top = 390
      Width = 300
      Height = 56
      Anchors = [akRight, akBottom]
      DataField = 'in_kg'
      DataSource = DS
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 1408
      Top = 502
      Width = 510
      Height = 56
      Anchors = [akRight, akBottom]
      DataField = 'srclot'
      DataSource = DS
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object cbb3: TDBComboBoxEh
      Left = 775
      Top = 4
      Width = 300
      Height = 48
      DataField = 'srcpno'
      DataSource = DS
      DynProps = <>
      EditButtons = <>
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = #26032#32048#26126#39636
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = True
    end
  end
  object Conn: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=dgiteq;Persist Security Info=True;U' +
      'ser ID=sa;Initial Catalog=erp2015;Data Source=192.168.4.14'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 392
    Top = 564
  end
  object ADOQuery1: TADOQuery
    Connection = Conn
    Parameters = <>
    Left = 420
    Top = 564
  end
  object XPManifest1: TXPManifest
    Left = 532
    Top = 564
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ADOQuery1
    Left = 448
    Top = 564
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 476
    Top = 564
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 504
    Top = 564
  end
  object ADOQuery2: TADOQuery
    Connection = Conn
    Parameters = <>
    Left = 420
    Top = 592
  end
  object ADOQuery3: TADOQuery
    Connection = Conn
    Parameters = <>
    Left = 448
    Top = 592
  end
  object ADOQuery4: TADOQuery
    Connection = Conn
    Parameters = <>
    Left = 476
    Top = 592
  end
end
