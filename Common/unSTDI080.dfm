inherited FrmSTDI080: TFrmSTDI080
  BorderStyle = bsNone
  Caption = 'FrmSTDI080'
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar [0]
    Left = 0
    Top = 0
    Width = 584
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 59
    Flat = True
    Images = ImageList1
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 0
    Wrapable = False
    object btn_print: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = #21015#21360
      ImageIndex = 9
    end
    object btn_export: TToolButton
      Left = 37
      Top = 0
      AutoSize = True
      Caption = #21295#20986'Excel'
      ImageIndex = 10
    end
    object btn_query: TToolButton
      Left = 100
      Top = 0
      AutoSize = True
      Caption = #26597#35426
      ImageIndex = 11
    end
    object ToolButton1: TToolButton
      Left = 137
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_quit: TToolButton
      Left = 145
      Top = 0
      AutoSize = True
      Caption = #38626#38283
      ImageIndex = 19
      OnClick = btn_quitClick
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 38
    Width = 584
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  inherited ImageList1: TImageList
    Left = 841
    Top = 5
  end
end
