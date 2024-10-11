inherited FrmDLIR110_Query: TFrmDLIR110_Query
  Width = 540
  Height = 413
  Caption = #26597#35426
  PixelsPerInch = 96
  TextHeight = 13
  object lblorderdate: TLabel [0]
    Left = 60
    Top = 28
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderdate'
  end
  object lblto: TLabel [1]
    Tag = 1
    Left = 214
    Top = 29
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblto'
  end
  object Label1: TLabel [2]
    Left = 84
    Top = 58
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label3: TLabel [3]
    Tag = 1
    Left = 203
    Top = 59
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object lblcustno: TLabel [4]
    Left = 73
    Top = 118
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblcustno'
  end
  object lblorderno: TLabel [5]
    Left = 67
    Top = 148
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblorderno'
  end
  object Label2: TLabel [6]
    Left = 84
    Top = 178
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label2'
  end
  object lblsaledate: TLabel [7]
    Left = 67
    Top = 88
    Width = 49
    Height = 13
    Alignment = taRightJustify
    Caption = 'lblsaledate'
  end
  object Label4: TLabel [8]
    Tag = 1
    Left = 203
    Top = 89
    Width = 32
    Height = 13
    Alignment = taRightJustify
    Caption = 'Label1'
  end
  object Label5: TLabel [9]
    Left = 68
    Top = 268
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object Label6: TLabel [10]
    Left = 68
    Top = 300
    Width = 32
    Height = 13
    Caption = 'Label6'
  end
  inherited PnlRight: TPanel
    Left = 414
    Height = 374
    TabOrder = 10
  end
  object Dtp1: TDateTimePicker [12]
    Left = 120
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 0
  end
  object Dtp2: TDateTimePicker [13]
    Left = 240
    Top = 25
    Width = 90
    Height = 21
    Date = 42921.000000000000000000
    Time = 42921.000000000000000000
    TabOrder = 1
  end
  object Dtp3: TDBDateTimeEditEh [14]
    Left = 120
    Top = 55
    Width = 90
    Height = 21
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateEh
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Visible = True
  end
  object Dtp4: TDBDateTimeEditEh [15]
    Left = 240
    Top = 55
    Width = 90
    Height = 21
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateEh
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = True
  end
  object Edit1: TEdit [16]
    Left = 120
    Top = 115
    Width = 210
    Height = 21
    TabOrder = 6
  end
  object Edit2: TEdit [17]
    Left = 120
    Top = 145
    Width = 210
    Height = 21
    TabOrder = 7
  end
  object Edit3: TEdit [18]
    Left = 120
    Top = 175
    Width = 210
    Height = 21
    TabOrder = 8
  end
  object Rgp: TRadioGroup [19]
    Left = 120
    Top = 203
    Width = 210
    Height = 45
    Columns = 3
    Items.Strings = (
      '1'
      '2'
      '3')
    TabOrder = 9
  end
  object Dtp5: TDBDateTimeEditEh [20]
    Left = 120
    Top = 85
    Width = 90
    Height = 21
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateEh
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Visible = True
  end
  object Dtp6: TDBDateTimeEditEh [21]
    Left = 240
    Top = 85
    Width = 90
    Height = 21
    DynProps = <>
    EditButtons = <>
    Kind = dtkDateEh
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Visible = True
  end
end
