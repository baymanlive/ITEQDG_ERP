inherited FrmExport: TFrmExport
  Left = 196
  Top = 126
  Width = 680
  Height = 500
  Hint = '  '
  Caption = 'Export'
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel [0]
    Left = 553
    Top = 0
    Width = 111
    Height = 462
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object btn_ok: TBitBtn
      Left = 10
      Top = 80
      Width = 90
      Height = 25
      Caption = 'btn_ok'
      TabOrder = 2
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
    object btn_quit: TBitBtn
      Left = 10
      Top = 110
      Width = 90
      Height = 26
      Caption = 'btn_quit'
      TabOrder = 3
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
    object btn_reset: TBitBtn
      Left = 10
      Top = 50
      Width = 90
      Height = 25
      Caption = 'btn_reset'
      TabOrder = 1
      OnClick = btn_resetClick
      NumGlyphs = 2
    end
    object btn_save: TBitBtn
      Left = 10
      Top = 20
      Width = 90
      Height = 25
      Caption = 'btn_save'
      TabOrder = 0
      OnClick = btn_saveClick
      NumGlyphs = 2
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 553
    Height = 462
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      553
      462)
    object btn_IncludeBtn: TSpeedButton
      Left = 266
      Top = 124
      Width = 23
      Height = 26
      Caption = '>'
      OnClick = btn_IncludeBtnClick
    end
    object btn_IncAllBtn: TSpeedButton
      Left = 266
      Top = 160
      Width = 23
      Height = 24
      Caption = '>>'
      OnClick = btn_IncAllBtnClick
    end
    object btn_ExcludeBtn: TSpeedButton
      Left = 266
      Top = 195
      Width = 23
      Height = 24
      Caption = '<'
      Enabled = False
      OnClick = btn_ExcludeBtnClick
    end
    object btn_ExcAllBtn: TSpeedButton
      Left = 266
      Top = 230
      Width = 23
      Height = 24
      Caption = '<<'
      Enabled = False
      OnClick = btn_ExcAllBtnClick
    end
    object btn_up: TSpeedButton
      Left = 367
      Top = 4
      Width = 17
      Height = 17
      Caption = #9650
      Flat = True
      OnClick = btn_upClick
    end
    object btn_down: TSpeedButton
      Left = 386
      Top = 4
      Width = 17
      Height = 17
      Caption = #9660
      Flat = True
      OnClick = btn_downClick
    end
    object gb1: TGroupBox
      Left = 7
      Top = 20
      Width = 251
      Height = 438
      Anchors = [akLeft, akTop, akBottom]
      Caption = #21487#36984#27396#20301
      TabOrder = 0
      DesignSize = (
        251
        438)
      object SrcList: TListBox
        Left = 7
        Top = 20
        Width = 231
        Height = 408
        Anchors = [akLeft, akTop, akBottom]
        BorderStyle = bsNone
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
    end
    object gb2: TGroupBox
      Left = 296
      Top = 20
      Width = 250
      Height = 438
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = #21295#20986#27396#20301
      TabOrder = 1
      DesignSize = (
        250
        438)
      object DstList: TListBox
        Left = 7
        Top = 20
        Width = 231
        Height = 408
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
    end
    object chkAll: TCheckBox
      Left = 432
      Top = 4
      Width = 97
      Height = 18
      Caption = 'chkAll'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
end
