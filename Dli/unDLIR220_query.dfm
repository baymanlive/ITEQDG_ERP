inherited FrmDLIR220_query: TFrmDLIR220_query
  Width = 480
  Height = 240
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 62
    Top = 52
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 195
    Top = 52
    Width = 21
    Height = 13
    Caption = 'lblto'
  end
  inherited PnlRight: TPanel
    Left = 354
    Height = 201
    TabOrder = 3
  end
  object rgp: TRadioGroup [3]
    Left = 44
    Top = 104
    Width = 261
    Height = 40
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'ITEQDG'
      'ITEQGZ')
    TabOrder = 2
  end
  object dtp1: TDateTimePicker [4]
    Left = 96
    Top = 48
    Width = 90
    Height = 21
    Date = 43713.000000000000000000
    Time = 43713.000000000000000000
    TabOrder = 0
  end
  object dtp2: TDateTimePicker [5]
    Left = 216
    Top = 48
    Width = 90
    Height = 21
    Date = 43713.000000000000000000
    Time = 43713.000000000000000000
    TabOrder = 1
  end
end
