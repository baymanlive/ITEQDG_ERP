inherited FrmMPST070_Print: TFrmMPST070_Print
  Width = 550
  Height = 320
  Caption = #21015#21360#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  object lblsdate: TLabel [0]
    Left = 68
    Top = 48
    Width = 36
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblsdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 208
    Top = 48
    Width = 32
    Height = 13
    Alignment = taCenter
    Caption = 'Label1'
  end
  inherited PnlRight: TPanel
    Left = 424
    Height = 281
  end
  object dtp1: TDateTimePicker [3]
    Left = 104
    Top = 44
    Width = 100
    Height = 21
    Date = 43816.000000000000000000
    Time = 43816.000000000000000000
    TabOrder = 1
  end
  object dtp2: TDateTimePicker [4]
    Left = 244
    Top = 44
    Width = 100
    Height = 21
    Date = 43816.000000000000000000
    Time = 43816.000000000000000000
    TabOrder = 2
  end
  object RG1: TRadioGroup [5]
    Left = 68
    Top = 100
    Width = 290
    Height = 101
    Columns = 5
    TabOrder = 3
  end
end
