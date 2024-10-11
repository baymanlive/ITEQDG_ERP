inherited FrmSysI020: TFrmSysI020
  BorderStyle = bsNone
  Caption = 'FrmSysI020'
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pprocid: TLabel [0]
    Left = 380
    Top = 108
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'pprocid'
  end
  object pprocname: TLabel [1]
    Left = 363
    Top = 143
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'pprocname'
  end
  object procid: TLabel [2]
    Left = 386
    Top = 228
    Width = 30
    Height = 13
    Alignment = taRightJustify
    Caption = 'procid'
  end
  object procname: TLabel [3]
    Left = 369
    Top = 263
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'procname'
  end
  object dllpath: TLabel [4]
    Left = 384
    Top = 298
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'dllpath'
  end
  object snoasc: TLabel [5]
    Left = 384
    Top = 333
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'snoasc'
  end
  object Bevel1: TBevel [6]
    Left = 320
    Top = 192
    Width = 500
    Height = 21
    Shape = bsTopLine
  end
  object nid: TLabel [7]
    Left = 401
    Top = 73
    Width = 15
    Height = 13
    Alignment = taRightJustify
    Caption = 'nid'
  end
  object actions: TLabel [8]
    Left = 383
    Top = 368
    Width = 33
    Height = 13
    Alignment = taRightJustify
    Caption = 'actions'
  end
  object btn_sp: TSpeedButton [9]
    Left = 820
    Top = 365
    Width = 23
    Height = 22
    OnClick = btn_spClick
  end
  object ToolBar: TToolBar [10]
    Left = 0
    Top = 0
    Width = 954
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 73
    Flat = True
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 0
    object btn_insert: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #26032#22686
      ImageIndex = 4
      OnClick = btn_insertClick
    end
    object btn_edit: TToolButton
      Left = 37
      Top = 0
      AutoSize = True
      Caption = #26356#25913
      ImageIndex = 5
      OnClick = btn_editClick
    end
    object btn_delete: TToolButton
      Left = 74
      Top = 0
      AutoSize = True
      Caption = #21034#38500
      ImageIndex = 6
      OnClick = btn_deleteClick
    end
    object ToolButton2: TToolButton
      Left = 111
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_openright: TToolButton
      Left = 119
      Top = 0
      Caption = 'btn_openright'
      ImageIndex = 23
      OnClick = btn_openrightClick
    end
    object btn_quit: TToolButton
      Left = 192
      Top = 0
      AutoSize = True
      Caption = #38626#38283
      ImageIndex = 19
      OnClick = btn_quitClick
    end
  end
  object TV: TTreeView [11]
    Left = 6
    Top = 44
    Width = 300
    Height = 472
    Align = alLeft
    BevelOuter = bvNone
    BorderStyle = bsNone
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 1
    OnClick = TVClick
  end
  object Edit2: TEdit [12]
    Left = 420
    Top = 105
    Width = 150
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 3
  end
  object Edit3: TEdit [13]
    Left = 420
    Top = 140
    Width = 150
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 4
  end
  object Edit4: TEdit [14]
    Left = 420
    Top = 225
    Width = 150
    Height = 21
    TabOrder = 5
  end
  object Edit5: TEdit [15]
    Left = 420
    Top = 260
    Width = 150
    Height = 21
    TabOrder = 6
  end
  object Panel1: TPanel [16]
    Left = 0
    Top = 38
    Width = 954
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 10
  end
  object Edit6: TEdit [17]
    Left = 420
    Top = 295
    Width = 150
    Height = 21
    TabOrder = 7
  end
  object Edit7: TEdit [18]
    Left = 420
    Top = 330
    Width = 150
    Height = 21
    TabOrder = 8
  end
  object Edit1: TEdit [19]
    Left = 420
    Top = 70
    Width = 150
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 2
  end
  object Panel2: TPanel [20]
    Left = 0
    Top = 44
    Width = 6
    Height = 472
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 11
  end
  object Panel3: TPanel [21]
    Left = 0
    Top = 516
    Width = 954
    Height = 5
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 12
  end
  object isexe: TCheckBox [22]
    Left = 420
    Top = 400
    Width = 97
    Height = 17
    Caption = 'isexe'
    TabOrder = 13
  end
  object ispop: TCheckBox [23]
    Left = 420
    Top = 430
    Width = 97
    Height = 17
    Caption = 'ispop'
    TabOrder = 14
  end
  object Edit8: TEdit [24]
    Left = 420
    Top = 365
    Width = 400
    Height = 21
    TabOrder = 9
  end
  inherited ImageList1: TImageList
    Left = 676
    Top = 4
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 648
    Top = 4
  end
end
