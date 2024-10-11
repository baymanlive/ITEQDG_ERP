inherited FrmShowErrList: TFrmShowErrList
  Left = 201
  Top = 151
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
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
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
