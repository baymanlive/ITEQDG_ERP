inherited FrmPW: TFrmPW
  BorderStyle = bsDialog
  Caption = 'FrmPW'
  ClientHeight = 196
  ClientWidth = 384
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pw1: TLabel [0]
    Left = 141
    Top = 28
    Width = 21
    Height = 13
    Alignment = taRightJustify
    BiDiMode = bdLeftToRight
    Caption = 'pw1'
    ParentBiDiMode = False
  end
  object pw2: TLabel [1]
    Left = 141
    Top = 58
    Width = 21
    Height = 13
    Alignment = taRightJustify
    BiDiMode = bdLeftToRight
    Caption = 'pw2'
    ParentBiDiMode = False
  end
  object pw3: TLabel [2]
    Left = 141
    Top = 88
    Width = 21
    Height = 13
    Alignment = taRightJustify
    BiDiMode = bdLeftToRight
    Caption = 'pw3'
    ParentBiDiMode = False
  end
  object Edit1: TEdit [3]
    Left = 165
    Top = 25
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object Edit2: TEdit [4]
    Left = 165
    Top = 55
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Edit3: TEdit [5]
    Left = 165
    Top = 85
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object btn_ok: TBitBtn [6]
    Left = 95
    Top = 130
    Width = 80
    Height = 25
    Caption = 'btn_ok'
    TabOrder = 3
    OnClick = btn_okClick
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
  object btn_quit: TBitBtn [7]
    Left = 220
    Top = 130
    Width = 80
    Height = 25
    Caption = 'btn_quit'
    TabOrder = 4
    OnClick = btn_quitClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
end
