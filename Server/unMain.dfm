object FrmMain: TFrmMain
  Left = 284
  Top = 147
  Width = 979
  Height = 563
  Caption = 'ERP_APPServer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object WB: TWebBrowser
    Left = 0
    Top = 0
    Width = 971
    Height = 495
    Align = alClient
    PopupMenu = PopupMenu2
    TabOrder = 0
    ControlData = {
      4C0000005B640000293300000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object SB: TStatusBar
    Left = 0
    Top = 495
    Width = 971
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object PopupMenu2: TPopupMenu
    Left = 196
    Top = 92
    object n_close: TMenuItem
      Caption = 'Exit'
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 172
    Top = 92
    object N1: TMenuItem
      Caption = 'Tools'
      object N2: TMenuItem
        Caption = 'Refresh'
        OnClick = N2Click
      end
      object N5: TMenuItem
        Caption = 'Save Log'
        OnClick = N5Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = 'Exit'
        OnClick = N4Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 224
    Top = 92
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 256
    Top = 92
  end
end
