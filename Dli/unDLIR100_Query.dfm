inherited FrmDLIR100_Query: TFrmDLIR100_Query
  Width = 500
  Height = 320
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 92
    Top = 78
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  inherited PnlRight: TPanel
    Left = 374
    Height = 281
    TabOrder = 4
  end
  object Edit1: TEdit [2]
    Left = 128
    Top = 74
    Width = 150
    Height = 21
    TabOrder = 1
  end
  object btn_query: TBitBtn [3]
    Left = 285
    Top = 72
    Width = 41
    Height = 25
    Hint = #26597#35426#25187#24115#25209#34399
    Caption = #26597#35426
    TabOrder = 2
    OnClick = btn_queryClick
  end
  object rgp: TRadioGroup [4]
    Left = 88
    Top = 10
    Width = 240
    Height = 48
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'ITEQDG'
      'ITEQGZ'
      'ITEQHJ')
    TabOrder = 0
  end
  object Memo1: TMemo [5]
    Left = 88
    Top = 108
    Width = 240
    Height = 109
    Hint = #24453#26597#35426#20986#36008#21934#20449#24687#30340#25209#34399','#19968#20491#25209#34399#19968#34892
    TabOrder = 3
  end
end
