inherited FrmMPST070_ShowErrList: TFrmMPST070_ShowErrList
  Width = 700
  Height = 400
  ActiveControl = Memo1
  Caption = #37679#35492#25552#31034
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 574
    Height = 361
    TabOrder = 1
    inherited btn_ok: TBitBtn
      Glyph.Data = {00000000}
    end
  end
  object Memo1: TMemo [1]
    Left = 0
    Top = 0
    Width = 574
    Height = 361
    Hint = #35330#21934#21934#34399'/'#38917#27425'/'#26009#34399'/'#26410#25490#21407#22240
    Align = alClient
    BevelOuter = bvNone
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = #25991#26412#25991#20214'(*.txt)|*.txt'
    Left = 116
    Top = 245
  end
end
