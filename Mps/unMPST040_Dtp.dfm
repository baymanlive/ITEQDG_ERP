inherited FrmMPST040_Dtp: TFrmMPST040_Dtp
  Left = 409
  Top = 284
  Width = 498
  Height = 170
  Caption = 'FrmMPST040_Dtp'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 380
    Height = 139
    inherited btn_ok: TBitBtn
      Top = 106
      Visible = False
    end
    inherited btn_quit: TBitBtn
      Top = 8
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 380
    Height = 139
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 42
      Width = 65
      Height = 13
      Caption = #20986#36008#26085#26399#65306
    end
    object dtp1: TDateTimePicker
      Left = 94
      Top = 38
      Width = 107
      Height = 21
      Date = 44573.358876203700000000
      Time = 44573.358876203700000000
      TabOrder = 0
    end
    object BtnMpst040Export: TButton
      Left = 224
      Top = 36
      Width = 95
      Height = 25
      Caption = #26597#35426#23566#20986
      TabOrder = 1
      OnClick = BtnMpst040ExportClick
    end
  end
end
