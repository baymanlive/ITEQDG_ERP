inherited FrmIPQCT510_query: TFrmIPQCT510_query
  Width = 500
  Height = 280
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 114
    Top = 68
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label2: TLabel [1]
    Left = 114
    Top = 103
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label3: TLabel [2]
    Left = 114
    Top = 138
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label4: TLabel [3]
    Left = 114
    Top = 173
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  inherited PnlRight: TPanel
    Left = 374
    Height = 241
    TabOrder = 5
  end
  object dtp1: TDateTimePicker [5]
    Left = 150
    Top = 65
    Width = 150
    Height = 21
    Date = 43069.000000000000000000
    Time = 43069.000000000000000000
    TabOrder = 1
  end
  object dtp2: TDateTimePicker [6]
    Left = 150
    Top = 100
    Width = 150
    Height = 21
    Date = 43069.000000000000000000
    Time = 43069.000000000000000000
    TabOrder = 2
  end
  object cbb: TComboBox [7]
    Left = 150
    Top = 135
    Width = 150
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object rgp: TRadioGroup [8]
    Left = 99
    Top = 15
    Width = 200
    Height = 37
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      'T1'
      'T2'
      'T3'
      'T4'
      'T5')
    TabOrder = 0
  end
  object Edit1: TEdit [9]
    Left = 150
    Top = 170
    Width = 150
    Height = 21
    TabOrder = 4
  end
end
