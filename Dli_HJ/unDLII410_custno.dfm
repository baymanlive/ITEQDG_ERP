inherited FrmDLII410_custno: TFrmDLII410_custno
  Width = 520
  Height = 280
  Caption = #26356#25913#23458#25142
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblcustno: TLabel [0]
    Tag = 1
    Left = 56
    Top = 10
    Width = 43
    Height = 13
    Caption = 'lblcustno'
  end
  object lblcustshort: TLabel [1]
    Tag = 1
    Left = 200
    Top = 10
    Width = 55
    Height = 13
    Caption = 'lblcustshort'
  end
  inherited PnlRight: TPanel
    Left = 394
    Height = 241
    TabOrder = 2
  end
  object Memo1: TMemo [3]
    Left = 56
    Top = 30
    Width = 137
    Height = 177
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
    OnChange = Memo1Change
  end
  object Memo2: TMemo [4]
    Left = 200
    Top = 30
    Width = 137
    Height = 177
    Enabled = False
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
  end
end
