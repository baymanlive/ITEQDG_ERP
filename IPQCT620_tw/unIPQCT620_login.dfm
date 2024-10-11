object FrmIPQCT620_login: TFrmIPQCT620_login
  Left = 192
  Top = 125
  BorderStyle = bsDialog
  Caption = #30331#20837
  ClientHeight = 211
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #26032#32048#26126#39636
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 67
    Top = 52
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = #24115#34399':'
  end
  object Label2: TLabel
    Left = 67
    Top = 92
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = #23494#30908':'
  end
  object logo: TLabel
    Tag = 1
    Left = 10
    Top = 10
    Width = 64
    Height = 29
    Caption = 'ITEQ'
    Font.Charset = CHINESEBIG5_CHARSET
    Font.Color = clGreen
    Font.Height = -29
    Font.Name = #27161#26999#39636
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 101
    Top = 49
    Width = 150
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 101
    Top = 89
    Width = 150
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 100
    Top = 129
    Width = 70
    Height = 25
    Caption = #30906#23450
    TabOrder = 2
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 180
    Top = 129
    Width = 70
    Height = 25
    Caption = #36864#20986
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkClose
  end
end
